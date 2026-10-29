from app_transfer.siwa import migration_sql

ROW = {"user_id": "00000000-0000-0000-0000-000000000001", "sub": "old.1", "email": "o'brien@privaterelay.appleid.com"}


def test_private_relay_user_gets_new_email():
    sql = migration_sql([(ROW, {"sub": "new.1", "email": "x@privaterelay.appleid.com", "is_private_email": True})])
    assert "provider_id = 'new.1'" in sql
    assert "and provider_id = 'old.1';" in sql
    assert "update auth.users set email = 'x@privaterelay.appleid.com'" in sql
    assert "email = 'o''brien@privaterelay.appleid.com';" in sql  # quotes escaped


def test_duplicate_identity_delete_only_while_old_identity_exists():
    # Without the guard, re-running the SQL would delete the already-migrated identity.
    delete = next(l for l in migration_sql([(ROW, {"sub": "new.1"})]).splitlines() if l.startswith("delete"))
    assert "provider_id = 'new.1' and exists (" in delete
    assert "provider_id = 'old.1');" in delete


def test_public_email_user_keeps_email():
    sql = migration_sql([(ROW, {"sub": "new.1"})])
    assert "update auth.users" not in sql
    assert '"email"' not in sql


def test_empty_input_is_valid_noop():
    sql = migration_sql([])
    assert "in ()" not in sql
    assert "begin;\ncommit;" in sql
