# Zsh steeef theme as a standalone repository. The purpose behind this repo is avoid having a
# dependency on oh-my-zsh when using the steeef theme. Zsh plugin managers such as Antibody can use
# the theme without having to integrate oh-my-zsh. Credits to the original theme authors.
# For more info on prompt expansion see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html

# prompt style and colors based on Steve Losh's Prose theme:
# http://github.com/sjl/oh-my-zsh/blob/master/themes/prose.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# http://briancarper.net/blog/570/git-info-in-your-zsh-prompt

export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo -e "(%{$red%}"`basename $VIRTUAL_ENV`"${PR_RST})"
}

setopt prompt_subst

autoload -U add-zsh-hook
autoload -Uz vcs_info

#use extended color pallete if available
if [[ $terminfo[colors] -ge 256 ]]; then
    turquoise="%F{51}"
    orange="%F{208}"
    blue="%F{117}"
    red="%F{196}"
    limegreen="%F{118}"
else
    turquoise="%F{cyan}"
    orange="%F{yellow}"
    blue="%F{blue}"
    red="%F{red}"
    limegreen="%F{green}"
fi

# enable VCS systems you use
zstyle ':vcs_info:*' enable git svn

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
PR_RST="%f"
FMT_BRANCH="(%{$turquoise%}%b%c%u${PR_RST})"
FMT_ACTION="(%{$limegreen%}%a${PR_RST})"
FMT_UNSTAGED="%{$orange%}●"
FMT_STAGED="%{$limegreen%}●"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

function steeef_precmd {
    # check for untracked files or updated submodules, since vcs_info doesn't
    if git ls-files --other --exclude-standard `git rev-parse --show-cdup 2>/dev/null` 2>/dev/null | grep -q "."; then
        PR_GIT_UPDATE=1
        FMT_BRANCH="(%{$turquoise%}%b%c%u%{$red%}●${PR_RST})"
    else
        FMT_BRANCH="(%{$turquoise%}%b%c%u${PR_RST})"
    fi
    zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH}"

    vcs_info 'prompt'
}
add-zsh-hook precmd steeef_precmd

# update RPROMPT when the user switches between viins and vicmd mode
function zle-keymap-select {
    zle reset-prompt
}
zle -N zle-keymap-select

PROMPT='%B%n${PR_RST}@%m${PR_RST}:%{$blue%}%~${PR_RST}$vcs_info_msg_0_$(virtualenv_info)${PR_RST}%b$ '
RPROMPT='`TMP_RET=$?; [[ "${KEYMAP}" == "vicmd" ]] && echo -n "%{$orange%}[NORMAL]${PR_RST}"; [[ ${TMP_RET} != 0 ]] && echo -n " %{$red%}${TMP_RET}${PR_RST}"`'
