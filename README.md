USAGE
=====

```
mkdir dotfiles
fetch -o -  https://api.github.com/repos/trombik/dotfiles/tarball | tar --strip-components 1 -C dotfiles -xf -
cd dotfiles
sh install.sh
```
