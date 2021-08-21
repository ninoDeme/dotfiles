#!/usr/bin/env bash
mkdir fonts
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SourceCodePro.zip >> fonts/SourceCodePro.zip
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DejaVuSansMono.zip >> fonts/DejaVuSansMono.zip
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/RobotoMono.zip >> fonts/RobotoMono.zip
cd fonts
unzip "*.zip"
rm *.zip
rm *Compatible.ttf
sudo mv *.ttf /usr/share/fonts/truetype/
cd ..
rm -d fonts/
