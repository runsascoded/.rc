dotfiles
=========

Bash aliases and helper scripts

## Setup

### Clone directly into your home directory:

```bash
git init
git remote add upstream git@github.com:ryan-williams/dotfiles.git
git fetch upstream --recurse-submodules
git checkout master
git submodule update --init --recursive
source .dotfiles-rc
```

Automatically source `.dotfiles-rc` from your usual `.bashrc`:

```bash
echo "source .dotfiles-rc" >> "$HOME"/.bashrc
```

### Clone into a subdirectory of `$HOME`

```bash
git clone --recurse-submodules git@github.com:ryan-williams/dotfiles.git
echo "source \"$PWD\"/dotfiles/.dotfiles-rc" >> "$HOME"/.bashrc
```

### Install dependencies

See setup instructions in a few submodules that have/need them:

- [python](./py)
- [hammerspoon](./hammerspoon)

These modules need things installed:
- [java](./jar): install [jenv](https://www.jenv.be/)
- [parallel](./parallel): install [GNU Parallel](https://www.gnu.org/software/parallel/)
- [ruby](./ruby): install [rbenv](https://github.com/rbenv/rbenv)
- [js](./js): install [nvm](https://github.com/nvm-sh/nvm)

#### OSX

Here are brew packages that should take care of most things:

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
