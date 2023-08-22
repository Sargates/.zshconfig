# if ! command -v python3 >/dev/null 2>&1; then
# 	echo "No Python 3 available"
# 	exit 1
# fi
if ! command -v python3 >/dev/null 2>&1; then
	echo "Input python version 3.X to install"
	while true; do
		read pv
		if pv in 11 10 9 8 7 6 5 4 3 2 1 0; then
			break
		else
			echo "Invalid python version 3.$pv, try again"
		fi
	done

	# PYTHON=""
	# for pv in 11 10 9 8 7 6; do
	# pc="python3.$pv"
	# if command -v $pc >/dev/null 2>&1; then
	# 	PYTHON=$pc
	# 	break
	# fi
	# done
	# echo $PYTHON
	sudo apt install python$pv
fi
