# dotfiles

Personal dotfiles. Tracked here as plain files (no leading dots); `install.sh`
symlinks each one into `$HOME` under its real dotted name.

## Fresh machine

```sh
git clone git@github.com:leoshaw/home.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` is idempotent and backs up (renames, never deletes) anything
already at a target path in `$HOME` before linking over it.

## Migrating a machine still on the old layout

Before this repo was restructured, it was checked out directly at `~/.git`,
making the whole home directory a git working tree. If another machine is
still on that old layout, bring it over to match:

1. **Back up first** — commit or stash any local changes to the tracked
   dotfiles on that machine (`.gitconfig`, `.vimrc`, `.tigrc`, `.vim/`,
   `Brewfile`) before doing anything below, in case they differ from what's
   already pushed here.

2. **Pull the latest history** while the repo is still rooted at `~`:
   ```sh
   cd ~
   git pull origin master
   ```
   At this point `git status` will show the old dotted files (`.vimrc`,
   `.gitconfig`, etc.) as deleted and nothing new checked out — that's
   expected, since the new commits moved everything to un-dotted names
   under a `dotfiles/` path, but `~` is still git's working-tree root so it
   doesn't see that directory as anything special yet.

3. **Relocate `.git` to `~/dotfiles` and let the checkout catch up**:
   ```sh
   mkdir -p ~/dotfiles
   mv ~/.git ~/dotfiles/.git
   cd ~/dotfiles
   git checkout -- .
   ```
   The `git checkout -- .` restores the working tree to match HEAD, which
   now means populating `~/dotfiles` with `vimrc`, `gitconfig`, `vim/`, etc.

4. **Remove the old dotted files from `$HOME`** if they're still sitting
   there from before the pull (they'll be stale copies, not the ones git is
   tracking anymore):
   ```sh
   rm -f ~/.vimrc ~/.gitconfig ~/.tigrc ~/.Brewfile
   rm -rf ~/.vim
   ```
   Skip any of these you already confirmed in step 1 you don't need to keep.

5. **Run the install script**:
   ```sh
   ~/dotfiles/install.sh
   ```

6. **Verify**:
   ```sh
   git -C ~ rev-parse --show-toplevel   # should now error: not a git repository
   git -C ~/dotfiles status             # should be clean
   ls -la ~ | grep -E '\.vimrc|\.vim$|\.gitconfig|\.tigrc|\.Brewfile'  # all symlinks
   ```
