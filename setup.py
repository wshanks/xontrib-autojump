from setuptools import setup

long_description = open('README.md').read()

setup(
    name='xontrib-autojump',
    version='0.7.1',
    url='https://github.com/gsaga/autojump-xonsh',
    license='MIT',
    author='Sagar Tewari',
    author_email='iaansagar@gmail.com',
    description='autojump support for xonsh',
    long_description=long_description,
    long_description_content_type='text/markdown',
    packages=['xontrib'],
    package_dir={'xontrib': 'xontrib'},
    package_data={'xontrib': ['*.xsh']},
    platforms='any',
)