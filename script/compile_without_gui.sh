./configure  --prefix=$HOME \
  --with-features=huge \
  --enable-pythoninterp=yes \
  --enable-cscope\
  --enable-fail-if-missing \
  --enable-multibyte \
  --enable-fontset \
  --with-compiledby="HuanGong" \
  --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/\
  --disable-gui \
  --without-x

./configure --prefix=$HOME \
  --with-features=huge \
  --enable-multibyte \
  --enable-rubyinterp=yes \
  --enable-perlinterp=yes \
  --enable-luainterp=yes \
  --enable-pythoninterp=yes \
  --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
  --enable-python3interp=yes \
  --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
  --enable-cscope \
  --disable-gui \
  --without-x

make
make install
