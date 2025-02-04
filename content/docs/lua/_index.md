+++
title = 'Lua: for scripting OBITools'
date = 2024-10-22T19:11:36+02:00
draft = true
weight = 300
+++

# Lua: the scripting language for OBITools

[Lua](https://www.lua.org/) is a scripting language. Its name means moon in Portuguese. Its purpose is to provide an interpreter that can be easily integrated into software to add scripting capabilities. OBITools provides the {{< obi obiscript >}} command for this purpose. The {{< obi obiscript >}} command allows a small script to be applied to each selected sequence in a sequence file. The Lua interpreter used by {{< obi obiscript >}} is [GopherLua](https://github.com/yuin/gopher-lua) Version 1.1.1 which implements Lua version 5.1.

The aim of this section is not to be a full introduction to [Lua](https://www.lua.org/), but to show how to write a [Lua](https://www.lua.org/) script that can be used with {{< obi obiscript >}}. A full documentation of [Lua](https://www.lua.org/) is available on the official website of the language (https://www.lua.org/manual/5.1\).


## The structure of a Lua script for {{< obi obiscript >}}

{{< code example.lua lua true >}}

### The `begin` and finish function

### The `worker` function

## The `obicontext` to share information

## The OBITools classes

### The `BioSequence` class

### The `BioSequenceSlice` class

### The `Taxonomy` class

### The `Taxon` class

## Dealing with the OBITools4 multithreading

{{< code extrem_quality.lua lua true>}}

