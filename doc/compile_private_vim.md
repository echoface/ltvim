## Compiling ##

step 1: install relative lib on your platrom ; python-dev, ruby, ncurse, etc

```
  sudo apt-get install libncurses5-dev libgnome2-dev \
    libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev libncurses-dev \
    libgnome2-dev vim-gnome libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python python-dev ruby ruby-dev
```

step 2: configure & compile
```
# Without GUI +python2
./configure  --prefix=$HOME \
             --with-features=huge \
             --disable-gui --without-x \
             --enable-fontset --with-compiledby="HuanGong" \
             --enable-cscope --enable-fail-if-missing --enable-multibyte \
             --enable-pythoninterp --with-python-config-dir=/usr/lib64/python2.7/config


# without GUI +python3
./configure  --prefix=$HOME \
             --with-features=huge \
             --disable-gui --without-x \
             --enable-fontset --with-compiledby="HuanGong" \
             --enable-cscope --enable-fail-if-missing --enable-multibyte \
             --enable-python3interp --enable-pythoninterp \
             --with-python-config-dir=/usr/lib64/python2.7//config \
             --with-python3-config-dir=/usr/lib64/python3.6/config-3.6m-x86_64-linux-gnu

```

## Installation ##
in default, I install VIm In my HOME directional

