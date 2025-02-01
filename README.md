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
git config --global init.defaultBranch main           # a.k.a. `gdbm`
git config --global clone.defaultRemoteName u         # a.k.a. `gcdr u`
git config --global push.default current              # a.k.a. `gpdc`
git config --global receive.denyCurrentBranch ignore  # a.k.a. `gaps`
git config --global diff.noprefix true                # a.k.a. `gdnpt`
```
(aliases above are defined in [git-helpers])

Additionally, a global `.gitignore` can be initialized like:
```bash
mkdir ~/git
cat >~/git/ignore <<EOF
*.egg-info
.ipynb_checkpoints
__pycache__
.jupyter
.python-version
*.iml
.idea
node_modules
.vite
```

[`git/.git-rc`] automatically adds `~/git/ignore` and `~/global.gitignore` to the global `core.excludesfile` config, if they exist.

Similarly, it adds `~/git/attributes` and `~/.gitattributes` to the global `core.attributesfile` config, if they exist.


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

[`git/.git-rc`]: git/.git-rc
