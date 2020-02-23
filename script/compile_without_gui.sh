./configure --prefix=$HOME --with-features=huge \
            --without-x \
            --disable-gui \
            --enable-cscope \
            --enable-multibyte \
            --enable-luainterp=yes \
            --enable-rubyinterp=yes \
            --enable-pythoninterp=yes \
            --enable-python3interp=yes \
            --with-compiledby="HuanGong" \
            --with-python-command=/usr/bin/python \
            --with-python3-command=/usr/bin/python3 \
            --with-python-config-dir=/usr/lib64/python2.7/config \
            --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \

make
make install
