# Returns 1 if first string contains second string
contains() {
	case "$1" in *"$2"*)
		return 0;
	esac
	return 1;
}