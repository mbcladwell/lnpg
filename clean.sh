#!/bin/bash
rm ./ChangeLog
rm -Rf  ./build-aux
rm ./configure.ac
rm ./Makefile.am
rm ./pre-inst-env.in
rm ./guix.scm
rm ./hall.scm
rm ./scripts/*.conf
rm ./scripts/*.sql
rm ./scripts/guix-install-mod.sh
rm ./scripts/install-lnpg.sh
rm ./scripts/prep-for-lnpg.sh
rm ./scripts/install-pg.sh
rm ./*.go
rm ./lnpg/*.go
rm ./lnpg-0.1.tar.gz
hall init --convert --author "mbc" lnpg --execute
hall scan -x
hall build -x
cp /home/mbc/syncd/tobedeleted/testfiles/guix.scm .
cp /home/mbc/syncd/tobedeleted/psqlfiles/*.* ./scripts

