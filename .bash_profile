export MAVEN="/usr/local/Cellar/maven/3.$"
export M2_HOME="/usr/local/Cellar/maven/3.5.4"
export M2="$M2_HOME/bin"
export MAVEN_OPTS="-Xmx1024m"

export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
export ANDROID_HOME="/Users/ivln/Library/Android/sdk"

export CHROME="/usr/local/bin/chromedriver"
export FIREFOX="/usr/local/bin/geckodriver"
export PYTHON_THREE="/Users/ivln/Library/Python/3.7/bin"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add `~/bin` to the `$PATH`
export USER_BIN="$HOME/bin";
export BIN_PATHS="$USER_BIN:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
export ANDROID_JAVA="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME:$JAVA_HOME/bin"
PATH="$PATH:$USER_BIN:$ANDROID_JAVA:$PYTHON_THREE:$CHROME:$FIREFOX:$MAVEN:$M2"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.path ~/.bash_prompt ~/.exports ~/.aliases ~/.functions ~/.extra; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

#if [ "${BASH_VERSINFO}" -ge 4 ] && [ -f /usr/local/share/bash-completion/bash_completion ]; then
#. /usr/local/share/bash-completion/bash_completion
#fi

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;
