# Vim
export EDITOR=vim

#### Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export ANDROID_SDK_HOME=$HOME/Library/Android/sdk
export ANDROID_NDK_HOME=$HOME/Library/Android/sdk/ndk-bundle
#export NDK_PROJECT_PATH=$HOME/Projects/rallets-android/src/main
export NDK_PROJECT_PATH=src/main
export PATH=$PATH:$HOME/Android/sdk/platform-tools:$HOME/Android/sdk/tools/

#### Qiniu
QINIU_ACCESS_KEY=l6Rf0LgQDgpSwjdXr_MgsCynhsofRM7W2dwvIOXO

#### nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && nvm use $NVM_VERSION
export PATH="$PATH:$HOME/.nvm/versions/node/$NVM_VERSION/bin"

#### Java
export JAVA_HOME=/usr/lib/jvm/java-7-oracle
if [ "$(uname)" = "Darwin" ]; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
fi

#### Proxy Settings
unset all_proxy ALL_PROXY

#### Character Set
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [[ "$(uname)" == "Darwin" ]]; then
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    # Do something under GNU/Linux platform
elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]]; then
    # Do something under Windows NT platform
fi

if [ -e ~/Projects/paiyou-hub/bin/rancher_setup.sh ]; then
  source ~/Projects/paiyou-hub/bin/rancher_setup.sh
fi

[ -e ~/Projects/quanzhan/.myzshrc ] && source ~/Projects/quanzhan/.myzshrc

