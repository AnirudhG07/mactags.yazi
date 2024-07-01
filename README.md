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
MacOS Finder has various tags based on priorities and usages. I have mapped each tag with a single corresponding letter. The tags are as follows:
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
on = ["u", "a"]
run = "plugin mactags --args=add"
desc = "Add multiple colored tags"
```
```toml
on = ["u", "r"]
run = "plugin mactags --args=remove"
desc = "removes input tags from all tags"
```
```toml
on = ["u", "d"]
run = "plugin mactags --args=remove_all"
desc = "removed all the tags attached"
```
```toml
on = ["u", "s"]
run = "plugin mactags --args=set"
desc = "remove all previous tags and set new ones"
```

### Input
The input format should be as follows:
```
r g i w 
# OR
Red green i work
```
Their should be no spelling mistakes in tags. You can use the mapped letter, full name with any casing you want.

This will add all these 4 tags to the file/folder.

## TODO's
- [X] - Write the add tags function for `tag -a`
- [X] - Write the remove tags function for `tag -r` (including remove all tags)
- [X] - Write the set tags function for `tag -s`
The above are done except for file path handling(selecting hovered file)
- [ ] - Write the match tags function for `tag -m` h hopefully in fzf
- [ ] - Write the find tags function for `tag -f` - hopefully in fzf
- [ ] - Have Tag symbol(colored) displayed in the manager (without calling the plugin)