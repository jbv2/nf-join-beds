#!/bin/bash

find -L . \
        -type f \
        -name "*.bed" \
        ! -name "*.tagged.bed" \
| sed "s#.bed#.tagged.bed#" \
| xargs mk $@
