#! About the `rename` binary from the `rename` apt package: The format to use `rename` is overly complex 
#! You need to use regex substitution rather than just renaming a file directly. For that reason I'll keep this function defined here

# Renames a file or directory. Used to have some issues inside WSL but haven't had them recently and restarting WSL one or more times always fixed them.
rename() {
	if [ $# -ne 2 ]; then
		echo "Usage: rename <old_name> <new_name>"
		return 1
	fi

	local old_name="$1"
	local new_name="$2"

	if [ ! -e "$old_name" ]; then
		echo "Error: '$old_name' does not exist."
		return 1
	fi

	if [ -e "$new_name" ]; then
		echo "Error: '$new_name' already exists."
		return 1
	fi

	mv "$old_name" "$new_name"
	if [ $? -eq 1 ]; then
		echo "Failed to rename '$old_name'."
		return 1;
	fi
	echo "Successfully renamed '$old_name' to '$new_name'."
}
