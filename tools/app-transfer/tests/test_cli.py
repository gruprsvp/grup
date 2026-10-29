import jwt
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import ec
from typer.testing import CliRunner

from app_transfer.cli import app


def test_siwa_secret(tmp_path):
    pem = ec.generate_private_key(ec.SECP256R1()).private_bytes(
        serialization.Encoding.PEM, serialization.PrivateFormat.PKCS8, serialization.NoEncryption())
    (tmp_path / "k.p8").write_bytes(pem)
    r = CliRunner().invoke(app, ["siwa", "secret", "--team", "T", "--key-id", "K",
                                 "--key", str(tmp_path / "k.p8"), "--client-id", "web.id"])
    assert r.exit_code == 0, r.output
    token = r.output.split()[0]
    assert jwt.get_unverified_header(token)["kid"] == "K"
    assert jwt.decode(token, options={"verify_signature": False})["sub"] == "web.id"


def test_missing_key_file_is_rejected():
    r = CliRunner().invoke(app, ["siwa", "exchange", "nope.csv", "out.sql", "--team", "T",
                                 "--key-id", "K", "--key", "nope.p8", "--client-id", "x"])
    assert r.exit_code == 2
