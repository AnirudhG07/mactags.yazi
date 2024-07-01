# mactags.yazi
Tagging files in yazi like MacOS.

## Requirements
- [yazi](https://github.com/sxyazi/yazi) Version >= 0.2.5
- Tag, which you can install using `brew install tag`

```bash
tag - A tool for manipulating and querying file tags.
  usage:
    tag -a | --add <tags> <path>...     Add tags to file
    tag -r | --remove <tags> <path>...  Remove tags from file
    tag -s | --set <tags> <path>...     Set tags on file
    tag -m | --match <tags> <path>...   Display files with matching tags
    tag -f | --find <tags> <path>...    Find all files with tags (-A, -e, -R ignored)
    tag -u | --usage <tags> <path>...   Display tags used, with usage counts
    tag -l | --list <path>...           List the tags on file
  <tags> is a comma-separated list of tag names; use * to match/find any tag.
```

## Tag names
MacOS Finder has various tags based on priorities and usages. I have mapped each tag wit a single corresponding letter. The tags are as follows:
```
r = "red"
b = "blue"
g = "green"
y = "yellow"
o = "orange"
p = "purple"
a = "grey" -- because grey sounds like a
h = "home"
i = "important"
w = "work"
```

## Usage

### Keymaps
Add the following line to your `keymap.toml` file-

```toml
on = ["b", "a"]
run = "plugin mactags --args=add"
desc = "Add multiple colored tags to a file/folder"
```

### Input
I am hoping to have addition of tags as-
```
r g i w 
```
This will add all these 4 tags to the file/folder.

## TODO's
- [ ] - Write the add tags function for `tag -a`
- [ ] - Write the remove tags function for `tag -r` (including remove all tags)
- [ ] - Write the set tags function for `tag -s`
- [ ] - Write the match tags function for `tag -m` h hopefully in fzf
- [ ] - Write the find tags function for `tag -f` - hopefully in fzf
- [ ] - Have Tag symbol(colored) displayed in the manager (without calling the plugin)