#!/bin/bash

declare -a FORKLIST="\
btcgreen \
chia \
chinilla \
chives \
ecostake \
flax \
flora \
gold \
hddcoin \
littlelambocoin \
maize \
mint \
nchain \
petroleum \
profit \
silicoin \
stai \
stor  \
venidium \
"

for fork in ${FORKLIST[@]} ; do
git clone "git@github.com:sparklyballs/${fork}test.git"
done

