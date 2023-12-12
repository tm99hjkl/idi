# idi
A simple snippet manager.


# Install
[bat], [fzf], and [xsel] are required. Then execute the following commands:

```console
$ git clone https://github.com/tm99hjkl/idi
$ cd idi
$ make install
```


# Usage
To add a snippet, run like `idi add path/to/foo.c`.
It will be added in `~/.idi/c/foo.c`.

To search a snippet, run `idi` or `idi search`.
Then select the path and type enter to copy the contents (full path if not text) of the file to the clipboard.


<!-- references -->
[bat]: https://github.com/sharkdp/bat
[fzf]: https://github.com/junegunn/fzf
[xsel]: https://vergenet.net/~conrad/software/xsel/#download

