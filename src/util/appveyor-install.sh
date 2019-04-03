set -e
set -x

ocamlc -version

DIRECTORY=$(pwd)

# AppVeyor does not cache empty subdirectories of .opam, such as $SWITCH/build.
# To get around that, create a tar archive of .opam.
CACHE=$DIRECTORY/../opam-cache-$SYSTEM-$COMPILER-$LIBEV.tar

if [ ! -f $CACHE ]
then
    eval `opam config env`

    # Pin Lwt and install its dependencies.
    opam pin add -y mmap https://github.com/aantron/mmap.git#just-a-shim
    make dev-deps
    if [ "$LIBEV" = yes ]
    then
        opam install -y conf-libev
    fi

    ( cd ~ ; tar cf $CACHE .opam )
else
    ( cd ~ ; tar xf $CACHE )
    eval `opam config env`
fi
