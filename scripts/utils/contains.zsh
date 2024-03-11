# Returns 1 if first string contains the second. `contains $A $B` -> $B in $A
contains() {
	case "$1" in *"$2"*)
		return 0;
	esac
	return 1;
}