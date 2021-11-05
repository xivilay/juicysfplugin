BUILD_DIR="../../build"
FLUIDSYNTH_BUILD_DIR=$BUILD_DIR/fluidsynth
FLUIDSYNTH_DIR=../../external/fluidsynth
CMAKE_CMD_ARGS="
    $FLUIDSYNTH_DIR \
    -Denable-floats=1 \
    -Denable-libsndfile=1 \
    -Denable-threads=1 \
    -Denable-pkgconfig=1 \
    -Denable-aufile=0 \
    -Denable-dbus=0 \
    -Denable-dsound=0 \
    -Denable-ipv6=0 \
    -Denable-jack=0 \
    -Denable-ladspa=0 \
    -Denable-libinstpatch=0 \
    -Denable-midishare=0 \
    -Denable-network=0 \
    -Denable-openmp=0 \
    -Denable-oss=0 \
    -Denable-pulseaudio=0 \
    -Denable-readline=0 \
    -Denable-sdl2=0 \
    -Denable-wasapi=0 \
    -Denable-waveout=0 \
    -Denable-winmidi=0 \
    -Denable-alsa=0 \
    -Denable-lash=0 \
"

mkdir $BUILD_DIR
rmdir $FLUIDSYNTH_BUILD_DIR
mkdir $FLUIDSYNTH_BUILD_DIR
cd    $FLUIDSYNTH_BUILD_DIR

cmake $CMAKE_CMD_ARGS
cmake --build . --config Release