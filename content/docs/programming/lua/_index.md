---
title: 'Lua: for scripting OBITools'
date: 2024-10-22T19:11:36+02:00
draft: true
weight: 20
bookCollapseSection: true
---

# Lua: the scripting language for OBITools

[Lua](https://www.lua.org/) is a scripting language. Its name means moon in Portuguese. Its purpose is to provide an interpreter that can be easily integrated into software to add scripting capabilities. OBITools provides the {{< obi obiscript >}} command for this purpose. The {{< obi obiscript >}} command allows a small script to be applied to each selected sequence in a sequence file. The Lua interpreter used by {{< obi obiscript >}} is [GopherLua](https://github.com/yuin/gopher-lua) Version 1.1.1 which implements Lua version 5.1.

The aim of this section is not to be a full introduction to [Lua](https://www.lua.org/), but to show how to write a [Lua](https://www.lua.org/) script that can be used with {{< obi obiscript >}}. A full documentation of [Lua](https://www.lua.org/) is available on the official website of the language (https://www.lua.org/manual/5.1\).

## The structure of a Lua script for {{< obi obiscript >}}

A Lua script for {{< obi obiscript >}} can define three optional functions:

- **`begin()`**: called once at the start of the script
- **`worker(sequence)`**: called for each sequence
- **`finish()`**: called at the end of the script

```lua
-- example.lua

function begin()
    print("Starting script")
end

function worker(sequence)
    -- Process the sequence
    result = sequence:id()
    print(result)
    return sequence
end

function finish()
    print("Script finished")
end
```

### The `begin` function

The `begin` function is called once at the beginning of the script execution, before any sequences are processed. It can be used to initialize variables, set up counters, or perform one-time setup tasks.

```lua
function begin()
    obicontext.item("compteur", 0)
    print("Script started")
end
```

### The `finish` function

The `finish` function is called once at the end of the script execution, after all sequences have been processed. It can be used to output final results, print statistics, or perform cleanup tasks.

```lua
function finish()
    total = obicontext.item("compteur")
    print("Total sequences processed: " .. total)
end
```

### The `worker` function

The `worker` function is called for each sequence processed by the script. It must accept a single parameter, the `sequence` of type `BioSequence`, and must return either a `BioSequence` or a `BioSequenceSlice`. If the function returns `nil`, `nil`, or nothing, the sequence is skipped.

```lua
function worker(sequence)
    samples = sequence:attribute("merged_sample")
    samples["tutu"] = 4
    sequence:attribute("merged_sample", samples)
    sequence:attribute("toto", 44444)
    
    nb = obicontext.inc("compteur")
    sequence:id("seq_" .. nb)
    
    return sequence
end
```

### The `slice_worker` function

The `slice_worker` function is an alternative to `worker` for batch-level processing. Instead of being called once per sequence, it receives an entire batch as a `BioSequenceSlice` and must return a `BioSequenceSlice`. This is particularly efficient when a single operation can cover all sequences at once — for example, a single HTTP request to an external server.

If both `slice_worker` and `worker` are defined in the same script, `slice_worker` takes precedence.

Because `BioSequence` objects are accessed by pointer, any attribute set on a sequence retrieved from the slice is immediately reflected in the slice — no reassignment is needed.

The batch size is not fixed: it depends on the input file and OBITools4's dynamic flush mechanism. A `slice_worker` must always iterate up to `slice:len()` and must not assume a constant size.

```lua
local json = require("json")

function slice_worker(slice)
    -- Build a batch payload for a single HTTP request
    local ids, seqs = {}, {}
    for i = 0, slice:len() - 1 do
        local s = slice:sequence(i)
        table.insert(ids,  s:id())
        table.insert(seqs, s:sequence())
    end

    local response, err = http.post(SERVER_URL, json.encode({ ids = ids, seqs = seqs }))
    if err then
        return slice  -- return the batch unmodified on error
    end

    local data = json.decode(response)
    -- Annotate each sequence from the response
    for i = 0, slice:len() - 1 do
        local s = slice:sequence(i)
        local score = data[s:id()]
        if score then
            s:attribute("server_score", score)
        end
    end

    return slice
end
```

## The `obicontext` to share information

The `obicontext` module provides a shared context for data exchange between functions and within the `worker` function. It allows you to store and retrieve values using string keys.

### Accessing and modifying context items

The `obicontext.item(key, value)` function can be used to store or retrieve values from the context. When called with two arguments, it stores the value. When called with one argument, it retrieves the value.

```lua
-- Store a value
obicontext.item("counter", 0)

-- Update the counter
obicontext.item("counter", obicontext.item("counter") + 1)

-- Retrieve a value
count = obicontext.item("counter")
```

### Incrementing and decrementing counters

The `obicontext.inc(key)` function increments a numeric value in the context and returns the new value. The `obicontext.dec(key)` function decrements a numeric value.

```lua
-- Increment a counter
counter = obicontext.inc("counter")

-- Decrement a counter
counter = obicontext.dec("counter")
```

### Locking mechanisms

The `obicontext.lock()`, `obicontext.unlock()`, and `obicontext.trylock()` functions provide mutex locking mechanisms for thread-safe operations.

```lua
-- Use Mutex from obicontext
locker = Mutex:new()
obicontext.item("locker", locker)

-- Lock the context
locker:lock()

-- Critical section
print("Processing")

-- Unlock the context
locker:unlock()
```

You can also use the built-in locking functions:

```lua
obicontext.lock()  -- Acquire global lock
-- Critical section
obicontext.unlock()  -- Release global lock

-- Try to acquire lock without blocking
if obicontext.trylock() then
    -- Locked successfully
    -- Work...
    obicontext.unlock()
end
```

## The `http` module

The `http` module allows Lua scripts to make HTTP POST requests directly from `obiscript`, without spawning an external process such as `curl`. The underlying Go `http.Client` is a package-level singleton with keep-alive and connection pooling enabled, so the TCP connection is reused across all calls within a worker — this is particularly efficient when querying the same server for every sequence in the file.

### `http.post(url, body)`

Sends an HTTP POST request to `url` with `body` as the request body. The `Content-Type` header is automatically set to `application/json`. The request timeout is 30 seconds.

**On success** — returns the response body as a string:

```lua
local response = http.post(url, body)
```

**On error** — returns `nil` followed by an error string:

```lua
local response, err = http.post(url, body)
if err then
    print("Request failed: " .. err)
end
```

### Example: querying a REST server for each sequence

```lua
local json = require("json")

local SERVER_URL = string.format(
    "http://%s:%d/api/query",
    os.getenv("SERVER_HOST") or "127.0.0.1",
    tonumber(os.getenv("SERVER_PORT")) or 8080
)

function worker(sequence)
    local payload = json.encode({
        id  = sequence:id(),
        seq = sequence:sequence(),
    })

    local response, err = http.post(SERVER_URL, payload)
    if err then
        sequence:attribute("query_error", err)
        return sequence
    end

    local data = json.decode(response)
    if data and data.score then
        sequence:attribute("server_score", data.score)
    end

    return sequence
end
```

## The OBITools classes

### The `BioSequence` class

The `BioSequence` class represents a nucleic acid sequence. It provides methods to access and modify sequence properties, quality scores, annotations, and taxonomy information. See detailed documentation in [BioSequence class](/docs/programming/lua/OBITools_classes/BioSequence/).

### The `BioSequenceSlice` class

The `BioSequenceSlice` class represents a mutable array of `BioSequence` objects. It allows you to manage multiple sequences and manipulate them as a collection. See detailed documentation in [BioSequenceSlice class](/docs/programming/lua/OBITools_classes/BioSequenceSlice/).

### The `Taxonomy` class

The `Taxonomy` class represents a taxonomic classification system. It contains a collection of `Taxon` objects and provides methods to search and manage taxonomic data. The `Taxonomy` class can be used to add, retrieve, and navigate taxonomic hierarchies. See detailed documentation in [Taxonomy class](/docs/programming/lua/OBITools_classes/Taxonomy/).

### The `Taxon` class

The `Taxon` class represents a taxonomic classification within a `Taxonomy` system. Each taxon has a unique identifier, a parent, a name, and a taxonomic rank. `Taxon` objects can be organized in hierarchical relationships. See detailed documentation in [Taxon class](/docs/programming/lua/OBITools_classes/Taxon/).

## Dealing with the OBITools4 multithreading

The `obicontext` module provides thread-safe mechanisms for sharing data between parallel workers. The `begin()` and `finish()` functions are executed in separate goroutines, while `worker()` functions run in parallel across multiple threads.

For thread-safe operations, always use the mutex mechanisms provided by `obicontext` or create your own `Mutex` objects:

```lua
-- Example: extrem_quality.lua

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
```

The `Mutex` class provides `lock()`, `unlock()`, and `trylock()` methods for thread synchronization. The `obicontext` lock ensures safe access to shared variables between concurrent workers.
