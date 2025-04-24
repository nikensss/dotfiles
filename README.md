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

## PSQL

### output query results to a file

```bash
\o <filename>
```

One time to enable, then

```bash
\o
```

to disable.

### transform query results to csv

```bash
\copy (<query>) to <file> with csv delimiter <delimier> header;
```

Example:

```bash
\copy (select a, b, c from "TableName" order by "columnName" desc) to './destination.csv' with csv delimiter ',' header;
```

### count entries per table

```bash
SELECT
    table_schema,
    table_name,
    (xpath('/row/cnt/text()', xml_count)) [1] :: text :: int AS row_count
FROM
    (
        SELECT
            table_name,
            table_schema,
            query_to_xml(
                format(
                    'select count(*) as cnt from %I.%I',
                    table_schema,
                    table_name
                ),
                false,
                TRUE,
                ''
            ) AS xml_count
        FROM
            information_schema.tables
        WHERE
            table_schema = 'public'
    ) t;
```

## Scrolling up in tmux/ssh/screen:

`ctrl-a`+`[`

## Vim

### Project wide search and replace

First find all occurrences with telescope and send to quickfix list (<C-q>).
Then:

```bash
cfdo %s/stringOne/stringTwo/g | update | bd
```

## Redis

### Get all values of keys matching a pattern

```lua
EVAL "local keys = redis.call('KEYS', 'ratelimit:*'); local values = {}; for i, key in ipairs(keys) do values[i] = {key, redis.call('GET', key)}; end; return values;" 0
```
