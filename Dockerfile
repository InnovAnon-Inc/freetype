FROM innovanon/xorg-base:latest as builder-01
#COPY --from=innovanon/libxcb      /tmp/libxcb.txz      /tmp/
#RUN cat   /tmp/*.txz  \
#  | tar Jxf - -i -C / \
# && rm -v /tmp/*.txz

ARG LFS=/mnt/lfs
WORKDIR $LFS/sources
USER lfs
# TODO freetype vs freetype2 ?
RUN sleep 31                                                                                   \
 && git clone --depth=1 --recursive https://git.savannah.nongnu.org/git/freetype/freetype2.git \
 && cd                                                                           freetype2     \
 && ./autogen.sh                                                                               \
 && sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg                                         \
 && sed -r  "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:"                                               \
        -i  include/freetype/config/ftoption.h                                                 \
 && ./configure --prefix=/usr/local --enable-freetype-config --disable-shared --enable-static  \
 && make                                                                                       \
 && make DESTDIR=/tmp/freetype2 install                                                        \
 && rm -rf                                                                       freetype2     \
 && cd           /tmp/freetype2                                                                \
 && tar acf        ../freetype2.txz .                                                          \
 && cd ..                                                                                      \
 && rm -rf       /tmp/freetype2

