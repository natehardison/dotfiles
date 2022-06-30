See https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos for more.

The included `tmux-256color.src` file is already patched and can be directly
installed into `~/.local/share/terminfo/` via the following command:

    $ /usr/bin/tic -x -o $HOME/.local/share/terminfo tmux-256color.src

This requires the `$TERMINFO_DIRS` environment variable to be set accordingly.
