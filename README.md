# Xonsh configuration for autojump

Sets up [autojump](https://github.com/wting/autojump) for use with
[xonsh](https://github.com/xonsh/xonsh) shell.

## Usage

Load it interactively or in your xonsh startup file like this:

```bash
xontrib load autojump
```

and use these aliases:

    j		'autojump' to a directory
    jc		'autojump' to a child directory
    jo		'autojump' to a directory in the default file manager
    jco		'autojump' to a child directory in the default file manager


Target paths will be printed if the environment variable `AUTOJUMP_PRINT_DIR`
is set to a truthy value

## Installation

Install from source with:

```bash
python setup.py install
```

or from pypi with

```bash
pip install xontrib-autojump
```



