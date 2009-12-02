import os
import sys

from numpy.distutils.core import setup, Extension
from setuphelp import info_factory, NotFoundError

f = open('__version__.py')
PYSDIF_VERSION = f.readline().strip()

def is_valid_version(s):
    def is_valid_int(s):
        try:
            int(s)
        except ValueError:
            return False
        return True
    digits = s.split('.')
    o = len(digits) == 3
    o = all(is_valid_int(digit) for digit in digits) and o
    return o

assert is_valid_version(PYSDIF_VERSION)
print "pysdif version = ", PYSDIF_VERSION

SDIF_MAJ_VERSION = 1

metadata = {
    'name'             : 'pysdif',
    'version'          : PYSDIF_VERSION,
    'description'      : '',
    'long_description' : '',
    'url'              : '',
    'download_url'     : '', 
    'author'           : 'Eduardo Moguillansky',
    'author_email'     : 'moguillansky@gmx.de',
    'maintainer'       : 'Eduardo Moguillansky',
    'maintainer_email' : 'moguillansky@gmx.de',
    }



def configuration(parent_package='',top_path=None):
    from numpy.distutils.misc_util import Configuration
    confgr = Configuration('pysdif',parent_package,top_path)

    sf_info = info_factory('sdif', ['sdif'], ['sdif.h'])()
    try:
        sf_config = sf_info.get_info(2)
    except NotFoundError:
        raise NotFoundError("""\
sdif library not found.""")

    confgr.add_extension('_pysdif', ['_pysdif.c'], extra_info=sf_config)

    return confgr

if __name__ == "__main__":
    from sdif_setup import cython_setup
    cython_setup()
    from numpy.distutils.core import setup as numpy_setup
    config = configuration(top_path='').todict()
    config.update(metadata)
    numpy_setup(**config)
