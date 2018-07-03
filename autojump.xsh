$AUTOJUMP_SOURCED = 1

def _autojump_xonsh():
    '''Wrapper function to avoid polluting shell name space when this file is
    sourced'''
    import os
    import platform
    from subprocess import call, check_output, DEVNULL
    import sys
    $BASH_COMPLETIONS.append(os.path.join($AUTOJUMP_DIR,
                                          'autojump-completion.bash'))

    import xonsh.dirstack as xds

    # set error file location
    if platform.system() == "Darwin":
        $AUTOJUMP_ERROR_PATH = os.path.join($HOME,
                                            "Library/autojump/errors.log")
    elif "XDG_DATA_HOME" in __xonsh_env__:
        $AUTOJUMP_ERROR_PATH = os.path.join($XDG_DATA_HOME,
                                            "autojump/errors.log")
    else:
        $AUTOJUMP_ERROR_PATH = os.path.join($HOME,
                                            ".local/share/autojump/errors.log")

    if not os.path.exists(os.path.dirname($AUTOJUMP_ERROR_PATH[0])):
        os.makedirs(os.path.dirname($AUTOJUMP_ERROR_PATH[0]))

    def autojump_add_to_database():
        if os.path.exists(os.path.dirname($AUTOJUMP_ERROR_PATH[0])):
            with open($AUTOJUMP_ERROR_PATH[0], 'w+') as f:
                call(['autojump', '--add', os.path.abspath(os.curdir)],
                     stderr=f, stdout=DEVNULL)
        else:
            call(['autojump', '--add', os.path.abspath(os.curdir)])

    $PROMPT_FIELDS['update_autojump'] = autojump_add_to_database
    $PROMPT = $PROMPT.replace("{prompt_end}", "{prompt_end}{update_autojump}")

    def j(args, stdin=None):
        if args and args[0][0] == '-' and args[0] != '--':
            call(['autojump'] + args)
            return

        output = check_output(['autojump'] + args,
                              universal_newlines=True).strip()
        if os.path.isdir(output):
            # TODO: print with color?
            print(output)
            xds.cd([output])
        else:
            print('autojump directory {} not found'.format(' '.join(args)))
            print(output)
            print('Try `autojump --help` for more information.')

    def jc(args, stdin=None):
        if args and args[0][0] == '-' and args[0] != '--':
            call(['autojump'] + args)
            return
        else:
            j([os.path.abspath(os.curdir)] + args)

    def jo(args, stdin=None):
        if args and args[0][0] == '-' and args[0] != '--':
            call(['autojump'] + args)
            return

        output = check_output(['autojump'] + args,
                              universal_newlines=True).strip()
        if os.path.isdir(output):
            system = platform.system()
            if system == 'Linux':
                call(['xdg-open', output])
            elif system == 'Darwin':
                call(['open', output])
            elif system.lower().startswith('cygwin'):
                path = check_output(['cygpath', '-w', '-a', output],
                                    universal_newlines=True).strip()
                call(['cygstart', '""', path])
            else:
                print("Unknown operating system: {}.".format(system),
                      file=sys.stderr)
        else:
            print('autojump directory {} not found'.format(' '.join(args)))
            print(output)
            print('Try `autojump --help` for more information.')

    def jco(args, stdin=None):
        if args and args[0][0] == '-' and args[0] != '--':
            call(['autojump'] + args)
            return
        else:
            jo([os.path.abspath(os.curdir)] + args)

    global aliases
    aliases['j'] = j
    aliases['jc'] = jc
    aliases['jo'] = jo
    aliases['jco'] = jco

_autojump_xonsh()
del _autojump_xonsh
