################################################
### This is the Bash powerbash main script.
################################################

# Specify colors.
color_text="30m"
color_user_host="42m"
color_code_wrong="41m"
color_pwd="44m"
color_git_ok="42m"
color_git_dirty="41m"

# Specify common variables.
prompt_char='λ'
rc='\e[0m'

get-user-host() {
  [[ -n "$SSH_CLIENT" ]] && echo -ne "\e[$1\e[$2 \u@\h $rc"
}

get-pwd() {
  echo -ne "\e[$1\e[$2 \w $rc"
}

get-git-info() {
  local git_branch=$(git symbolic-ref --short HEAD 2> /dev/null)
   
  if [[ -n "$git_branch" ]]; then
    git diff --quiet --ignore-submodules --exit-code HEAD > /dev/null 2>&1
    
    if [[ "$?" != "0" ]]; then
      git_symbols="❗ "
      back_color=$3
    else
      back_color=$2
    fi
  
    echo -n "\e[$1\e[$2 $git_branch $git_symbols$rc"
  fi
}

get-last-code() {
  [[ (-n "$last_code") && ($last_code -ne 0) ]] && echo -n "\e[$1\e[$2 ✘ $last_code $rc"
}

get-prompt() {
  echo -n "\n" && echo -n " $prompt_char "
}

set_prompt() {
  last_code=$?

  if [[ "$not_first_prompt" == true ]]; then
    PS1="\n$(get-user-host $color_text $color_user_host)"
  else
    PS1="$(get-user-host $color_text $color_user_host)"
    not_first_prompt=true
  fi

  PS1+="$(get-last-code $color_text $color_code_wrong)"
  PS1+="$(get-pwd $color_text $color_pwd)"
  PS1+="$(get-git-info $color_text $color_git_ok $color_git_dirty)"
  PS1+="$(get-prompt)"
}

PROMPT_COMMAND="set_prompt"