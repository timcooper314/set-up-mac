if [ -r ~/.profile ]
then
	source ~/.profile
fi

# Checking if interactive shell, $- = current option flags for the active shell
# If "i" is there, then it's an interactive shell, and we need to explicitly source .bashrc
case "$-" in
	*i*)
		if [ -r ~/.bashrc ]
		then
			source ~/.bashrc
		fi
		;;
esac
