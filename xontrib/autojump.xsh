def _autojump_xonsh():
    '''Wrapper function to avoid polluting shell name space when this file is
    sourced'''
    import os
    import platform
    from subprocess import call, check_output, DEVNULL
    import sys

    import xonsh.dirstack as xds

    # tell autojump it's already sourced to fix a traceback
    os.putenv('AUTOJUMP_SOURCED', '1')

    # the $PATH variable from xonsh isn't respected by python's subprocess so
    # put it in the environment
    os.environ["PATH"] = ':'.join($PATH)


    # set error file location
    if platform.system() == "Darwin":
        $AUTOJUMP_ERROR_PATH = os.path.join($HOME,
                                            "Library/autojump/errors.log")
    elif "XDG_DATA_HOME" in __xonsh__.env:
        $AUTOJUMP_ERROR_PATH = os.path.join($XDG_DATA_HOME,
                                            "autojump/errors.log")
    else:
        $AUTOJUMP_ERROR_PATH = os.path.join($HOME,
                                            ".local/share/autojump/errors.log")

    if not os.path.exists(os.path.dirname($AUTOJUMP_ERROR_PATH[0])):
        os.makedirs(os.path.dirname($AUTOJUMP_ERROR_PATH[0]))

    @events.on_chdir
    def autojump_add_to_database(olddir, newdir, **kwargs):
        if os.path.exists(os.path.dirname($AUTOJUMP_ERROR_PATH[0])):
            with open($AUTOJUMP_ERROR_PATH[0], 'w+') as f:
                call(['autojump', '--add', os.path.abspath(newdir)],
                     stderr=f, stdout=DEVNULL)
        else:
            call(['autojump', '--add', os.path.abspath(newdir)], stdout=DEVNULL, stderr=DEVNULL)

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

    def completions(pref, line, *args):
        if ' ' not in line:
            return None # this shouldn't be triggered for command completion 
        firstSpace = line.index(' ')
        firstWord = line[:firstSpace]
        if firstWord != 'j' and firstWord != 'jc' and \
            firstWord != 'jo' and firstWord != 'jco':
            return None
        a=!(autojump --complete @(line[firstSpace+1:].split(' ')))
        return set([e for e in a.out.split('\n') if e != ''])

    completer remove autojump
    completer add autojump completions start

_autojump_xonsh()

del _autojump_xonsh
