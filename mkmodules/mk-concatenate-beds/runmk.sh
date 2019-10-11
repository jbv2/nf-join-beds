#!/bin/bash

find -L . \
        -type f \
        -name "*.sorted.bed" \
        ! -name "tagged.sorted.concatenated.bed" \
        -exec dirname {} \; \
| sort -u \
| sed "s#\$#/tagged.sorted.concatenated.bed#" \
| xargs mk $@
