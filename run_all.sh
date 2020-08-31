#!/bin/bash

#load R module
load module r-4.0.2-gcc-9.3.0-python3-krncrvc

#list of commands
R -e 'source("/users/dattap/cricket_2020/afghanistan/afgauto.R")' &
R -e 'source("/users/dattap/cricket_2020/australia/ausauto.R")'   &
R -e 'source("/users/dattap/cricket_2020/bangladesh/banauto.R")'  &
R -e 'source("/users/dattap/cricket_2020/england/engauto.R")'     &
R -e 'source("/users/dattap/cricket_2020/india/indauto.R")'       &
R -e 'source("/users/dattap/cricket_2020/ireland/irlauto.R")'     &
R -e 'source("/users/dattap/cricket_2020/newzealand/nzlauto.R")'  &
R -e 'source("/users/dattap/cricket_2020/pakistan/pakauto.R")'    &
R -e 'source("/users/dattap/cricket_2020/southafrica/safauto.R")' &
R -e 'source("/users/dattap/cricket_2020/srilanka/sriauto.R")'    &
R -e 'source("/users/dattap/cricket_2020/westindies/wiauto.R")'   &
R -e 'source("/users/dattap/cricket_2020/zimbabwe/zimauto.R")'    &

