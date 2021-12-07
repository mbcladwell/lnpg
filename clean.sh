#!/bin/bash
rm ./ChangeLog
rm -Rf  ./build-aux
rm ./configure.ac
rm ./Makefile.am
rm ./pre-inst-env.in
rm ./guix.scm
rm ./hall.scm
rm ./scripts/*.sql
rm ./scripts/*.sh
rm ./*.go
rm ./lnpg/*.go
rm ./lnpg-0.1.tar.gz
hall init --convert --author "mbc" lnpg --execute
hall scan -x
hall build -x
cp /home/mbc/syncd/tobedeleted/lnpgaccessories/guix.scm .
cp /home/mbc/syncd/tobedeleted/lnpgaccessories/*.sh ./scripts
cp /home/mbc/syncd/tobedeleted/lnpgaccessories/*.sql ./scripts

autoreconf -vif && ./configure && make
cp /home/mbc/syncd/tobedeleted/lnpgaccessories/Makefile.am .
make dist

cp ./lnpg-0.1.tar.gz /home/mbc/projects/limsn/scripts
cp ./guix.scm /home/mbc/projects/limsn/scripts/lnpgrecipe.scm

guix package --install-from-file=guix.scm
source /home/mbc/.guix-profile/etc/profile
