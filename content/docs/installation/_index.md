+++
title = 'Installation'
date = 2024-10-08T19:37:31+02:00
draft = true
weight = 20
+++

# Availability

The *OBITools* are open source and protected by the [CeCILL 2.1 license](http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.html).

All the sources of the {{< gloentry "obitools4" >}}  can be downloaded from the metabarcoding GitHub server (https://github.com/metabarcoding).

## Prerequisites

The {{< gloentry "obitools4" >}} are developed using the [GO programming language](https://go.dev/), we stick to the latest version of the language. If you want to download and compile the sources yourself, you first need to install the corresponding compiler on your system. Some parts of the soft are also written in C, therefore a recent C compiler is also requested, GCC on Linux or Windows, the Developer Tools on Mac.

Whichever installation you choose, you will need to ensure that a C compiler is available on your system.

# Installation

## Using the installation script

An installation script that compiles the new {{< gloentry "obitools4" >}} on your Unix-like system is available online.
The easiest way to run it is to copy and paste the following command into your terminal:

```bash
curl -L https://metabarcoding.org/obitools4/install.sh | bash
```

By default, the script installs the {{< gloentry "obitools4" >}} commands and other associated files into the `/usr/local` directory. The names of the commands in the new {{< gloentry "obitools4" >}} are mostly identical to those in previous {{< gloentry "obitools" >}}. Therefore, installing the new {{< gloentry "obitools" >}} may hide or delete the old ones. If you want both versions to be available on your system, the installation script offers two options:


- `--install-dir|-i <PATH>`:  Directory where obitools are installed (as example use `/usr/local` not `/usr/local/bin`).
 
- `--obitools-prefix|-p`:  Prefix added to the obitools command names if you want to have several versions of obitools at the same time on your system (as example `-p g` will produce `gobigrep` command instead of `obigrep`).

You can use these options by following the installation command:

```bash
curl -L https://metabarcoding.org/obitools4/install.sh | \
      bash -s -- --install-dir test_install --obitools-prefix k
```

In this case, the binaries will be installed in the `test_install` directory and all command names will be prefixed with the letter `k`. Thus `obigrep` will be named `kobigrep`.