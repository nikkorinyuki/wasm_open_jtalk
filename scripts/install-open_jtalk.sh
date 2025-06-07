#!/usr/bin/env bash
set -eu

HERE=$(cd $(dirname $0); pwd)

TOOL_DIR="$HERE/../tools"
JS_DIR="$HERE/../js"
ETC_DIR="$HERE/../etc"
EMSDK_DIR="$TOOL_DIR/emsdk"
OPEN_JTALK_DIR="$TOOL_DIR/open_jtalk"

mkdir -p "$TOOL_DIR"
mkdir -p "$JS_DIR"

mkdir -p "$OPEN_JTALK_DIR/src/build"
cd "$OPEN_JTALK_DIR/src/build"

# emsdkのコマンドにPATHを通す
source "$EMSDK_DIR/emsdk_env.sh"

# libopenjtalk.aをsrc/buildに作成する
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release
emmake make

cd $HERE/..
# libopenjtalk.aからwasm及びjsファイルを作成
# src/bin/open_jtalk.cをビルド
emcc "$OPEN_JTALK_DIR/src/bin/open_jtalk.cpp" \
  -std=c++17 \
  -O2 \
  -lnodefs.js \
  "$OPEN_JTALK_DIR/src/build/libopenjtalk.a" \
	-I $OPEN_JTALK_DIR/src/jpcommon \
	-I $OPEN_JTALK_DIR/src/mecab/src \
	-I $OPEN_JTALK_DIR/src/mecab2njd \
	-I $OPEN_JTALK_DIR/src/njd \
	-I $OPEN_JTALK_DIR/src/njd2jpcommon \
	-I $OPEN_JTALK_DIR/src/njd_set_accent_phrase \
	-I $OPEN_JTALK_DIR/src/njd_set_accent_type \
	-I $OPEN_JTALK_DIR/src/njd_set_digit \
	-I $OPEN_JTALK_DIR/src/njd_set_long_vowel \
	-I $OPEN_JTALK_DIR/src/njd_set_pronunciation \
	-I $OPEN_JTALK_DIR/src/njd_set_unvoiced_vowel \
	-I $OPEN_JTALK_DIR/src/text2mecab \
  -o "$JS_DIR/open_jtalk.js" \
  -s ALLOW_MEMORY_GROWTH=1 \
  -s NODERAWFS=1 \
  -lembind \
  -sEXPORT_ES6=1 \
  --emit-tsd open_jtalk.d.ts
  # --embed-file "etc" \
