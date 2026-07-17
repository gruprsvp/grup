-- Vendored replacement for the original dbdev-based migration.
--
-- The original file installed the supabase-dbdev package manager by fetching
-- its SQL over HTTP from api.database.dev AT DEPLOY TIME (with a hard-coded
-- anon key) and used it to install the 'kiwicopple-pg_idkit' TLE. That made
-- every fresh environment depend on an external service being up and
-- serving unchanged code — a reproducibility and supply-chain liability —
-- while the only thing the schema ever used from the package is
-- gen_random_uuid_v7().
--
-- This file vendors that one function, pinned verbatim from
-- kiwicopple-pg_idkit 0.0.4 (the version installed in production). The
-- package's unused companions (gen_random_uuid_v6, gen_random_ksuid_second,
-- gen_random_ksuid_microsecond, timestamp_from_uuid_v7) are deliberately not
-- vendored; neither are the http/pg_tle extensions the installer needed.
--
-- Production note: prod recorded the ORIGINAL migration in its history, so
-- this file is never re-applied there. The only difference is cosmetic: on
-- prod the function is owned by the pgtle-managed extension, on fresh
-- environments it is a plain function. Definition and behavior are identical.

create or replace function public.gen_random_uuid_v7()
    returns uuid
    language plpgsql
as
$$
declare
        v_time timestamp with time zone:= null;
        v_secs bigint := null;
        v_msec bigint := null;
        v_usec bigint := null;

        v_timestamp bigint := null;
        v_timestamp_hex varchar := null;

        v_random bigint := null;
        v_random_hex varchar := null;

        v_bytes bytea;

        c_variant bit(64):= x'8000000000000000'; -- RFC-4122 variant: b'10xx...'
begin

        -- Get seconds and micros
        v_time := clock_timestamp();
        v_secs := EXTRACT(EPOCH FROM v_time);
        v_msec := mod(EXTRACT(MILLISECONDS FROM v_time)::numeric, 10^3::numeric);
        v_usec := mod(EXTRACT(MICROSECONDS FROM v_time)::numeric, 10^3::numeric);

        -- Generate timestamp hexadecimal (and set version 7)
        v_timestamp := (((v_secs * 10^3) + v_msec)::bigint << 12) | (v_usec << 2);
        v_timestamp_hex := lpad(to_hex(v_timestamp), 16, '0');
        v_timestamp_hex := substr(v_timestamp_hex, 2, 12) || '7' || substr(v_timestamp_hex, 14, 3);

        -- Generate the random hexadecimal (and set variant b'10xx')
        v_random := ((random()::numeric * 2^62::numeric)::bigint::bit(64) | c_variant)::bigint;
        v_random_hex := lpad(to_hex(v_random), 16, '0');

        -- Concat timestemp and random hexadecimal
        v_bytes := decode(v_timestamp_hex || v_random_hex, 'hex');

        return encode(v_bytes, 'hex')::uuid;

end $$;
