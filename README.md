dotfiles
=========

Bash aliases and helper scripts

## Quickstart
```bash
. <(curl -L https://j.mp/_rc) runsascoded/.rc
```

This downloads [`clone-and-source.sh`](https://github.com/ryan-williams/git-helpers/blob/master/clone/clone-and-source.sh) and runs it on this GitHub repo (`runsascoded/.rc`), cloning it into `.rc/` and appending `source .rc/.*rc` to your `.bashrc`.

[The `server` branch][server] is default, and excludes a few modules:
```bash
submodules() {
    git ls-tree "$@" | grep commit | awk '{print $4}'
}
comm -3 <(submodules server) <(submodules all)
#	hammerspoon
#	osx
#	ruby
```

[The `all` branch][all] includes all modules.

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

[server]: https://github.com/runsascoded/.rc/tree/server
[all]: https://github.com/runsascoded/.rc/tree/all
