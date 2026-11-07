# Tests that fail without an extracted disc cache

CI has no game assets, so these tests (one name per line, per core) fail there for that reason alone.
`run-checks.ps1` tolerates exactly the names listed and fails on any other failure. A green CI run therefore does
**not** verify these tests; run them locally with the asset cache present.

Fix them at the source instead of listing them: make each test return early (printing `SKIP`) when its assets are
absent, like the rest of the suite, then delete its line here.

Measured on a clean clone of each core's HEAD (no ignored files):
libcommon, libpikmin and libssbm pass; libsms has the failures listed in `libsms.txt`.
