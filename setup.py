from setuptools import setup

long_description = open('README.md').read()

setup(
    name='xontrib-autojump',
    version='1.3',
    url='https://github.com/willsALMANJ/autojump-xonsh',
    license='GPLv3+',
    author='Will Shanks',
    author_email='wshaos@posteo.net',
    description='autojump support for xonsh',
    long_description=long_description,
    long_description_content_type='text/markdown',
    packages=['xontrib'],
    package_dir={'xontrib': 'xontrib'},
    package_data={'xontrib': ['*.xsh']},
    platforms='any',
)
