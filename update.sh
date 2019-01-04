#!/bin/bash

set -e

if [ $# -eq 0 ] ; then
	echo "Usage: ./update.sh v#.#.#"
	exit
fi

VERSION=$1

TMP=tmp
mkdir $TMP

git clone https://github.com/halverneus/static-file-server $TMP

docker build -t sfs-builder -f $TMP/Dockerfile.all $TMP

ID=$(docker create sfs-builder)

rm -rf out
mkdir -p out
docker cp $ID:/build/pkg/linux-amd64/serve ./out/static-file-server-$VERSION-linux-amd64
docker cp $ID:/build/pkg/linux-i386/serve ./out/static-file-server-$VERSION-linux-386
docker cp $ID:/build/pkg/linux-arm6/serve ./out/static-file-server-$VERSION-linux-arm6
docker cp $ID:/build/pkg/linux-arm7/serve ./out/static-file-server-$VERSION-linux-arm7
docker cp $ID:/build/pkg/linux-arm64/serve ./out/static-file-server-$VERSION-linux-arm64
docker cp $ID:/build/pkg/darwin-amd64/serve ./out/static-file-server-$VERSION-darwin-amd64
docker cp $ID:/build/pkg/win-amd64/serve.exe ./out/static-file-server-$VERSION-windows-amd64.exe

docker cp $ID:/build/pkg/linux-amd64/serve ./linux/amd64/serve
docker cp $ID:/build/pkg/linux-i386/serve ./linux/i386/serve
docker cp $ID:/build/pkg/linux-arm6/serve ./linux/arm32v6/serve
docker cp $ID:/build/pkg/linux-arm7/serve ./linux/arm32v7/serve
docker cp $ID:/build/pkg/linux-arm64/serve ./linux/arm64v8/serve
docker cp $ID:/build/pkg/win-amd64/serve.exe ./windows/amd64/serve.exe

docker rm -f $ID
docker rmi sfs-builder
rm -rf $TMP

echo "Done"

