#!/bin/bash
#Thank you to Mathias Bynens for defining the defaults within his dots repository.
MACPREP_DIR=`dirname $0`

#install xcode packages
echo "--> installing xcode packages..."
xcode-select --install

read -p "continue after the install finishes [ENTER]"

#install brew
echo "--> installing homebrew..."
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor

echo "--> installing coreutils..."
brew tap homebrew/dupes
brew install coreutils

echo "--> installing findutils + bash..."
#install locate, updatedb, etc.
brew install findutils
brew install bash

#give the coreutils precedence over other versions in the path
brew install homebrew/dupes/grep
echo '# give coreutils precedence over other versions in the path' >> ~/.bash_profile
echo 'export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH' >> ~/.bash_profile

#get cask
echo "--> installing cask + chrome..."
brew tap caskroom/cask
brew cask install google-chrome
brew update && brew cleanup

echo "--> installing quicklook sublime-text + iterm2..."
brew cask install sublime-text
brew cask install iterm2

brew install git
git config --global user.name "dagint"
git config --global user.email "dagint@gmail.com"
git config --global github.user dagint
git config --global core.editor "vim"
git config --global color.ui true
git config --global push.default simple

echo "--> installing the-unarchiver..."
brew cask install the-unarchiver

echo "--> install rsync..."
brew install rsync

echo "--> Customizing mac defaults..."
 #mac os customizations
 # Save to HD instead of icloud by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# quit printer when job finishes
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the 'are you sure you want to open this' messages
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# show mounts on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# disable disk verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true


# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

cat <<EOF >> $HOME/.bash_profile
# Set CLICOLOR if you want Ansi Colors in iTerm2
export CLICOLOR=1
# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color
# Set the bash prompt styling
export PS1="\[$(tput bold)\]\[$(tput setaf 4)\][\[$(tput setaf 5)\]\u\[$(tput setaf 6)\]@\[$(tput setaf 5)\]\h \[$(tput setaf 2)\]\W\[$(tput setaf 4)\]]\\$ \[$(tput sgr0)\]"
alias ls="ls --color=auto"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
EOF

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

#Activity Monitor Changes
# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Chrome changes
# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Disable the all too sensitive backswipe on Magic Mouse
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"


# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "--> Setting up .inputrc and .zshrc"
# in bash shell - allow ^ LEFT ARROW to skip backward and ^ RIGHT ARROW to skip forward
echo '"\e[1;5D": backward-word' >> ~/.inputrc
echo '"\e[1;5C": forward-word' >> ~/.inputrc


# in zsh - allow ^ LEFT ARROW to skip backward and ^ RIGHT ARROW to skip forward
echo "bindkey '^[[1;5C' forward-word" >> ~/.zshrc
echo "bindkey '^[[1;5D' backward-word" >> ~/.zshrc

echo "--> Installing vim + tree..."
brew install vim --override-system-vi
brew install tree

echo "--> Installing docker + virtualbox..."
#install docker
brew cask install virtualbox
brew cask install docker

echo "--> Setting up bash completion..."
#Bash completion
brew install bash-completion

cat <<EOF >> ~/.bash_profile
#Enable bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
EOF

echo "--> Installing nmap..."
#install nmap
brew install nmap

echo "--> Installing wget..."
#install wget
brew install wget

echo "--> Installing speedtest_cli..."
#install speedtest_cli
brew install speedtest_cli

echo "--> Installing macvim..."
#install macvim
brew install macvim

echo "--> Installing htop..."
#install htop
brew install htop

echo "--> Installing jq..."
#install jq
brew install jq

echo "--> Installing irssi..."
#install irssi
brew install irssi

echo "--> Installing hh..."
#install hh
brew install hh

echo "--> Installing awscli..."
#install awscli
brew install awscli

echo "--> Installing watch..."
#install watch
brew install watch

#install quicklook customizations
echo "--> installing quicklook customizations..."
brew cask install qlcolorcode
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install qlprettypatch
brew cask install quicklook-csv
brew cask install betterzipql
brew cask install webpquicklook
#brew cask install suspicious-package

echo "--> Installing ssh-copy-id"
brew install ssh-copy-id
echo "--> Generating ssh keys"
ssh-keygen

echo "--> Installing atom"
brew cask install atom

echo "--> Installing expandrive"
brew cask install expandrive

echo "--> Installing arq"
brew cask install arq

echo "--> Installing amazon-workspaces"
brew cask install amazon-workspaces

echo "--> Installing pyhton"
brew install python

echo "--> Installing pip"
sudo easy_install pip

echo "--> Installing biba"
brew cask install biba

echo "--> Installing firefox"
brew cask install firefox

echo "--> Installing libreoffice"
brew cask install libreoffice

echo "--> Installing Skype"
brew cask install skype

brew update && brew cleanup

