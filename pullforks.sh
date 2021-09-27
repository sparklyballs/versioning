#!/bin/bash

declare -a FORKLIST="\
beer \
chaingreen \
chiarose \
chives \
covid \
cryptodoge \
flax \
flora \
hddcoin \
kiwi \
lotus \
lucky \
maize \
mint \
mogua \
nchain \
pipscoin \
silicoin \
sparecoin \
stor \
taco \
tad"

for fork in ${FORKLIST[@]} ; do
git clone "git@github.com:sparklyballs/${fork}test.git"
done

