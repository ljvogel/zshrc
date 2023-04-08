HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

bindkey "^U"    backward-kill-line
bindkey "^u"    backward-kill-line
bindkey "^[l"   down-case-word
bindkey "^[L"   down-case-word

# alt+<- | alt+->
bindkey "^[f" forward-word
bindkey "^[b" backward-word

# ctrl+<- | ctrl+->
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word


get_shortened_folder() {
	# if folder is hidden use first two characters 
	if [[ "${1:0:1}" == "." ]];
	then
		echo "${1:0:2}"
	else
	# otherwise just first character
		echo "${1:0:1}"
	fi
}

get_shortened_working_dir() {
  dir=$(pwd)

  dir_split=("${(@s|/|)dir}")
  top_dir=""
  potential_user=""

  # check if working directory is in users home directory and replace '/home/USER' with '~'
  i=0
  for folder in "${dir_split[@]:1:2}";
  do
    if [[ "$i" == "0" ]]; then
      top_dir=$folder
    fi

    if [[ "$i" == "1" ]]; then
      potential_user=$folder
    fi
   
    i=$((i+1))
  done
 
  # go through hierarchy and append shortened form of directories to shortened directory variable
  shortened=""
  if [[ "$top_dir" == "home" && "$potential_user" == "$USER" ]];
  then
	shortened="~"
	if [[ ${#dir_split[@]}-1 -eq 2 ]];
	then
		return ""	
	else
	for folder in "${dir_split[@]:3:-1}";
	do
		shortened="$shortened/$(get_shortened_folder $folder)"
	done
	fi
  else
	shortened=""
	for folder in "${dir_split[@]:1:-1}";
	do
		shortened="$shortened/$(get_shortened_folder $folder)"
	done
  fi

  if [[ ${#dir_split} -gt 2 ]];
  then
    echo "$shortened/"
  fi
}

setopt prompt_subst
PROMPT='%F{010}%n%f@%F{015}%m%f %F{010}$(get_shortened_working_dir)%1~%F{015}> '

# convenience aliases
alias clipboard='xclip -sel clip'
alias explorer='xdg-open'
alias python='python3'
alias py='python3'

eval "$(zoxide init zsh)"

# custom functions
fpath+=~/.zfunc
autoload cert
autoload header

source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/leon/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
