# NetHSM API Generation for Go

This repository contains a Makefile that helps produce the NetHSM API.  

In order to use this you need to have Docker running. You also need sed
installed. This should work on both Linux and macOS.  I have not tested it on
Windows. 

The default target produces a `nethsm` directory with the generated code.

You can issue `make clean` to remove the generated code.

If you want to generate the code to a different git repository you need to edit the Makefile and change the `TARGET_REPOSITORY` variable.
