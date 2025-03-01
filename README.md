# runsascoded/.rc – dotfiles

Bash aliases and helper scripts

## Quickstart
```bash
. <(curl -L https://j.mp/_rc) runsascoded/.rc
```

This downloads [`clone-and-source.sh`] and runs it on this repo/branch, cloning into `.rc/`, appending to `.bashrc` (to `source` [`.rc`] in new sessions), and `source`ing [`.rc`] in the current session.

This branch ([server]) is default; [all] includes a few additional modules:
```bash
submodules() {
    git ls-tree "$@" | grep commit | awk '{print $4}'
}
comm -3 <(submodules server) <(submodules all)
#	hammerspoon
#	osx
#	ruby
```

[This repo][gl .rc] and [its submodules][gl rc] are also mirrored on GitLab.

## Install dependencies (optional)

A few submodules require additional setup steps (but can be ignored if unused):
- [java](./jar) → [jenv](https://www.jenv.be/)
- [js](./js) → [nvm](https://github.com/nvm-sh/nvm)
- [parallel](./parallel) → [GNU Parallel](https://www.gnu.org/software/parallel/)
- [python](./py): doesn't install Python, but provides [`install_pyenv`] and [`install_conda`] helpers.

## Git configs
I typically set these global configs as well:
```bash
# Link global Git config file to ~/git/config
mkdir -p git
touch git/config
ln -s git/config ~/.gitconfig
touch git/ignore
rs  # Reload shell

# Set default Git configs
git config --global init.defaultBranch main           # a.k.a. `gdbm`
git config --global clone.defaultRemoteName u         # a.k.a. `gcdr u`
git config --global push.default current              # a.k.a. `gpdc`
git config --global receive.denyCurrentBranch ignore  # a.k.a. `gaps`
git config --global diff.noprefix true                # a.k.a. `gdnpt`
git config --global diff.submodule log                # a.k.a. `gcdsl`
```
(aliases above are defined in [git-helpers])

Additionally, here's how I configure some common global `.gitignore` patterns:
```bash
# a.k.a. `gggi ...`
git global-gitignore \
  "*.egg-info" \
  ".ipynb_checkpoints" \
  "__pycache__" \
  ".jupyter" \
  ".python-version" \
  "*.iml" \
  ".idea" \
  "node_modules" \
  ".vite"
```

[`git/.git-rc`] automatically adds several configuration paths, if they exist:
- `core.excludesfile`: `~/git/ignore`, `~/global.gitignore`
- `core.attributesfile`: `~/git/attributes`, `~/.gitattributes`


[`clone-and-source.sh`]: https://github.com/ryan-williams/git-helpers/blob/master/clone/clone-and-source.sh
[`.rc`]: .rc
[server]: https://gitlab.com/runsascoded/.rc/tree/server
[all]: https://gitlab.com/runsascoded/.rc/tree/all
[gl .rc]: https://gitlab.com/runsascoded/.rc
[gl rc]: https://gitlab.com/runsascoded/rc

[`install_pyenv`]: https://github.com/ryan-williams/py-helpers/blob/2d87d1e9268eb0306ca9a9a6608d90ee500d92b5/.py-rc#L163-L202
[`install_conda`]: https://github.com/ryan-williams/py-helpers/blob/2d87d1e9268eb0306ca9a9a6608d90ee500d92b5/.conda-rc#L16-L49
[Hammerspoon]: https://www.hammerspoon.org/
[git-helpers]: https://github.com/ryan-williams/git-helpers

[`git/.git-rc`]: https://github.com/ryan-williams/git-helpers/blob/main/.git-rc
