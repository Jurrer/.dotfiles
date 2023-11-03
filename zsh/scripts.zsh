#!/usr/bin/env zsh

# Run script to update Arch and others
updatesys() {
    sh $DOTFILES/update.sh
}

# Extract files
extract() {
    for file in "$@"
    do
        if [ -f $file ]; then
            _ex $file
        else
            echo "'$file' is not a valid file"
        fi
    done
}

# Extract files in their own directories
mkextract() {
    for file in "$@"
    do
        if [ -f $file ]; then
            local filename=${file%\.*}
            mkdir -p $filename
            cp $file $filename
            cd $filename
            _ex $file
            rm -f $file
            cd -
        else
            echo "'$1' is not a valid file"
        fi
    done
}

# Internal function to extract any file
_ex() {
    case $1 in
        *.tar.bz2)  tar xjf $1      ;;
        *.tar.gz)   tar xzf $1      ;;
        *.bz2)      bunzip2 $1      ;;
        *.gz)       gunzip $1       ;;
        *.tar)      tar xf $1       ;;
        *.tbz2)     tar xjf $1      ;;
        *.tgz)      tar xzf $1      ;;
        *.zip)      unzip $1        ;;
        *.7z)       7z x $1         ;; # require p7zip
        *.rar)      7z x $1         ;; # require p7zip
        *.iso)      7z x $1         ;; # require p7zip
        *.Z)        uncompress $1   ;;
        *)          echo "'$1' cannot be extracted" ;;
    esac
}

ssh-create() {
    if [ ! -z "$1" ]; then
        ssh-keygen -f $HOME/.ssh/$1 -t ed25519 -N '' -C "$1"
        chmod 600 $HOME/.ssh/$1
        chmod 644 $HOME/.ssh/$1.pub
    fi
}


matrix () {
    local lines=$(tput lines)
    cols=$(tput cols)

    awkscript='
    {
        letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
        lines=$1
        random_col=$3
        c=$4
        letter=substr(letters,c,1)
        cols[random_col]=0;
        for (col in cols) {
            line=cols[col];
            cols[col]=cols[col]+1;
            printf "\033[%s;%sH\033[2;32m%s", line, col, letter;
            printf "\033[%s;%sH\033[1;37m%s\033[0;0H", cols[col], col, letter;
            if (cols[col] >= lines) {
                cols[col]=0;
            }
    }
}
'

echo -e "\e[1;40m"
clear

while :; do
    echo $lines $cols $(( $RANDOM % $cols)) $(( $RANDOM % 72 ))
    sleep 0.05
done | awk "$awkscript"
}

githeat() {
    $DOTFILES/bash/scripts/heatmap.sh
}

colorblocks() {
    $DOTFILES/bash/scripts/colorblocks.sh
}

colorcards() {
    $DOTFILES/bash/scripts/colorcards.sh
}

colors() {
    $DOTFILES/bash/scripts/colors.sh
}

pipes() {
    $DOTFILES/bash/scripts/pipes.sh
}

smedia() {
    $DOTFILES/bash/scripts/smedia.sh $@
}

mkcd() {
    local dir="$*";
    local mkdir -p "$dir" && cd "$dir";
}

mkcp() {
    local dir="$2"
    local tmp="$2"; tmp="${tmp: -1}"
    [ "$tmp" != "/" ] && dir="$(dirname "$2")"
    [ -d "$dir" ] ||
        mkdir -p "$dir" &&
        cp -r "$@"
}

mkmv() {
    local dir="$2"
    local tmp="$2"; tmp="${tmp: -1}"
    [ "$tmp" != "/" ] && dir="$(dirname "$2")"
    [ -d "$dir" ] ||
        mkdir -p "$dir" &&
        mv "$@"
    }

historystat() {
    history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head
}

promptspeed() {
    for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done
}

ports() {
    sudo netstat -tulpn | grep LISTEN | fzf;
}

# Silly little script to understand zstyle
names() {
    local user_name user_surname user_nickname computer_name

    zstyle -s ':name:' set_user_name user_name || user_name="LEELA"
    zstyle -s ':name:surname:' set_user_name user_surname || user_surname="TURANGA"
    zstyle -s ':name:nickname::' set_user_name user_nickname || user_nickname="CYCLOPE"
    zstyle -s ':name:' set_computer_name computer_name || computer_name="BENDER"

    echo "You're $user_name $user_surname $user_nickname and you're computer is called $computer_name"
}

vinfo() {
    vim -c "Vinfo $1" -c 'silent only'
}

zshcomp() {
    for command completion in ${(kv)_comps:#-*(-|-,*)}
    do
        printf "%-32s %s\n" $command $completion
    done | sort
}

# duckduckgo() {
#     lynx -vikeys -accept_all_cookies "https://lite.duckduckgo.com/lite/?q=$@"
# }

# wikipedia() {
#     lynx -vikeys -accept_all_cookies "https://en.wikipedia.org/wiki?search=$@"
# }

cheat() {
    curl cheat.sh/$1
}

vimgolf() {
    local ID=$1
    local key=$2
    if [ -z $2 ]; then
        key=$VIM_GOLF_KEY
    fi
    docker run --rm  --net=host -it -e "key=[$VIM_GOLF_KEY]" kramos/vimgolf "$ID"
}

back() {
    for file in "$@"; do
        cp "$file" "$file".bak
    done
}

tiny() {
    local URL=${1:?}
    curl -s "http://tinyurl.com/api-create.php?url=$1"
}

git-jump() {
    "$DOTFILES/bash/scripts/git-jump.sh" "$@"
}

reposize() {
  url=`echo $1 \
    | perl -pe 's#(?:https?://github.com/)([\w\d.-]+\/[\w\d.-]+).*#\1#g' \
    | perl -pe 's#git\@github.com:([\w\d.-]+\/[\w\d.-]+)\.git#\1#g'
  `
  printf "https://github.com/$url => "
  curl -s https://api.github.com/repos/$url \
  | jq '.size' \
  | numfmt --to=iec --from-unit=1024
}


# Launch a program in a terminal without getting any output,
# and detache the process from terminal
# (can then close the terminal without terminating process)
-echo() {
    "$@" &> /dev/null & disown
}