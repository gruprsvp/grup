import jwt
import pytest
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import ec
from typer.testing import CliRunner

from app_transfer import siwa
from app_transfer.cli import app


@pytest.fixture
def secret_args(tmp_path):
    pem = ec.generate_private_key(ec.SECP256R1()).private_bytes(
        serialization.Encoding.PEM, serialization.PrivateFormat.PKCS8, serialization.NoEncryption())
    (tmp_path / "k.p8").write_bytes(pem)
    return ["siwa", "secret", "--team", "T", "--key-id", "K", "--key", str(tmp_path / "k.p8"), "--client-id", "web.id"]


def test_siwa_secret(secret_args):
    r = CliRunner().invoke(app, secret_args)
    assert r.exit_code == 0, r.output
    token = r.output.split()[0]
    assert jwt.get_unverified_header(token)["kid"] == "K"
    assert jwt.decode(token, options={"verify_signature": False})["sub"] == "web.id"


class Response:
    def __init__(self, status_code, text=""):
        self.status_code, self.text = status_code, text


@pytest.fixture
def apple(monkeypatch):
    """Apple's answer to the pre-flight token request; tests may replace it."""
    answer = {"response": Response(200, '{"access_token":"a"}')}
    monkeypatch.setattr(siwa.requests, "post", lambda url, **kw: answer["response"])
    return answer


def test_siwa_secret_sets_supabase_without_printing_it(secret_args, apple, monkeypatch):
    calls = []
    monkeypatch.setattr(siwa.requests, "patch", lambda url, **kw: calls.append((url, kw)) or Response(200))
    r = CliRunner().invoke(app, [*secret_args, "--supabase-project", "ref123"],
                           env={"SUPABASE_ACCESS_TOKEN": "sbp_fc_x"})
    assert r.exit_code == 0, r.output
    (url, kw), = calls
    assert url == "https://api.supabase.com/v1/projects/ref123/config/auth"
    assert kw["headers"] == {"Authorization": "Bearer sbp_fc_x"}
    token = kw["json"]["external_apple_secret"]
    assert jwt.decode(token, options={"verify_signature": False})["sub"] == "web.id"
    assert token not in r.output  # CI logs must not carry the secret


def test_siwa_secret_keeps_supabase_when_apple_rejects_it(secret_args, apple, monkeypatch):
    apple["response"] = Response(400, '{"error":"invalid_client"}')
    calls = []
    monkeypatch.setattr(siwa.requests, "patch", lambda url, **kw: calls.append(url) or Response(200))
    r = CliRunner().invoke(app, [*secret_args, "--supabase-project", "ref123"],
                           env={"SUPABASE_ACCESS_TOKEN": "sbp_fc_x"})
    assert r.exit_code == 1
    assert "invalid_client" in r.output
    assert calls == []


def test_siwa_secret_fails_when_supabase_refuses(secret_args, apple, monkeypatch):
    monkeypatch.setattr(siwa.requests, "patch", lambda url, **kw: Response(403, '{"missing_permissions":["x"]}'))
    r = CliRunner().invoke(app, [*secret_args, "--supabase-project", "ref123"],
                           env={"SUPABASE_ACCESS_TOKEN": "sbp_fc_x"})
    assert r.exit_code == 1
    assert "403" in r.output


def test_siwa_secret_needs_supabase_token(secret_args, monkeypatch):
    monkeypatch.delenv("SUPABASE_ACCESS_TOKEN", raising=False)
    r = CliRunner().invoke(app, [*secret_args, "--supabase-project", "ref123"])
    assert r.exit_code == 1
    assert "SUPABASE_ACCESS_TOKEN" in r.output


def test_missing_key_file_is_rejected():
    r = CliRunner().invoke(app, ["siwa", "exchange", "nope.csv", "out.sql", "--team", "T",
                                 "--key-id", "K", "--key", "nope.p8", "--client-id", "x"])
    assert r.exit_code == 2
