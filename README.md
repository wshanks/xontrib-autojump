# Xonsh configuration for autojump
These files set up autojump for use in the [xonsh shell](https://xon.sh) in the same way that it is set up in other shells. To use, save these files in a directory (e.g. `$HOME/.config/autojump`) and then add the following to `.xonshrc` (changing `$AUTOJUMP_DIR` as necessary):

```
import os
$AUTOJUMP_DIR = os.path.join($HOME, '.config/autojump')
source @(os.path.join($AUTOJUMP_DIR, 'autojump.xsh'))
```

Note that `$AUTOJUMP_DIR` needs to be defined so that `autojump.xsh` knows where to find `autojump-completion.bash` (I haven't found a way for a `source`'d xonsh file to determine its directory).
