# Package

version       = "0.1.0"
author        = "s0cke3t"
description   = "A nim implementation of sRDI"
license       = "MIT"
srcDir        = "src"
bin           = @["sRDI"]


# Dependencies

requires "nim >= 2.0.0"
requires "winim == 3.9.2"
requires "argparse == 4.0.1"