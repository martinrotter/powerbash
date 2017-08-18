################################################
### This is the Bash powerbash main script.
################################################

# Specify colors.
color_user_host="84"
color_code_ok="7"
color_code_wrong="10"
color_pwd="75"
color_git="202"
color_result="254"

# Specify common variables.
prompt_char='➥'

get-user-host() {
  echo -n " ☻ \u@\h "
}

get-pwd() {
  echo -n " 📂 \w "
}

get-git-info() {
  git_branch=$(git symbolic-ref --short HEAD 2> /dev/null)
   
  if [[ -n "$git_branch" ]]; then  
    git diff --quiet --ignore-submodules --exit-code HEAD > /dev/null 2>&1
    
    [[ "$?" != "0" ]] && git_symbols="❗ "
  
    echo -n " $git_branch $git_symbols"
  fi
}

precmd() {
  if [ ! -z "$last_code" ]; then
    [[ $last_code -eq 0 ]] && echo -n " ✔ $last_code " || echo -n " ✘ $last_code "
  fi
}

PROMPT_COMMAND+="last_code=\$?; "

# Prompt.
PS1="\[\e]0;\w\a\]\n"
PS1+="\[\e[48;5;$color_user_host;38;5;0m\]$(get-user-host)"
PS1+="\[\e[48;5;$color_result;38;5;0m\]\$(precmd)"
PS1+="\[\e[48;5;$color_pwd;38;5;0m\]$(get-pwd)"
PS1+="\[\e[48;5;$color_git;38;5;0m\]\$(get-git-info)"
PS1+="\[\e[0m\]\n $prompt_char "