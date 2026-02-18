#!/usr/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# the awk command prints the second column of the first line
is_dim_active=$(hyprctl getoption decoration:dim_inactive | awk 'NR==1{print $2}')

if [[ $is_dim_active == 1 ]]; then
    hyprctl keyword decoration:dim_inactive false
else
    hyprctl keyword decoration:dim_inactive true
fi
