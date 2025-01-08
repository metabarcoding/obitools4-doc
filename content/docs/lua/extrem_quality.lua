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