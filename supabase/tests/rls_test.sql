BEGIN;
SELECT plan(1);

-- Examples: https://pgtap.org/documentation.html

SELECT has_column(
               'auth',
               'users',
               'id',
               'id should exist'
       );

SELECT *
FROM finish();
ROLLBACK;
