---
title: "BioSequenceSlice"
weight: 20
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# The `BioSequenceSlice` class 

## Constructor of `BioSequenceSlice`

The `BioSequenceSlice` constructor accepts an optional `capacity` parameter:

- `capacity`: an optional `number` specifying the initial capacity of the slice.
  Default value is `0`.

```lua
slice = BioSequenceSlice.new(100)
```

## `BioSequenceSlice` Methods

### `push`

The `push` method adds a `BioSequence` object to the end of the `BioSequenceSlice`.
It accepts a `BioSequence` parameter and does not return anything.

```lua
slice = BioSequenceSlice.new(10)
seq = BioSequence.new("seq_1", "gctagctg", "First sequence")
slice:push(seq)
print(slice:len())
```

### `pop`

The `pop` method removes and returns the last `BioSequence` object from the `BioSequenceSlice`.
If the slice is empty, it returns nothing.

```lua
slice = BioSequenceSlice.new(10)
seq1 = BioSequence.new("seq_1", "gctagctg")
seq2 = BioSequence.new("seq_2", "atatata")
slice:push(seq1)
slice:push(seq2)
popped = slice:pop()
print(popped:id())
print(slice:len())
```

### `sequence`

The `sequence` method retrieves or modifies a `BioSequence` object at a specific index
within the `BioSequenceSlice`.

When used with one parameter (the index), it returns the `BioSequence` object at that position.
The index is 0-based.

```lua
slice = BioSequenceSlice.new()
seq1 = BioSequence.new("seq_1", "gctagctg")
seq2 = BioSequence.new("seq_2", "atatata")
slice:push(seq1)
slice:push(seq2)
first_seq = slice:sequence(0)
print(first_seq:id())
```

When used with two parameters (the index and a `BioSequence` object), it sets the
`BioSequence` at the specified index.

```lua
slice = BioSequenceSlice.new()
seq1 = BioSequence.new("seq_1", "gctagctg")
seq2 = BioSequence.new("seq_2", "atatata")
seq3 = BioSequence.new("seq_3", "ggggggg")
slice:push(seq1)
slice:push(seq2)
slice:sequence(1, seq3)
retrieved = slice:sequence(1)
print(retrieved:id())
```

### `len`

The `len` method returns the number of `BioSequence` objects in the `BioSequenceSlice`
as a `number`.

```lua
slice = BioSequenceSlice.new()
print(slice:len())
seq = BioSequence.new("seq_1", "gctagctg")
slice:push(seq)
print(slice:len())
```

### `fasta`

The `fasta` method converts all `BioSequence` objects in the slice to FASTA format.
The result is a single string with each sequence on a separate line.
It accepts an optional `format` parameter ("json" or "obi") to specify the header format.
Default format is JSON header.

```lua
slice = BioSequenceSlice.new()
seq1 = BioSequence.new("seq_1", "gctagctg", "First")
seq2 = BioSequence.new("seq_2", "atatata", "Second")
slice:push(seq1)
slice:push(seq2)
fasta_str = slice:fasta("obi")
print(fasta_str)
```

### `fastq`

The `fastq` method converts all `BioSequence` objects in the slice to FASTQ format.
The result is a single string with each sequence on separate lines.
It accepts an optional `format` parameter ("json" or "obi") to specify the header format.
Default format is JSON header.

```lua
slice = BioSequenceSlice.new()
seq1 = BioSequence.new("seq_1", "gctagctg", "First", {65, 66, 67, 68, 69, 70, 71, 72})
seq2 = BioSequence.new("seq_2", "atatata", "Second", {65, 66, 67, 68, 69, 70, 71, 72})
slice:push(seq1)
slice:push(seq2)
fastq_str = slice:fastq("obi")
print(fastq_str)
```

### `string`

The `string` method returns a string representation of all `BioSequence` objects in the slice.
The format depends on whether all sequences have quality scores: FASTQ format if all have
qualities, FASTA format otherwise.
It accepts an optional `format` parameter ("json" or "obi") to specify the header format.

```lua
slice = BioSequenceSlice.new()
seq1 = BioSequence.new("seq_1", "gctagctg", "First")
seq2 = BioSequence.new("seq_2", "atatata", "Second")
slice:push(seq1)
slice:push(seq2)
str = slice:string("obi")
print(str)
```
