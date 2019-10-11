#!/bin/bash

find -L . \
        -type f \
        -name "*.tagged.bed" \
        ! -name "*.sorted.bed" \
| sed "s#.bed#.sorted.bed#" \
| xargs mk $@
