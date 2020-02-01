dotfiles
=========

Bash aliases and helper scripts

## Quickstart
```bash
wget -O_ https://bit.ly/_rc && . _ ryan-williams/dotfiles
```

This downloads [`clone-and-source.sh`](https://github.com/ryan-williams/git-helpers/blob/master/clone/clone-and-source.sh), and runs it on this GitHub repo (`ryan-williams/dotfiles`), cloning it into `dotfiles/` and appending `source dotfiles/.*rc` to your `.bashrc`.

## Install dependencies (optional)

A few submodules require additional setup steps or dependencies to be installed (but can be ignored if unused):

- [python](./py)
- [java](./jar): install [jenv](https://www.jenv.be/)
- [parallel](./parallel): install [GNU Parallel](https://www.gnu.org/software/parallel/)
- [js](./js): install [nvm](https://github.com/nvm-sh/nvm)

### Additional modules / branches
[The `all` branch](https://github.com/ryan-williams/dotfiles/tree/all) has some additional modules that aren't frequently used or as portable, and so are omitted from this default `master` branch.
