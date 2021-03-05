#!/usr/bin/env sh
#set -eo pipefail

ls tmp && rm -r tmp/* || mkdir tmp
cp -r src tmp/src
cp -r test tmp/test
cd tmp
sed -ri 's#//(.+= require\(.+\).+)#\1#g' test/spec/*.js
sed -ri 's#//.*(module.exports.+)#\1#g' src/*.js
npm --prefix test install
npm --prefix test test
cd -
rm -rf tmp

