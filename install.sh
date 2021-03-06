#!/bin/sh

set -e

current_dir=`basename ${PWD}`
files_dir="files"
dotfiles=`find ${files_dir} -type f -depth 1 -exec basename {} \;`
dotdirs=`find ${files_dir} -type d -not -name ${files_dir} -depth 1 -exec basename {} \;`

for F in ${dotfiles} ${dotdirs}; do
    rm -f ${HOME}/${F}
    (cd ${HOME} && ln -s ${current_dir}/${files_dir}/${F} .)
done
