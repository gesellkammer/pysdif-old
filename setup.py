#!/usr/bin/env python

"""
SDIF for python

This is a wrapper to IRCAM's SDIF C library, written mostly in Cython.

It allows to read and write any kind of SDIF file, to define new
kinds of frames and matrices and to read and write metadata. 

The matrices read from a sdif file are exposed as numpy arrays.

It exposes both a low level and a high level interface.

The low level interface for reading and writing sdif files mirrors the 
sdif library quite transparently so that the example files and 
utilities using it can be directly translated with it. In particular
it does not create any intermediate objects, even the data of the matrices
is a numpy array mapped to the c array read from disk, so no allocation takes
place. Whereas this makes for very fast code, one has to take care to copy the
data if it will be used longer, since by the time a new matrix is read this
data is no longer valid. 

to read for ex. 1TRC format:

import pysdif

sdif_file = pysdif.SdifFile('filename.sdif')
sig1TRC = pysdif.str2signature("1TRC")
while not sdif_file.eof:
    sdif_file.read_frame_header()
    if sdif_file.frame_numerical_signature) == sig1TRC:
        print sdif_file.time
        for n in range(sdif_file.matrices_in_frame):
            sdif_file.read_matrix_header()
            if sdif_file.matrix_numerical_signature == sig1TRC:
                data = sdif_file.get_matrix_data() 
                # data is now a numpy array but you must copy the data if 
                # you intend to keep it after you have read the matrix.
                # One you read a new matrix, this data will be no longer valid
                print data
    
a more natural way:

from pysdif import SdifFile
sdif_file = SdifFile('filename.sdif')
for frame in sdif_file:
    if frame.signature == "1TRC":
        print frame.time
        for matrix in frame:
            if matrix.signature == "1TRC":
                print matrix.get_data()
                
the frames and the matrices resulting from the iteration
are only guaranteed to be valid as long as no new frames and matrices are read

to write a SdifFile:

f = SdifFile('new_sdif.sdif', 'w')
# these are optional
#   add some metadata
f.add_NVT({
    'name' : 'my name',
    'date' : time.asctime(time.localtime())
})
# define new frame and matrix types
f.add_frame_type('1NEW', '1ABC NewMatrix, 1FQ0 New1FQ0')
f.add_matrix_type('1ABC', 'Column1, Column2')
# now you can begin adding frames
frame = f.new_frame('1NEW', time_now)
frame.add_matrix('1ABC', array([
    [0,     1.2],
    [3.5,   8.13],
    ...
    ]))
frame.write()

# say we just want to take the data from an existing
# sdiffile, modify it and write it back
in_sdif = SdifFile("existing-file.sdif")
out_sdif = SdifFile("outfile.sdif", "w")
out_sdif.clone_definitions(in_sdif)
for in_frame in in_sdif:
    if in_frame.signature == "1NEW":
        new_frame = out_sdif.new_frame("1NEW", in_frame.time)
        in_data = in_frame.get_matrix_data() # we know there is only one matrix
        # multiply the second column by 0.5
        in_data[:,1] *= 0.5
        new_frame.add_matrix('1ABC', in_data)
        new_frame.write()

"""

import os
import sys

from numpy.distutils.core import setup, Extension
from setuphelp import info_factory, NotFoundError

f = open('version.cfg')
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

url      = 'git://github.com/gesellkammer/pysdif.git'
download = ''

descr    = __doc__.split('\n')[1:-1]; del descr[1:3]

classifiers = """
Development Status :: 2 - Pre-Alpha
Intended Audience :: Science/Research
License :: OSI Approved :: BSD License
Operating System :: MacOS
Operating System :: POSIX
Operating System :: Unix
Programming Language :: C
Programming Language :: Cython
Programming Language :: Python
Programming Language :: Python :: 2
Topic :: Multimedia
Topic :: Multimedia :: Sound/Audio
Topic :: Multimedia :: Sound/Audio :: Analysis
Topic :: Multimedia :: Sound/Audio :: Sound Synthesis
Topic :: Multimedia :: Sound/Audio :: Speech
Topic :: Scientific/Engineering
Topic :: Software Development :: Libraries :: Python Modules
"""

keywords = """
scientific computing
music
sound analysis
SDIF
IRCAM
"""

platforms = """
Linux
Mac OS X
"""


metadata = {
    'name'             : 'pysdif',
    'version'          : PYSDIF_VERSION,
    'description'      : descr.pop(0),
    'long_description' : '\n'.join(descr),
    'url'              : url,
    'download_url'     : download, 
    'author'           : '',
    'author_email'     : '',
    'maintainer'       : '',
    'maintainer_email' : '',
    'classifiers'      : [c for c in classifiers.split('\n') if c],
    'keywords'         : [k for k in keywords.split('\n')    if k],
    'platforms'        : [p for p in platforms.split('\n')   if p],
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
