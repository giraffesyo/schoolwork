#!/bin/bash
cd ../app
yarn build
# zip the build folder
zip -r build.zip build
# move the zip file to the virtual machine
mv build.zip ../virtual-machine/packer
# go to the virtual machine packer folder
cd ../virtual-machine/packer
# build the virtual machine image
packer init .
packer build .