#1/bin/bash

R --slave --no-restore --file=Cricket_Simulation.R --args "/users/dattap/cricket_2020/" "Afghanistan"  ${1}  ${2} & 
R --slave --no-restore --file=Cricket_Simulation.R --args "/users/dattap/cricket_2020/" "Australia"    ${1}  ${2} & 
R --slave --no-restore --file=Cricket_Simulation.R --args "/users/dattap/cricket_2020/" "Bangladesh"   ${1}  ${2} & 
R --slave --no-restore --file=Cricket_Simulation.R --args "/users/dattap/cricket_2020/" "England"      ${1}  ${2} & 
R --slave --no-restore --file=Cricket_Simulation.R --args "/users/dattap/cricket_2020/" "India"        ${1}  ${2} & 
R --slave --no-restore --file=Cricket_Simulation.R --args "/users/dattap/cricket_2020/" "Ireland"      ${1}  ${2} & 
R --slave --no-restore --file=Cricket_Simulation.R --args "/users/dattap/cricket_2020/" "New Zealand"  ${1}  ${2} &
R --slave --no-restore --file=Cricket_Simulation.R --args "/users/dattap/cricket_2020/" "Pakistan"     ${1}  ${2} & 
R --slave --no-restore --file=Cricket_Simulation.R --args "/users/dattap/cricket_2020/" "South Africa" ${1}  ${2} & 
R --slave --no-restore --file=Cricket_Simulation.R --args "/users/dattap/cricket_2020/" "Sri Lanka"    ${1}  ${2} & 
R --slave --no-restore --file=Cricket_Simulation.R --args "/users/dattap/cricket_2020/" "West Indies"  ${1}  ${2} & 
R --slave --no-restore --file=Cricket_Simulation.R --args "/users/dattap/cricket_2020/" "Zimbabwe"     ${1}  ${2} & 
