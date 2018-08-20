from setuptools import setup

setup(
    name='xontrib-autojump',
    version='0.1',
    url='https://github.com/gsaga/autojump-xonsh',
    license='MIT',
    author='Sagar Tewari',
    author_email='iaansagar@gmail.com',
    description='autojump support for xonsh',
    packages=['xontrib'],
    package_dir={'xontrib': 'xontrib'},
    package_data={'xontrib': ['*.xsh']},
    platforms='any',
)