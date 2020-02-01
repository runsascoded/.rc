dotfiles
=========

Bash aliases and helper scripts

## Quickstart
```bash
wget -O_ https://bit.ly/_rc && . _ ryan-williams/dotfiles
```

This downloads [`clone-and-source.sh`](https://github.com/ryan-williams/git-helpers/blob/master/clone/clone-and-source.sh), and runs it on this GitHub repo (`ryan-williams/dotfiles`), cloning it into `dotfiles/` and appending `source dotfiles/.*rc` to your `.bashrc`.

## Install dependencies (optional)

A few submodules require additional setup steps (but can be ignored if unused):

- [python](./py)
- [hammerspoon](./hammerspoon)

Similarly these modules need certain dependencies to be installed, for some functionality to work:
- [java](./jar): install [jenv](https://www.jenv.be/)
- [parallel](./parallel): install [GNU Parallel](https://www.gnu.org/software/parallel/)
- [ruby](./ruby): install [rbenv](https://github.com/rbenv/rbenv)
- [js](./js): install [nvm](https://github.com/nvm-sh/nvm)

### OSX

On OSX, these brew packages should cover most or all of the above:

```bash
brew install \
    autoconf \
    coreutils \
    gettext \
    git \
    grep \
    htop \
    jenv \
    mysql \
    ncurses \
    nvm \
    openssl \
    parallel \
    pcre \
    pcre2 \
    pkg-config \
    pyenv \
    pyenv-virtualenv \
    rbenv \
    readline \
    ruby-build \
    sqlite \
    xz \
    zlib
```
