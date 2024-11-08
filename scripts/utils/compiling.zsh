
# Does not work with absolute paths
run_c() { gcc "$1" -o "__${1:r}"; ./__${1:r} ${@:2:#} }
run_cpp() { g++ "$1" -o "__${1:r}"; ./__${1:r} ${@:2:#} }