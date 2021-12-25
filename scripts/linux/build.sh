BUILD_DIR="../../build"
TARGET_TYPE=Release

cd $BUILD_DIR

cmake ../ -D CMAKE_BUILD_TYPE=$TARGET_TYPE
cmake --build . --config $TARGET_TYPE