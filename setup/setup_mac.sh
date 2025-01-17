#!/bin/bash

#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

echo "Running Mac setup. This would take a while. Please sit back and relax."

# Check for Homebrew
if test ! "$(which brew)"
then
  echo "Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."

brew tap caskroom/cask

# Utility function to install cask formulas
function installcask() {
    if brew cask info "${@}" | grep "Not installed" > /dev/null; then
        brew cask install "${@}"
    else
        echo "$* is already installed."
    fi
}


# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash
brew install zsh zsh-completions
brew install shellcheck

# Install wget with IRI support
brew install wget --with-iri
brew install curl --with-ssl --with-ssh
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep
brew tap josegonzalez/homebrew-php

# Install everything else
brew install openssl
brew install ack
brew install git git-extras hub git-ftp git-crypt
brew install rename htop-osx tree ngrep mtr nmap
brew install autojump
brew install legit      # http://www.git-legit.org/
brew install Zopfli     # https://code.google.com/p/zopfli/
brew install fortune cowsay
brew install node
installcask ngrok       # https://ngrok.com/  2.x available from Cask now
brew install sshrc      # https://github.com/Russell91/sshrc
brew install httpie     # https://github.com/jakubroztocil/httpie
brew install jq         # https://stedolan.github.io/jq/
brew install python3
brew install editorconfig
brew install ssh-copy-id  # http://linux.die.net/man/1/ssh-copy-id
brew install elixir
brew install gpg

# Native apps
brew tap phinze/homebrew-cask
brew install brew-cask

###############################################################################
# Install utilities                                                           #
###############################################################################

installcask firefox
installcask android-file-transfer
installcask iterm2
installcask qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webp-quicklook suspicious-package && qlmanage -r

# # Postgres 9 Database
# brew install postgres
# installcask pgadmin3
# # ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
# # launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
# psql postgres -c 'CREATE EXTENSION "adminpack";'
# sudo gem install pg

# # PG tools needed for every other project:
# brew tap osgeo/osgeo4mac
# brew install gdal
# brew install postgis

# Fonts
brew tap caskroom/fonts

installcask font-source-code-pro

sudo easy_install pip
sudo pip install -r requirements.pip

################################################################################
#                       Data Stores                                            #
################################################################################

# brew install mysql
# brew install mongo
# brew install redis
# brew install elasticsearch

################################################################################
#                           Dev tools                                          #
################################################################################

installcask install virtualbox
# installcask install vagrant
installcask install postman

# New Docker for Mac. For older version run `brew install docker`
# installcask install docker

brew install diff-so-fancy
brew link xz && brew install weechat
installcask install sublime-text
brew install tmux
brew install cookiecutter

# Some frontend stuff
brew install node
npm i -g postcss-cli
npm i -g autoprefixer

# Install custom stuff
# Slack
installcask install slack

################################################################################
#                           Customize Shell                                    #
################################################################################

install_oh_my_zsh () {
    # Test to see if zshell is installed.  If it is:
    if [ -f /bin/zsh ] || [ -f /usr/bin/zsh ]; then
        # Install Oh My Zsh if it isn't already present
        if [[ ! -d $HOME/oh-my-zsh/ ]]; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        fi
        # Set the default shell to zsh if it isn't currently set to zsh
        if [[ ! "$SHELL" == $(which zsh) ]]; then
            chsh -s "$(which zsh)"
        fi
    else
        # If zsh isn't installed, get the platform of the current machine
        platform=$(uname);
        # If the platform is Linux, try an apt-get to install zsh and then recurse
        if [[ $platform == 'Linux' ]]; then
            if [[ -f /etc/redhat-release ]]; then
                sudo yum install zsh
            fi
            if [[ -f /etc/debian_version ]]; then
                sudo apt-get install zsh
            fi
        # If the platform is OS X, tell the user to install zsh :)
        elif [[ $platform == 'Darwin' ]]; then
            echo "We'll install zsh, then re-run this script!"
            brew install zsh
            exit
        fi
    fi
}

install_oh_my_zsh

###############################################################################
# Zsh                                                                         #
###############################################################################

set -P
# Zsh Syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting

# Install Powerlevel9k theme
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# Remove outdated versions from the cellar
brew cleanup && brew cask cleanup

exit 0
