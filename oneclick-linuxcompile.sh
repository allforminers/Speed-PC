set -e
set -x

BASEDIR=$(pwd)

if [ "x${HOST}y" = "xy" ]; then
	export HOST="$(./depends/config.guess)"
fi

(cd depends && make -j8)

./autogen.sh

export CONFIG_SITE="$BASEDIR/depends/$HOST/share/config.site"
./configure --with-gui=no --disable-tests --disable-bench --prefix=/ $@
