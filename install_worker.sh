#!/bin/bash
###############################################################################

JOBS=4
AVFS_VERSION=1.0.6
WORKER_VERSION=3.15.2

#PREFIX=$HOME/local
#SUDO=
PREFIX=/usr/local
SUDO=sudo

###############################################################################

F=avfs-${AVFS_VERSION}.tar.bz2
if ! test -e $F
then
	wget http://www.boomerangsworld.de/cms/avfs/downloads/$F
fi
F=worker-${WORKER_VERSION}.tar.bz2
if ! test -e $F
then
	wget http://www.boomerangsworld.de/cms/worker/downloads/$F
fi


sudo apt-get install libfuse-dev libmagic-dev libdbus-1-dev fuse \
	liblzma-dev libx11-dev libxinerama-dev libxft-dev libdbus-glib-1-dev \
	g++ liblua5.1-dev


tar xfv avfs-$AVFS_VERSION.tar.bz2
cd avfs-$AVFS_VERSION/
./configure --enable-fuse --with-liblzma --prefix=$PREFIX
#Configuration details:
#  Building library                          : yes (recommended: yes)
#  Building avfsd for fuse                   : yes (recommended: yes)
#  Building preload library                  : no  (recommended: no)
#  Building avfscoda daemon and kernel module: no  (recommended: no)
#
#  Use system zlib                           : no  (recommended: no)
#  Use system bzlib                          : no  (recommended: no)
#  Use liblzma                               : yes (recommended: yes)
#
#
make -j$JOBS
$SUDO make install
cd ..
rm -rf avfs-$AVFS_VERSION
$SUDO ldconfig -v

tar xfvj worker-$WORKER_VERSION.tar.bz2
cd worker-$WORKER_VERSION/
./configure --with-avfs-path=$PREFIX/bin --prefix=$PREFIX
#Configuration finished:
#  AVFS usage                  : yes
#  Large file support          : yes
#  Regular expressions support : yes
#  X11 XIM usage               : yes
#  X11 Xinerama support        : yes
#  UTF8 support                : yes
#  Libmagic support            : yes
#  DBUS device handling        : udisks
#  Inotify support             : yes
#  LUA support                 : yes
#  Font engine                 : Xft
#  Maximum command line length : 1572864
#
#
make -j$JOBS
$SUDO make install
cd ..
rm -rf worker-$WORKER_VERSION

unzip .worker.backup*.zip -d ~/

$SUDO cp backup $PREFIX/bin/

echo 'export WORKER_XEDITOR=atom' >> ~/.profile

###############################################################################
