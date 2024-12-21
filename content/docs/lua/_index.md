+++
title = 'Lua: for scripting OBITools'
date = 2024-10-22T19:11:36+02:00
draft = true
+++

# Lua: the scripting language for OBITools

[Lua](https://www.lua.org/) is a scripting language. Its name means moon in Portuguese. Its purpose is to provide an interpreter that can be easily integrated into software to add scripting capabilities. OBITools provides the {{< obi obiscript >}} command for this purpose. The {{< obi obiscript >}} command allows a small script to be applied to each selected sequence in a sequence file. The Lua interpreter used by {{< obi obiscript >}} is [GopherLua](https://github.com/yuin/gopher-lua) Version 1.1.1 which implements Lua version 5.1.

The aim of this section is not to be a full introduction to [Lua](https://www.lua.org/), but to show how to write a [Lua](https://www.lua.org/) script that can be used with {{< obi obiscript >}}. A full documentation of [Lua](https://www.lua.org/) is available on the official website of the language (https://www.lua.org/manual/5.1\).


## The structure of a Lua script for {{< obi obiscript >}}

```lua
function begin()
    obicontext.item("compteur",0)
end

function worker(sequence)
    samples = sequence:attribute("merged_sample")
    samples["tutu"]=4
    sequence:attribute("merged_sample",samples)
    sequence:attribute("toto",44444)
    nb = obicontext.inc("compteur")
    sequence:id("seq_" .. nb)
    return sequence
end

function finish()
    print("compteur = " .. obicontext.item("compteur"))
end
```

### The `begin` and finish function

### The `worker` function

## The `obicontext` to share information

## The OBITools classes

### The `BioSequence` class

### The `BioSequenceSlice` class

## Dealing with the OBITools4 multithreading

```lua
--
-- Script for obiscript extracting the qualities of
-- the first `size` and last `size` base pairs of 
-- all the reads longer than 2 x `size`
--
-- The result is a csv file on the stdout
--
-- obiscript -S ../qualities.lua FAZ61712_c61e82f1_69e58200_0_nolambda.fastq > xxxx

-- Import the io module
local io = require("io")

-- Set the output stream to the stdout of the Go program
io.output(io.stdout)

size = 60

function begin()
    obicontext.item("locker", Mutex:new())
    header = "id"
    for i = 1, size do
        header = header .. ", L" .. i 
    end


    for i = size, 1, -1 do
        header = header .. ", R" .. i
    end

    obicontext.item("locker"):lock()
    print(header)
    obicontext.item("locker"):unlock()

end

function worker(sequence)
    l = sequence:len()

    if l > size * 2 then
    qualities = sequence:qualities()
    rep = sequence:id()

    for i = 1, size do
        rep = rep .. ", " .. qualities[i]
    end

    for i = size, 1, -1 do
        rep = rep .. ", " .. qualities[l - i + 1]
    end

    obicontext.item("locker"):lock()
    print(rep)
    obicontext.item("locker"):unlock()

    end

    return BioSequenceSlice.new()

end

-- function finish()
--     print("compteur = " .. obicontext.item("compteur"))
-- end
```

```bash

```