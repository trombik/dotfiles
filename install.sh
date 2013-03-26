#!/bin/sh

set -e
for F in `(cd files && ls -1 .[[:alpha:]]*)`; do
    rm -f ${HOME}/${F}
    (cd ${HOME} && ln -s dotfiles/files/${F} .)
done
