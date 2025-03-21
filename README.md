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

## Configs

### `git`
I typically run [git/config/init-instance] once per instance, to initialize global configs:
```bash
. .rc/git/config/init-instance
```

[`git/.git-rc`] automatically adds several configuration paths, if they exist:
- `core.excludesfile`: `~/git/ignore`, `~/global.gitignore`
- `core.attributesfile`: `~/git/attributes`, `~/.gitattributes`

### `htop`
Configure custom `htop` format ([`htoprc`]) for `root` user:
```
sudo mkdir -p /root/.config/htop
sudo ln $HOME/.rc/linux/htoprc /root/.config/htop/
```


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
[git/config/init-instance]: https://github.com/ryan-williams/git-helpers/blob/main/config/init-instance
[`htoprc`]: https://github.com/ryan-williams/linux-helpers/blob/main/htoprc
