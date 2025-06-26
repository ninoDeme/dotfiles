#!/bin/bash

set -o pipefail

FONT_NAME=$1

DIR=/tmp/nf-$(date -Ins)
mkdir $DIR
cd $DIR
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FONT_NAME.tar.xz
tar -xf $FONT_NAME.tar.xz
rm $FONT_NAME.tar.xz
rm -rf $HOME/.local/share/fonts/$FONT_NAME
mkdir -p $HOME/.local/share/fonts/$FONT_NAME
cp ./* $HOME/.local/share/fonts/$FONT_NAME/

