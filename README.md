# NetHSM API Generation for Go

This repository contains a Makefile that helps produce the NetHSM API.  

In order to use this you need to have Docker running. You also need sed
installed. This should work on both Linux and macOS.  I have not tested it on
Windows.

The default target checks out the `GIT_REPOSITORY` where you maintain the client, removes all the generated files and copies in the LICENSE file.  It then runs the code generation and re-populates the directory.  This means you can `cd` into this directory, check in changes and push them to the repository.

You can issue `make clean` to remove the generated code.

If you want to generate the code to a different git repository you need to edit the Makefile and change the `TARGET_REPOSITORY` variable.
