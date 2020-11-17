#!/bin/bash

PREFIX=$HOME

optspec=":h-:"
while getopts "$optspec" optchar; do
  case "${optchar}" in
    -)
      case "${OPTARG}" in
        prefix)
          PREFIX="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
          ;;
        prefix=*)
          PREFIX=${OPTARG#*=}
          ;;
        *)
          if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
            echo "Unknown option --${OPTARG}" >&2
          fi
          ;;
      esac;;
    h)
      echo "usage: $0 [-h] [--prefix[=]<value>]" >&2
      exit 2
      ;;
    *)
      if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
        echo "Non-option argument: '-${OPTARG}'" >&2
      fi
      echo "usage: $0 [-h] [--prefix[=]<value>]" >&2
      exit 2
      ;;
  esac
done

DependenciesHint="make sure ncurses5-dev,python2-dev,python3-dev installed"
echo -e "\n${DependenciesHint}\n"

read -r -p "vim8 will install to path ${PREFIX}? other path with --prefix args [Y|n]" input
case $input in
  [yY][eE][sS]|[yY])
    ;;
  [nN][oO]|[nN])
    echo "nothing change for your vim config"
    echo "exit..."
    exit 1
    ;;
  *)
    echo "invlid input, exit..."
    exit 1
    ;;
esac

git clone https://gitee.com/ltecho/vim.git .ltvim8 --depth=1
cd .ltvim8
./configure                                                           \
  --prefix=$PREFIX                                                    \
  --with-features=huge                                                \
  --disable-gui --without-x                                           \
  --enable-fontset --with-compiledby="HuanGong"                       \
  --enable-cscope --enable-fail-if-missing --enable-multibyte         \
  --enable-python3interp --enable-pythoninterp                        \

make -j4
make install
echo "clean source code..."
rm -rf .ltvim8
echo "enjoy lt vim8...."

