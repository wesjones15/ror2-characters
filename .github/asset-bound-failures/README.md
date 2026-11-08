# Tests that fail without an extracted disc cache

CI has no game assets. If a core's tests fail there for that reason alone, list the failing test names here (one per
line, in `<core>.txt`) and `run-checks.ps1` tolerates exactly those and fails on any other failure. A green run then
does **not** verify the listed tests.

The list is empty on purpose: every core's suite passes on a clean checkout. Rust tests that need an extracted disc
cache return early (printing `SKIP`) when it is absent, so a green run also means "skipped", not "verified", for those.
Prefer fixing a failing test to skip without assets over listing it here.
