
CONDA_PATHS="$CONDA_PREFIX/bin:$CONDA_PREFIX/condabin"

# deactivate environment, i.e. activate base
conda activate base

# remove conda from PATH
export PATH=$( echo $PATH | sed "s#$CONDA_PATHS:##" )

# delete conda functions
unset -f $( { compgen -A function conda; compgen -A function __conda; } )

# delete conda variables
unset ${!CONDA@}

# Remove conda from prompt
# Had to turn off conda prompt modification in .condarc, currently this doesn't show in the prompt anyway
export CONDA_PROMPT_MODIFIER="(conda off)"

echo "Conda now off"
