
#https://natelandau.com/my-mac-osx-bash_profile/ for bash_profile referencexw

alias composer="php /usr/local/bin/composer.phar"

# Better ls
alias ls='ls -G'

# Kill process with given PID
alias killpid='sudo kill -9'

# Check the code signature of location
alias sig='codesign -dv --verbose=4'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Copy `pwd` with no '\n' to the clipboard
alias cpwd="pwd | tr -d '\n' | pbcopy"

# Search throguh command history
alias hs='history | grep'

# ifconfig and pipe the output to grep and look for 'inet'
alias inet="ifconfig | grep inet"

# Config alias for version control of dot files
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

#go to home directory
alias ~="cd ~"

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#open current directory in finder
alias f='open -a Finder ./'


#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
    extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }

#ls after a cd
cdl() { builtin cd "$@"; ls; }

#get my ip
alias myip='curl icanhazip.com'

alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
    ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ;myip
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }

httpHeaders () { /usr/bin/curl -I -L $@ ; }             # httpHeaders:      Grabs headers from web page

#   httpDebug:  Download a web page and show info on what took time
#   -------------------------------------------------------------------
    httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }


#enhanced ls
alias ll='ls -FGlAhp'

mkcd() {
	mkdir -p "$@" && cd "$_"
}

# Determine size of a file or total size of a directory
# Source: https://github.com/mathiasbynens/dotfiles
fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# Get the weather
weather() {
	# If no $1, use the zip code from our IP
	# If no $2, use "q0n" as URL params
	curl -s -H "Accept-Language: ${LANG%_*}" http://wttr.in/${1:-$(curl -s http://ipinfo.io/postal)}?${2:-q0n}
}

# Upload a file to the hastebin service
# Source: https://github.com/diethnis/standalones
haste() {
	local output returnfile contents
	if (( $# == 0 )) && [[ $(printf "%s" "$0" | wc -c) > 0 ]]
		then
		contents=$0
	elif (( $# != 1 )) || [[ $1 =~ ^(-h|--help)$ ]]
		then
		echo "Usage: $0 FILE"
		echo "Upload contents of plaintext document to hastebin."
		echo "\nInvocation with no arguments takes input from stdin or pipe."
		echo "Terminate stdin by EOF (Ctrl-D)."
		return 1
	elif [[ -e $1 && ! -f $1 ]]
		then
		echo "Error: Not a regular file."
		return 1
	elif [[ ! -e $1 ]]
		then
		echo "Error: No such file."
		return 1
	elif (( $(stat -c %s $1) > (512*1024**1) ))
		then
		echo "Error: File must be smaller than 512 KiB."
		return 1
	fi
	if [[ -n "$contents" ]] || [[ $(printf "%s" "$contents" | wc -c) < 1 ]]
		then
		contents=$(cat $1)
	fi
	output=$(curl -# -f -XPOST "https://hastebin.com/documents" -d"$contents")
	if (( $? == 0 )) && [[ $output =~ \"key\" ]]
		then
		returnfile=$(sed 's/^.*"key":"/https:\/\/hastebin.com\//;s/".*$//' <<< "$output")
		if [[ -n $returnfile ]]
			then
			echo "$returnfile"
			return 0
		fi
	fi
	echo "Upload failed."
	return 1
}

# Upload a file to the hastebin service and pipe the url to clipboard
# Source: https://github.com/diethnis/standalones
chaste() {
  haste $1 | pbcopy;
}

# Custom latex pdf command, will remove later
pdf(){
  pdflatex -shell-escape cs4811-HW$@.tex
}

# Count number of files in a directory
numfiles() {
    N="$(ls $1 | wc -l)";
    echo "$N files in $1";
}

# Find a file from working directory
function whereis (){
  find . -name "$1*";
}

# Find What is Using a Particular Port
  # USAGE: $ whoisport 80
function whoisport (){
        port=$1;
        sudo lsof -n -i:$port;
}

function pidLoc (){
  pid=$1;
  lsof -a -d cwd -p $pid;
}

#shortened clear
alias c='clear'

# Preferred 'cp' implementation
alias cp='cp -iv'

# Preferred 'mv' implementation
alias mv='mv -iv'

#open any file in atom to edit
alias edit='atom'

alias resetb='source ~/.bash_profile'

#show hidden files in finder
alias finder_s='defaults write com.apple.Finder AppleShowAllFiles TRUE; killAll Finder'

alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias .2='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels

#Crypto prices
alias crypto='curl usd.rate.sx'

source ~/.bash_prompt

# Set `emacs` as default editor
export VISUAL=emacs
export EDITOR="$VISUAL"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/michael/.sdkman"
[[ -s "/Users/michael/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/michael/.sdkman/bin/sdkman-init.sh"
export LSCOLORS="ExFxBxDxCxegedabagacad"
