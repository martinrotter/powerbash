#####################################################
### This is the OPTIONAL Bash powerbash utlity script.
#####################################################

bind 'set show-all-if-ambiguous on'         # Show everything on ambiguous situation.
bind 'set completion-ignore-case on'        # Make completion case insensitive.

# History completion with arrow keys.
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\C-_":backward-kill-word'
bind '"\e[3;5~": kill-word'
bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'

# Enhanced directory stack access & cooperation with "cd".
# Inspired by: http://aijazansari.com/2010/02/20/navigating-the-directory-stack-in-bash/index.html

stack_cd() {
  if [ $# -eq 1 ]; then
    pushd "$1" > /dev/null
  else
    pushd "$HOME" > /dev/null
  fi
}

alias cd=stack_cd

swap() {
  pushd > /dev/null
}

alias s=swap

pop_stack() {
  popd > /dev/null
}

alias p=pop_stack

display_stack() {
  dirs -v
  echo -n "#: "
  read dir
  
  if [[ "$dir" = 'p' ]]; then
    pushd > /dev/null
  elif [[ "$dir" != 'q' ]]; then
    d=$(dirs -l +$dir);
    popd +$dir > /dev/null
    pushd "$d" > /dev/null
  fi
}
alias d=display_stack

# Persistent saving of last pwd.
[ -f "$HOME/.storepwd" ] && cd "$(<$HOME/.storepwd)"

PROMPT_COMMAND+='pwd > "$HOME/.storepwd"'

# Unique history entries.
export HISTCONTROL=ignoreboth:erasedups