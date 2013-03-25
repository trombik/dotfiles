#!/bin/sh

for F in `(cd files && ls -1 .[[:alpha:]]*)`; do
    (cd ${HOME} && ln -s ${HOME}/dotfiles/files/${F} .)
done
