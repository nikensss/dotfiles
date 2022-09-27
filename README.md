## Instructions

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

## Debugging bash scripts

Use this `#!`:

```bash
#!/usr/bin/env -S bash -x
```

## Git stash

To save a stash with a message:

```
git stash push -m "my_stash_name"
```

To list stashes:

```
git stash list
```

All the stashes are stored in a stack.

To apply and remove the nth stash:

```
git stash pop stash@{n}
```

To apply and remove a stash by name:

```
git stash pop stash^{/my_stash_name}
```

To apply the nth stash:

```
git stash apply stash@{n}
```

To apply a stash by name:

```
git stash apply stash^{/my_stash_name}
```

## Show timestamp in zsh history

```bash
history -i
```
