#!/bin/bash

# turn on verbose debugging output for parabuild logs.
set -x
# make errors fatal
set -e

if [ -z "$AUTOBUILD" ] ; then 
    fail
fi

APR_VERSION="1.5.2"

if [ "$OSTYPE" = "cygwin" ] ; then
    export AUTOBUILD="$(cygpath -u $AUTOBUILD)"
fi

# load autbuild provided shell functions and variables
set +x
eval "$("$AUTOBUILD" source_environment)"
set -x

STAGING_DIR="$(pwd)"
TOP_DIR="$(dirname "$0")"

echo "${APR_VERSION}" > "${STAGING_DIR}/VERSION.txt"

case "$AUTOBUILD_PLATFORM" in
"windows")
    pushd "$TOP_DIR"
    DEBUG_OUT_DIR="$STAGING_DIR/lib/debug"
    RELEASE_OUT_DIR="$STAGING_DIR/lib/release"

    load_vsvars
 
    build_sln "apr-util/aprutil.sln" "Debug|Win32"   "apr"  || exit 1
    build_sln "apr-util/aprutil.sln" "Release|Win32" "apr"  || exit 1
    build_sln "apr-util/aprutil.sln" "Debug|Win32"   "aprutil"  || exit 1
    build_sln "apr-util/aprutil.sln" "Release|Win32" "aprutil"  || exit 1
    build_sln "apr-util/aprutil.sln" "Debug|Win32"   "apriconv"  || exit 1
    build_sln "apr-util/aprutil.sln" "Release|Win32" "apriconv"  || exit 1
    build_sln "apr-util/aprutil.sln" "Debug|Win32"    "libaprutil" || exit 1
    build_sln "apr-util/aprutil.sln" "Release|Win32"  "libaprutil" || exit 1
    
    mkdir -p "$DEBUG_OUT_DIR"   || echo "$DEBUG_OUT_DIR exists"
    mkdir -p "$RELEASE_OUT_DIR" || echo "$RELEASE_OUT_DIR exists"
    cp "apr/LibD/apr-1.lib" "$DEBUG_OUT_DIR" || exit 1
    cp "apr/LibR/apr-1.lib" "$RELEASE_OUT_DIR" || exit 1
    cp "apr-util/LibD/aprutil-1.lib" "$DEBUG_OUT_DIR" || exit 1
    cp "apr-util/LibR/aprutil-1.lib" "$RELEASE_OUT_DIR" || exit 1
    cp "apr-iconv/LibD/apriconv-1.lib" "$DEBUG_OUT_DIR" || exit 1
    cp "apr-iconv/LibR/apriconv-1.lib" "$RELEASE_OUT_DIR" || exit 1
    cp "apr/Debug/libapr-1."{lib,dll} "$DEBUG_OUT_DIR" || exit 1
    cp "apr/Release/libapr-1."{lib,dll} "$RELEASE_OUT_DIR" || exit 1
    cp "apr/Debug/libapr_src.pdb" "$DEBUG_OUT_DIR" || exit 1
    cp "apr/Release/libapr_src.pdb" "$RELEASE_OUT_DIR" || exit 1
    cp "apr-iconv/Debug/libapriconv-1."{lib,dll} "$DEBUG_OUT_DIR" || exit 1
    cp "apr-iconv/Release/libapriconv-1."{lib,dll} "$RELEASE_OUT_DIR" || exit 1
    cp "apr-util/Debug/libaprutil-1."{lib,dll} "$DEBUG_OUT_DIR" || exit 1
    cp "apr-util/Release/libaprutil-1."{lib,dll} "$RELEASE_OUT_DIR" || exit 1
    cp "apr-util/Debug/libaprutil_src.pdb" "$DEBUG_OUT_DIR" || exit 1
    cp "apr-util/Release/libaprutil_src.pdb" "$RELEASE_OUT_DIR" || exit 1

    INCLUDE_DIR="$STAGING_DIR/include/apr-1"
    mkdir -p "$INCLUDE_DIR"      || echo "$INCLUDE_DIR exists"
    cp apr/include/*.h "$INCLUDE_DIR"
    cp apr-iconv/include/*.h "$INCLUDE_DIR"
    cp apr-util/include/*.h "$INCLUDE_DIR"
    mkdir "$INCLUDE_DIR/arch"    || echo "$INCLUDE_DIR/arch exists"
    cp apr/include/arch/apr_private_common.h "$INCLUDE_DIR/arch"
    cp -R "apr/include/arch/win32" "$INCLUDE_DIR/arch"
    mkdir "$INCLUDE_DIR/private" || echo "$INCLUDE_DIR/private exists"
    cp -R apr-util/include/private "$INCLUDE_DIR"
    popd
;;

"windows64")
    pushd "$TOP_DIR"
    DEBUG_OUT_DIR="$STAGING_DIR/lib/debug"
    RELEASE_OUT_DIR="$STAGING_DIR/lib/release"

    load_vsvars
 
    build_sln "apr-util/aprutil.sln" "Debug|x64"   "apr"  || exit 1
    build_sln "apr-util/aprutil.sln" "Release|x64" "apr"  || exit 1
    build_sln "apr-util/aprutil.sln" "Debug|x64"   "aprutil"  || exit 1
    build_sln "apr-util/aprutil.sln" "Release|x64" "aprutil"  || exit 1
    build_sln "apr-util/aprutil.sln" "Debug|x64"   "apriconv"  || exit 1
    build_sln "apr-util/aprutil.sln" "Release|x64" "apriconv"  || exit 1
    build_sln "apr-util/aprutil.sln" "Debug|x64"    "libaprutil" || exit 1
    build_sln "apr-util/aprutil.sln" "Release|x64"  "libaprutil" || exit 1
    
    mkdir -p "$DEBUG_OUT_DIR"   || echo "$DEBUG_OUT_DIR exists"
    mkdir -p "$RELEASE_OUT_DIR" || echo "$RELEASE_OUT_DIR exists"
    cp "apr/x64/LibD/apr-1.lib" "$DEBUG_OUT_DIR" || exit 1
    cp "apr/x64/LibR/apr-1.lib" "$RELEASE_OUT_DIR" || exit 1
    cp "apr-util/x64/LibD/aprutil-1.lib" "$DEBUG_OUT_DIR" || exit 1
    cp "apr-util/x64/LibR/aprutil-1.lib" "$RELEASE_OUT_DIR" || exit 1
    cp "apr-iconv/x64/LibD/apriconv-1.lib" "$DEBUG_OUT_DIR" || exit 1
    cp "apr-iconv/x64/LibR/apriconv-1.lib" "$RELEASE_OUT_DIR" || exit 1
    cp "apr/x64/Debug/libapr-1."{lib,dll} "$DEBUG_OUT_DIR" || exit 1
    cp "apr/x64/Release/libapr-1."{lib,dll} "$RELEASE_OUT_DIR" || exit 1
    cp "apr/x64/Debug/libapr_src.pdb" "$DEBUG_OUT_DIR" || exit 1
    cp "apr/x64/Release/libapr_src.pdb" "$RELEASE_OUT_DIR" || exit 1
    cp "apr-iconv/x64/Debug/libapriconv-1."{lib,dll} "$DEBUG_OUT_DIR" || exit 1
    cp "apr-iconv/x64/Release/libapriconv-1."{lib,dll} "$RELEASE_OUT_DIR" || exit 1
    cp "apr-util/x64/Debug/libaprutil-1."{lib,dll} "$DEBUG_OUT_DIR" || exit 1
    cp "apr-util/x64/Release/libaprutil-1."{lib,dll} "$RELEASE_OUT_DIR" || exit 1
    cp "apr-util/x64/Debug/libaprutil_src.pdb" "$DEBUG_OUT_DIR" || exit 1
    cp "apr-util/x64/Release/libaprutil_src.pdb" "$RELEASE_OUT_DIR" || exit 1

    INCLUDE_DIR="$STAGING_DIR/include/apr-1"
    mkdir -p "$INCLUDE_DIR"      || echo "$INCLUDE_DIR exists"
    cp apr/include/*.h "$INCLUDE_DIR"
    cp apr-iconv/include/*.h "$INCLUDE_DIR"
    cp apr-util/include/*.h "$INCLUDE_DIR"
    mkdir "$INCLUDE_DIR/arch"    || echo "$INCLUDE_DIR/arch exists"
    cp apr/include/arch/apr_private_common.h "$INCLUDE_DIR/arch"
    cp -R "apr/include/arch/win32" "$INCLUDE_DIR/arch"
    mkdir "$INCLUDE_DIR/private" || echo "$INCLUDE_DIR/private exists"
    cp -R apr-util/include/private "$INCLUDE_DIR"
    popd
;;

'darwin')
    PREFIX="$STAGING_DIR"

    opts='-arch i386 -arch x86_64 -iwithsysroot /Developer/SDKs/MacOSX10.10.sdk -mmacosx-version-min=10.8'

    pushd "$TOP_DIR/apr"
    CC="llvm-gcc" CFLAGS="$opts" CXXFLAGS="$opts" LDFLAGS="$opts" \
        ./configure --prefix="$PREFIX"
    make
    make install
    popd

    pushd "$TOP_DIR/apr-util"
    CC="llvm-gcc" CFLAGS="$opts" CXXFLAGS="$opts" LDFLAGS="$opts" \
        ./configure --prefix="$PREFIX" --with-apr="$PREFIX" \
        --with-expat="$PREFIX"
    make
    make install
    popd

    # To conform with autobuild install-package conventions, we want to move
    # the libraries presently in "$PREFIX/lib" to "$PREFIX/lib/release".
    # We want something like:

    # libapr-1.a
    # libaprutil-1.a
    # libapr-1.0.dylib
    # libapr-1.dylib --> libapr-1.0.dylib
    # libaprutil-1.0.dylib
    # libaprutil-1.dylib --> libaprutil-1.0.dylib

    # But as of 2012-02-08, we observe that the real libraries are
    # libapr-1.0.4.5.dylib and libaprutil-1.0.4.1.dylib, with
    # libapr[util]-1.0.dylib (as well as libapr[util]-1.dylib) symlinked to
    # them. That's no good: our Copy3rdPartyLibs.cmake and viewer_manifest.py
    # scripts don't deal with the libapr[util]-1.0.major.minor.dylib files
    # directly, they want to manipulate only libapr[util]-1.0.dylib. Fix
    # things while relocating.

    mkdir -p "$PREFIX/lib/release" || echo "reusing $PREFIX/lib/release"
    for libname in libapr libaprutil
    do # First just move the static library, that part is easy
       mv "$PREFIX/lib/$libname-1.a" "$PREFIX/lib/release/"
       # Ensure that lib/release/$libname-1.0.dylib is a real file, not a symlink
       cp "$PREFIX/lib/$libname-1.0.dylib" "$PREFIX/lib/release"
       # Make sure it's stamped with the -id we need in our app bundle.
       # As of 2012-02-07, with APR 1.4.5, this function has been observed to
       # fail on TeamCity builds. Does the failure matter? Hopefully not...
       pushd "$PREFIX/lib/release"
       fix_dylib_id "$libname-1.0.dylib" || \
       echo "fix_dylib_id $libname-1.0.dylib failed, proceeding"
       popd
       # Recreate the $libname-1.dylib symlink, because the one in lib/ is
       # pointing to (e.g.) libapr-1.0.4.5.dylib -- no good
       ln -svf "$libname-1.0.dylib" "$PREFIX/lib/release/$libname-1.dylib"
       # Clean up whatever's left in $PREFIX/lib for this $libname (e.g.
       # libapr-1.0.4.5.dylib)
       rm "$PREFIX/lib/$libname-"*.dylib || echo "moved all $libname-*.dylib"
    done

    # When we linked apr-util against apr (above), it grabbed the -id baked
    # into libapr-1.0.dylib as of that moment. A libaprutil-1.0.dylib built
    # that way fails to load because it looks for
    # "$PREFIX/lib/libapr-1.0.dylib" even on the user's machine. We tried
    # horsing around with install_name_tool -id between building apr and
    # building apr-util, but that didn't work too well. Fix it after the fact
    # with install_name_tool -change.

    # <deep breath>

    # List library dependencies with otool -L. Skip the first two lines (tail
    # -n +3): the first is otool reporting which library file it's reading,
    # the second is that library's own -id stamp. Find embedded references to
    # our own build area (Bad). From each such line, isolate just the
    # pathname. (Theoretically we could use just awk instead of grep | awk,
    # but getting awk to deal with the forward-slashes embedded in the
    # pathname would be a royal pain. Simpler to use grep.) Now emit a -change
    # switch for each of those pathnames: extract the basename and change it
    # to the canonical relative Resources path. NOW: feed all those -change
    # switches into an install_name_tool command operating on that same
    # .dylib.
    lib="$PREFIX/lib/release/libaprutil-1.0.dylib"
    install_name_tool \
        $(otool -L -arch all "$lib" | tail -n +3 | \
          grep "$PREFIX/lib" | awk '{ print $1 }' | \
          (while read f; \
           do echo -change "$f" "@executable_path/../Resources/$(basename "$f")"; \
           done) ) \
        "$lib"
;;

'linux')
    PREFIX="$STAGING_DIR"
    JOBS=`cat /proc/cpuinfo | grep processor | wc -l`
    HARDENED="-fstack-protector-strong -D_FORTIFY_SOURCE=2"

    cp "$PREFIX/packages/include/expat/expat.h" "$PREFIX/packages/include/"
    cp "$PREFIX/packages/include/expat/expat_external.h" "$PREFIX/packages/include/"

    # do release builds
    pushd "$TOP_DIR/apr"
        LDFLAGS="-m32" CFLAGS="-m32 -O3 -g $HARDENED" CXXFLAGS="-m32 -O3 -g $HARDENED" ./configure --prefix="$PREFIX" --libdir="$PREFIX/lib/release"
        make -j$JOBS
        make install
    popd

    pushd "$TOP_DIR/apr-iconv"
        # NOTE: the autotools scripts in iconv don't honor the --libdir switch so we
        # need to build to a dummy prefix and copy the files into the correct place
        mkdir "$PREFIX/iconv"
        LDFLAGS="-m32" CFLAGS="-m32 -O3 -g $HARDENED" CXXFLAGS="-m32 -O3 -g $HARDENED" ./configure --prefix="$PREFIX/iconv" --with-apr="../apr"
        make -j$JOBS
        make install

        # move the files into place
        mkdir -p "$PREFIX/bin"
        cp -a "$PREFIX"/iconv/lib/* "$PREFIX/lib/release"
        cp -r "$PREFIX/iconv/include/apr-1" "$PREFIX/include/"
        cp "$PREFIX/iconv/bin/apriconv" "$PREFIX/bin/"
        rm -rf "$PREFIX/iconv"
    popd

    pushd "$TOP_DIR/apr-util"
        # the autotools can't find the expat static lib with the layout of our
        # libraries so we need to copy the file to the correct location temporarily
        cp "$PREFIX/packages/lib/release/libexpat.a" "$PREFIX/packages/lib/"

        # the autotools for apr-util don't honor the --libdir switch so we
        # need to build to a dummy prefix and copy the files into the correct place
        mkdir "$PREFIX/util"
        LDFLAGS="-m32" CFLAGS="-m32 -O3 -g $HARDENED" CXXFLAGS="-m32 -O3 -g $HARDENED" ./configure --prefix="$PREFIX/util" \
                    --with-apr="../apr" --with-apr-iconv="../apr-iconv" --with-expat="$PREFIX/packages/"
        make -j$JOBS
        make install

        # move files into place
        mkdir -p "$PREFIX/bin"
        cp -a "$PREFIX"/util/lib/* "$PREFIX/lib/release/"
        cp -r "$PREFIX/util/include/apr-1" "$PREFIX/include/"
        cp "$PREFIX"/util/bin/* "$PREFIX/bin/"
        rm -rf "$PREFIX/util"
        rm -rf "$PREFIX/packages/lib/libexpat.a"
    popd

    pushd "$TOP_DIR/apr"
        make distclean
    popd
    pushd "$TOP_DIR/apr-iconv"
        make distclean
    popd
    pushd "$TOP_DIR/apr-util"
        make distclean
    popd

    # do release builds
    pushd "$TOP_DIR/apr"
        LDFLAGS="-m32" CFLAGS="-m32 -Og -g" CXXFLAGS="-m32 -Og -g" ./configure --prefix="$PREFIX" --libdir="$PREFIX/lib/debug"
        make -j$JOBS
        make install
    popd

    pushd "$TOP_DIR/apr-iconv"
        # NOTE: the autotools scripts in iconv don't honor the --libdir switch so we
        # need to build to a dummy prefix and copy the files into the correct place
        mkdir "$PREFIX/iconv"
        LDFLAGS="-m32" CFLAGS="-m32 -Og -g" CXXFLAGS="-m32 -Og -g" ./configure --prefix="$PREFIX/iconv" --with-apr="../apr"
        make -j$JOBS
        make install

        # move the files into place
        mkdir -p "$PREFIX/bin"
        cp -a "$PREFIX"/iconv/lib/* "$PREFIX/lib/debug"
        cp -r "$PREFIX/iconv/include/apr-1" "$PREFIX/include/"
        cp "$PREFIX/iconv/bin/apriconv" "$PREFIX/bin/"
        rm -rf "$PREFIX/iconv"
    popd

    pushd "$TOP_DIR/apr-util"
        # the autotools can't find the expat static lib with the layout of our
        # libraries so we need to copy the file to the correct location temporarily
        cp "$PREFIX/packages/lib/debug/libexpat.a" "$PREFIX/packages/lib/"

        # the autotools for apr-util don't honor the --libdir switch so we
        # need to build to a dummy prefix and copy the files into the correct place
        mkdir "$PREFIX/util"
        LDFLAGS="-m32" CFLAGS="-m32 -Og -g" CXXFLAGS="-m32 -Og -g" ./configure --prefix="$PREFIX/util" --with-apr="../apr" --with-apr-iconv="../apr-iconv" --with-expat="$PREFIX/packages/"
        make -j$JOBS
        make install

        # move files into place
        mkdir -p "$PREFIX/bin"
        cp -a "$PREFIX"/util/lib/* "$PREFIX/lib/debug/"
        cp -r "$PREFIX/util/include/apr-1" "$PREFIX/include/"
        cp "$PREFIX"/util/bin/* "$PREFIX/bin/"
        rm -rf "$PREFIX/util"
        rm -rf "$PREFIX/packages/lib/libexpat.a"
    popd

    rm -rf "$PREFIX/packages/include/expat.h"
    rm -rf "$PREFIX/packages/include/expat_external.h"

    # clean 
    pushd "$TOP_DIR/apr"
        make distclean
    popd
    pushd "$TOP_DIR/apr-iconv"
        make distclean
    popd
    pushd "$TOP_DIR/apr-util"
        make distclean
    popd
;;
'linux64')
    PREFIX="$STAGING_DIR"
    JOBS=`cat /proc/cpuinfo | grep processor | wc -l`
    HARDENED="-fstack-protector-strong -D_FORTIFY_SOURCE=2"

    cp "$PREFIX/packages/include/expat/expat.h" "$PREFIX/packages/include/"
    cp "$PREFIX/packages/include/expat/expat_external.h" "$PREFIX/packages/include/"

    # do release builds
    pushd "$TOP_DIR/apr"
        LDFLAGS="-m64" CFLAGS="-m64 -O3 -g $HARDENED" CXXFLAGS="-m64 -O3 -g $HARDENED" ./configure --prefix="$PREFIX" --libdir="$PREFIX/lib/release"
        make -j$JOBS
        make install
    popd

    pushd "$TOP_DIR/apr-iconv"
        # NOTE: the autotools scripts in iconv don't honor the --libdir switch so we
        # need to build to a dummy prefix and copy the files into the correct place
        mkdir "$PREFIX/iconv"
        LDFLAGS="-m64" CFLAGS="-m64 -O3 -g $HARDENED" CXXFLAGS="-m64 -O3 -g $HARDENED" ./configure --prefix="$PREFIX/iconv" --with-apr="../apr"
        make -j$JOBS
        make install

        # move the files into place
        mkdir -p "$PREFIX/bin"
        cp -a "$PREFIX"/iconv/lib/* "$PREFIX/lib/release"
        cp -r "$PREFIX/iconv/include/apr-1" "$PREFIX/include/"
        cp "$PREFIX/iconv/bin/apriconv" "$PREFIX/bin/"
        rm -rf "$PREFIX/iconv"
    popd

    pushd "$TOP_DIR/apr-util"
        # the autotools can't find the expat static lib with the layout of our
        # libraries so we need to copy the file to the correct location temporarily
        cp "$PREFIX/packages/lib/release/libexpat.a" "$PREFIX/packages/lib/"

        # the autotools for apr-util don't honor the --libdir switch so we
        # need to build to a dummy prefix and copy the files into the correct place
        mkdir "$PREFIX/util"
        LDFLAGS="-m64" CFLAGS="-m64 -O3 -g $HARDENED" CXXFLAGS="-m64 -O3 -g $HARDENED" ./configure --prefix="$PREFIX/util" \
            --with-apr="../apr" --with-apr-iconv="../apr-iconv" --with-expat="$PREFIX/packages/"
        make -j$JOBS
        make install

        # move files into place
        mkdir -p "$PREFIX/bin"
        cp -a "$PREFIX"/util/lib/* "$PREFIX/lib/release/"
        cp -r "$PREFIX/util/include/apr-1" "$PREFIX/include/"
        cp "$PREFIX"/util/bin/* "$PREFIX/bin/"
        rm -rf "$PREFIX/util"
        rm -rf "$PREFIX/packages/lib/libexpat.a"
    popd

    pushd "$TOP_DIR/apr"
        make distclean
    popd
    pushd "$TOP_DIR/apr-iconv"
        make distclean
    popd
    pushd "$TOP_DIR/apr-util"
        make distclean
    popd

    # do release builds
    pushd "$TOP_DIR/apr"
        LDFLAGS="-m64" CFLAGS="-m64 -Og -g" CXXFLAGS="-m64 -Og -g" ./configure --prefix="$PREFIX" --libdir="$PREFIX/lib/debug"
        make -j$JOBS
        make install
    popd

    pushd "$TOP_DIR/apr-iconv"
        # NOTE: the autotools scripts in iconv don't honor the --libdir switch so we
        # need to build to a dummy prefix and copy the files into the correct place
        mkdir "$PREFIX/iconv"
        LDFLAGS="-m64" CFLAGS="-m64 -Og -g" CXXFLAGS="-m64 -Og -g" ./configure --prefix="$PREFIX/iconv" --with-apr="../apr"
        make -j$JOBS
        make install

        # move the files into place
        mkdir -p "$PREFIX/bin"
        cp -a "$PREFIX"/iconv/lib/* "$PREFIX/lib/debug"
        cp -r "$PREFIX/iconv/include/apr-1" "$PREFIX/include/"
        cp "$PREFIX/iconv/bin/apriconv" "$PREFIX/bin/"
        rm -rf "$PREFIX/iconv"
    popd

    pushd "$TOP_DIR/apr-util"
        # the autotools can't find the expat static lib with the layout of our
        # libraries so we need to copy the file to the correct location temporarily
        cp "$PREFIX/packages/lib/debug/libexpat.a" "$PREFIX/packages/lib/"

        # the autotools for apr-util don't honor the --libdir switch so we
        # need to build to a dummy prefix and copy the files into the correct place
        mkdir "$PREFIX/util"
        LDFLAGS="-m64" CFLAGS="-m64 -Og -g" CXXFLAGS="-m64 -Og -g" ./configure --prefix="$PREFIX/util" --with-apr="../apr" --with-apr-iconv="../apr-iconv" --with-expat="$PREFIX/packages/"
        make -j$JOBS
        make install

        # move files into place
        mkdir -p "$PREFIX/bin"
        cp -a "$PREFIX"/util/lib/* "$PREFIX/lib/debug/"
        cp -r "$PREFIX/util/include/apr-1" "$PREFIX/include/"
        cp "$PREFIX"/util/bin/* "$PREFIX/bin/"
        rm -rf "$PREFIX/util"
        rm -rf "$PREFIX/packages/lib/libexpat.a"
    popd

    rm -rf "$PREFIX/packages/include/expat.h"
    rm -rf "$PREFIX/packages/include/expat_external.h"

    # clean 
    pushd "$TOP_DIR/apr"
        make distclean
    popd
    pushd "$TOP_DIR/apr-iconv"
        make distclean
    popd
    pushd "$TOP_DIR/apr-util"
        make distclean
    popd
;;
esac

mkdir -p "$STAGING_DIR/LICENSES"
cat "$TOP_DIR/apr/LICENSE" > "$STAGING_DIR/LICENSES/apr_suite.txt"

pass

