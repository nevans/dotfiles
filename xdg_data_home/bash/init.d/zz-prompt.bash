#!/bin/bash
# vim: foldmethod=marker

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color)
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    ;;
esac

declare -g RESET_ATTRS="$(tput sgr0)"

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

#   The background escape sequence is ^[48;2;<r>;<g>;<b>m
#   The foreground escape sequence is ^[38;2;<r>;<g>;<b>m

__set_fg_rgb()
{
    printf '\x1b[38;2;%s;%s;%sm' "$1" "$2" "$3"
}

__set_bg_rgb()
{
    printf '\x1b[48;2;%s;%s;%sm' "$1" "$2" "$3"
}

# TODO: figure out 24 bit colors...
case "$(tput colors)" in
  256)
    # TODO: use different theme
    PROMPT_COMMAND=__prompt_parts_combine
    ;;
  16)
    # TODO: use different theme
    PROMPT_COMMAND=__prompt_parts_combine
    ;;
  *)
    # TODO: use different theme
    :
    ;;
esac

_c_reset="\[${RESET_ATTRS}\]"

export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=yes

#########################################################
# {{{1 Customize: Prompt segments

PROMPT_LEFT_SEGMENTS=(  ssh userinfo sudoer cwd scm )
PROMPT_RIGHT_SEGMENTS=( clock ruby )
PROMPT_FINAL_SEGMENTS=( debian_chroot last_status )

#########################################################
# {{{1 Customize: Theme "icons" and colors

# for 256 color chart, see e.g. https://robotmoon.com/256-colors/

declare -gA THEME_BG
declare -gA THEME_FG
declare -gA THEME_ICO

THEME_ICO["error_status"]='❌'
THEME_BG[error_status]="3"
THEME_FG[error_status]="0"

THEME_ICO[l-cap-hard]=""
THEME_ICO[l-cap-soft]=""
THEME_ICO[l-sep-hard]=""
THEME_ICO[l-sep-soft]=""
THEME_ICO[f-cap-hard]="▒░"
THEME_ICO[f-cap-soft]=""
THEME_ICO[f-sep-hard]=""
THEME_ICO[f-sep-soft]=""

THEME_ICO[r-cap-hard]=""
THEME_ICO[r-cap-soft]=""
THEME_ICO[r-sep-hard]=""
THEME_ICO[r-sep-soft]=""

THEME_ICO[begin_first]="╭╼"
THEME_ICO[begin_extra]="├╼"
THEME_ICO[begin_final]="╰╼"

THEME_BG[begin]="232"
THEME_FG[begin]="2"

THEME_ICO[prompt]=" $ "
THEME_BG[prompt]="232"
THEME_FG[prompt]="2"

THEME_BG[clock]="-"
THEME_FG[clock]="2"
THEME_FG[time]="4"
THEME_FG[date]="4"

THEME_FG[cwd]="17"
THEME_BG[cwd]="111"

THEME_ICO["sudo"]="⚠ "
THEME_ICO["ssh"]="☁️ "
THEME_BG[userinfo]="22"
THEME_BG[userinfo]="237"
THEME_BG[sudo]="9"

THEME_ICO[ruby]=" "
THEME_BG[ruby]="1"

SCM_NONE_CHAR=""
SCM_GIT_CHAR=${POWERLINE_SCM_GIT_CHAR:=" "}
SCM_THEME_PROMPT_CLEAN=""
SCM_THEME_PROMPT_DIRTY=""
THEME_BG[scm_clean]=25
THEME_BG[scm_dirty]=88
THEME_BG[scm_staged]=30
THEME_BG[scm_unstaged]=92
THEME_BG[scm]=${THEME_BG[scm_clean]}

#########################################################
# {{{1 Build the prompt segments

function __prompt_segment_sudoer() {
  if [[ "${PROMPT_CHECK_SUDO:-true}" = true ]]; then
    if sudo -n uptime 2>&1 | grep -q "load"; then
      echo "${THEME_ICO['sudo']}|sudo"
    fi
  fi
}

function __prompt_segment_debian_chroot() {
  printf "%s" "${debian_chroot:+-- chroot($debian_chroot|cwd)}"
}

function __prompt_segment_ssh() {
  if [[ -n "${SSH_CLIENT:-}" ]]; then
    printf "%s|cwd" "${THEME_ICO['ssh']}"
  fi
}

function __prompt_segment_userinfo() {
  if [[ -n "${CODESPACE_NAME:-}" ]]; then
    echo "codespace: ${CODESPACE_NAME}|userinfo"
  else
    echo "<${USER}@${HOSTNAME}>|userinfo"
  fi
}

function __prompt_segment_cwd() {
  printf "%s" "\w" # let bash's PROMPTNG transformation handle it
}

function __prompt_segment_clock() {
  local date
  local time
  date="\[$(tput setaf "${THEME_FG['date']}")\]\d\[$(tput setaf "${THEME_FG['clock']}")\]"
  time="\[$(tput setaf "${THEME_FG['time']}")\]\t\[$(tput setaf "${THEME_FG['clock']}")\]"
  echo "[${date}]-(${time})"
}

function __prompt_segment_ruby() {
  if [ "$(type -P rbenv)" ]; then
    local ruby_version
    ruby_version=$(rbenv version-name) || return
    if [ "$rbenv" != "system" ]; then
      echo -e "${THEME_ICO['ruby']:-}$ruby_version"
    fi
  fi
}

# uses ./base.theme.sh, imported from oh-my-bash
function __prompt_segment_scm() {
  local color="scm"
  local scm_prompt=""

  scm_prompt_vars

  if [[ "${SCM_NONE_CHAR}" != "${SCM_CHAR}" ]]; then
    if [[ "${SCM_DIRTY}" -eq 3 ]]; then
      color=scm_staged
    elif [[ "${SCM_DIRTY}" -eq 2 ]]; then
      color=scm_unstaged
    elif [[ "${SCM_DIRTY}" -eq 1 ]]; then
      color=scm_dirty
    else
      color=scm_clean
    fi
    if [[ "${SCM_GIT_CHAR}" == "${SCM_CHAR}" ]]; then
      scm_prompt+="${SCM_CHAR}${SCM_BRANCH}${SCM_STATE}"
    fi

    echo "${scm_prompt}${scm}|${color}"
  fi
}

function __prompt_segment_last_status() {
  if [[ "$PROMPT_LAST_STATUS" -ne 0  ]]; then
    printf "%s" "${THEME_ICO['error_status']} ${PROMPT_LAST_STATUS}|error_status"
  fi
}

#########################################################
# {{{1 Theme cache functions

# TODO: cache theme colors
function __prompt_theme_colors() {
  echo -e "${__PROMPT_THEME_CACHE[$1]}"
}

declare -gA __PROMPT_THEME_CACHE=()

function __prompt_update_theme_cache() {
  local theme
  for theme in "${!THEME_FG[@]}" "${!THEME_BG[@]}"; do
    local fg="${THEME_FG[$theme]:--}"
    local bg="${THEME_BG[$theme]:--}"
    local fg_codes=""
    if [[ "$fg" != "-" ]]; then
      fg_codes="$(tput setaf "$fg")"
    fi
    local bg_codes=""
    if [[ "$bg" != "-" ]]; then
      bg_codes="$(tput setab "$bg")"
    fi
    # RESET_ATTRS in case one of them is "-"
    __PROMPT_THEME_CACHE[$theme]="\[${RESET_ATTRS}${fg_codes}${bg_codes}\]"
  done
}

__prompt_update_theme_cache

# TODO: cache theme colors
function __prompt_set_fg_bg() {
  fg=""
  if [[ "${1:--}" != "-" ]]; then
    fg="$(tput setaf "$1")"
  fi
  bg=""
  if [[ "${2:--}" != "-" ]]; then
    bg="$(tput setab "$2")"
  fi
  # RESET_ATTRS in case one of them is "transparent"
  echo -e "\[${RESET_ATTRS}${fg}${bg}\]"
}

#########################################################
# {{{1 Prompt "part" builder functions

PROMPT_RIGHT=
PROMPT_LEFT=
PROMPT_FINAL=

function __prompt_build_left_part() {
  __prompt_build_part "left" PROMPT_LEFT PROMPT_LEFT_SEGMENTS
}

function __prompt_build_right_part() {
  __prompt_build_part "right" PROMPT_RIGHT PROMPT_RIGHT_SEGMENTS
}

function __prompt_build_final_part() {
  __prompt_build_part final PROMPT_FINAL PROMPT_FINAL_SEGMENTS
  # PROMPT_FINAL=""
  # __prompt_begin_part final PROMPT_FINAL
  # __prompt_end_part   final PROMPT_FINAL
  # :
}

function __prompt_build_part() {
  local part="$1"
  local -n prompt_var="$2"
  local -n segments="$3"
  prompt_var=""
  PROMPT_LAST_SEGMENT_BG="-"
  PROMPT_LAST_SEGMENT="begin-${part}"
  __prompt_begin_part "$@"
  local segment segment_name
  for segment_name in "${segments[@]}"; do
    segment="$(__prompt_segment_"${segment_name}")"
    if [[ -n "${segment}" ]]; then
      # simple split params on '|'
      local -a params
      readarray -td'|' params <<< "$segment|"; unset "params[-1]"
      __prompt_append_segment "$2" "$1" "${params[0]}" "${params[1]:-$segment_name}"
    fi
  done
  __prompt_end_part "$@"

  # expand the prompt_var now, so we can count the chars
  prompt_var="${prompt_var@P}"
}

function __prompt_begin_part() {
  local part="$1"
  local -n prompt_var="$2"
  case "$part" in
    left)
      : # TODO: move begin_first piece into here...
      ;;
    right)
      :
      ;;
    final)
      :
      ;;
  esac
}

function __prompt_end_part() {
  local part="$1"
  local -n prompt_var="$2"
  case "$part" in
    left)
      if [[ -n "${prompt_var}" ]]; then
        prompt_var+="$(__prompt_set_fg_bg ${PROMPT_LAST_SEGMENT_BG} -)"
        prompt_var+="${THEME_ICO[l-cap-hard]}\[${RESET_ATTRS}\]"
      fi
      ;;
    right)
      :
      ;;
    final)
      if [[ -n "${prompt_var}" ]]; then
        prompt_var+="$(__prompt_set_fg_bg ${PROMPT_LAST_SEGMENT_BG} -)"
        prompt_var+="${THEME_ICO[f-cap-hard]}\[${RESET_ATTRS}\]"
      fi
      prompt_var+=$(__prompt_theme_colors prompt)
      prompt_var+="${THEME_ICO[prompt]}$_c_reset"
      ;;
  esac
}

#########################################################
# {{{1 Prompt "segment" builder functions

declare -gA __PROMPT_SEP_CACHE
__PROMPT_SEP_CACHE=( [work_around_old_bash_global_declaration_bugs]='yes'
                     [with_multiple_key_value_pairs]="sure, why not" )

# saves to __PROMPT_SEP_CACHE[${dir}${first}-${last}-${fg}-${bg}]
#   cache[begin > foo]; cache[foo > bar]; cache[bar > end]
#   cache[begin < foo]; cache[foo < bar]; cache[bar < end]
function __prompt_ensure_separator() {
  local dir="${1:0:1}" # only use the first letter to match icons
  local first="$2"
  local last_bg="$PROMPT_LAST_SEGMENT_BG"
  local theme="$3"
  local key="${dir}${first}-${last_bg}-${theme}"

  if [ -v "__PROMPT_SEP_CACHE[$key]" ]; then
    return
  fi

  local next_fg="${THEME_FG[$theme]:--}"
  local next_bg="${THEME_BG[$theme]:--}"
  local sep=""
  local type="sep"
  local size="hard"

  local sep_fg sep_bg
  if [ "$dir" != "r" ]; then
    sep_fg="$last_bg" # arrow comes from left segment
    sep_bg="$next_bg" # background begins right segment
  else
    sep_fg="$next_bg" # arrow comes from right segment
    sep_bg="$last_bg" # background ends left segment
  fi

  __prompt_first_separator "$dir" "$first" "$next_bg"

  if [[ "$next_bg" = "$last_bg" ]]; then
    size="soft"
    sep_fg="$next_fg"
  fi

  sep+=$(__prompt_set_fg_bg "$sep_fg" "$sep_bg")
  sep+="${THEME_ICO[${dir}-${type}-${size}]:-}"
  sep+=$(__prompt_set_fg_bg "$next_fg" "$next_bg")

  __PROMPT_SEP_CACHE[$key]="$sep"
}

function __prompt_first_separator() {
  local dir="${1:0:1}" # only use the first letter to match icons
  local first="$2"
  local next_bg="$3"
  # n.b. "l-beg-*" and "r-nil-soft" icons have nil defaults
  if [ "$first" ]; then
    case "$dir" in
      l)
        type="beg"
        sep+="$(__prompt_theme_colors begin)${THEME_ICO[begin_first]}"
        ;;
      r)
        [[ "$next_bg" != "-" ]] && type="cap" || type="nil"
        ;;
      f)
        type="beg"
        sep+="$(__prompt_theme_colors begin)${THEME_ICO[begin_final]}"
        ;;
    esac
  fi
}

function __prompt_append_segment() {
  local -n prompt="$1"
  local dir="${2:0:1}"
  local text="$3"
  local theme="$4"
  local fg="${THEME_FG[$theme]:--}"
  local bg="${THEME_BG[$theme]:--}"

  # (
  #   declare -p prompt
  #   declare -p dir
  #   declare -p theme
  # ) >&2

  # TODO: combine PROMPT_LAST_SEGMENT_BG with "$first"
  local first=""; if [[ "${#prompt}" = 0 ]]; then first="0"; fi
  __prompt_ensure_separator "$dir" "$first" "$theme"
  local key="${dir}${first}-${PROMPT_LAST_SEGMENT_BG}-${theme}"
  # [[ ${__PROMPT_SEP_CACHE@a} = A ]] || declare -gA __PROMPT_SEP_CACHE=()
  prompt+="${__PROMPT_SEP_CACHE[$key]}"

  prompt+=" $text \[${RESET_ATTRS}\]"

  PROMPT_LAST_SEGMENT_BG="$bg"
  PROMPT_LAST_SEGMENT="$theme"
}

#########################################################
# {{{1 Prompt build

# n.b: 'wc -L' only works with GNU coreutils
function __prompt_len() {
  local clean
  clean="$(printf "%s" "${1}" | sed -E 's,\x01[^\x02]*\x02,,g')"
  # printf "clean (%i): %q\n" "${#clean}" "$clean" >&2
  printf "%b" "$clean" | wc -L
}

function __prompt_parts_combine() {
  PROMPT_LAST_STATUS="$?" # must get this first... before we run anything

  # TODO: create __prompt_segment function
  PS1="$_c_reset"

  __prompt_build_left_part
  __prompt_build_right_part
  __prompt_build_final_part

  # dynamic spacing between time and the rest...
  local cols len_left len_right
  cols=$(tput cols)
  len_left=$( __prompt_len "$PROMPT_LEFT")
  len_right=$(__prompt_len "$PROMPT_RIGHT")
  local aligned_right
  aligned_right=$(tput hpa $(( cols - len_right )))${PROMPT_RIGHT}

  # (
  # declare -p len_left
  # declare -p len_right
  # declare -p cols
  # ) >&2

  if (( cols < (len_left + len_right) )); then
    PS1+="${aligned_right}\n"
    PS1+="${PROMPT_LEFT}"
  else
    PS1+="${PROMPT_LEFT}"
    PS1+="${aligned_right}"
  fi

  PS1+="\n${PROMPT_FINAL}"

}
