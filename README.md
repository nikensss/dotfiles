# Instructions

If you run this with `sudo`, all installed packages and programs will be owned
by the root user. I have to investigate if, by making myself a `sudoer`, that
changes.

```bash
bash -c "$(curl -fsSL https://raw.github.com/nikensss/dotfiles/main/install.sh)"
```

## Ignore `git` revisions

```bash
git config blame.ignoreRevsFile .git-blame-ignore-revs
echo $FULL_COMMIT_HASH_TO_BE_IGNORED >> .git-blame-ignore-revs
```
