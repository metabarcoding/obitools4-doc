---
title: "BioSequence"
weight: 10
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# The `BioSequence` class 

The `BioSequence` class corresponds to the {{% obitools %}} representation of a nucleic sequence.

## Constructor of `BioSequence`

The `BioSequence` constructor accepts three parameters:

- `sequence_id`: a `string` corresponding to the sequence `id`. The sequence `id` cannot contain white character.
- `dna_sequence`: a `string` representing a nucleic sequence. The `string` is
  converted to lowercases and must only contain characters corresponding to
  IUPAC code.
- `definition`: this parameter is optional. If present, it corresponds to an
  unstructured text, used to describe the sequence.

```lua
sequence = BioSequence.new("sequence_id","gctagctgtgatgctgatgctagct")
```

## BioSequence Methods

### `id` : the sequence identifier

Extract the sequence identifier from a `BioSequence` object.
The method doesn't accept any parameter and returns a `string`.

```lua
sequence = BioSequence.new("sequence_id","gctagctgtgatgctgatgctagct")
print(sequence:id())
```
```
sequence_id
```

A `string` parameter representing a nucleic sequence can be provided to the
`id` method. In this case, the id of the `BioSequence` object is
substituted by the new string. The method does not return anything.

```lua
sequence = BioSequence.new("sequence_id","gctagctgtgatgctgatgctagct")
print(sequence:id())
sequence:sequence("new_id")
print(sequence:id())
```
```
sequence_id
new_id
```

### `sequence` : the nucleic sequence

When used with no parameter, the method extracts the nucleic sequence itself from the `BioSequence` object.
In this condition, it returns a `string`.

```lua
sequence = BioSequence.new("sequence_id","gctagctgtgatgctgatgctagct")
print(sequence:sequence())
```
```
gctagctgtgatgctgatgctagct
```

A `string` parameter representing a nucleic sequence can be provided to the
`sequence` method. In this case, the current sequence of the object is
substituted by the new string. The method does not return anything.

```lua
sequence = BioSequence.new("sequence_id","gctagctgtgatgctgatgctagct")
print(sequence:sequence())
sequence:sequence("cgatctagcta")
print(sequence:sequence())
```
```
gctagctgtgatgctgatgctagct
cgatctagcta
```

### `qualities`

The `qualities` method extracts or sets the quality scores of a `BioSequence` object.
When used with no parameter, it returns a `table` containing the quality values.

```lua
sequence = BioSequence.new("seq_id", "gctagctg", "@@@FFFFHHH")
qualities = sequence:qualities()
for _, q in ipairs(qualities) do
    print(q)
end
```

A quality score table can be provided to the `qualities` method to update
the quality scores of the `BioSequence` object.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
sequence:qualities({65, 66, 67, 68, 69, 70, 71, 72})
qualities = sequence:qualities()
for _, q in ipairs(qualities) do
    print(q)
end
```

### `definition`

The `definition` method extracts or sets the sequence definition of a `BioSequence` object.
When used with no parameter, it returns a `string` or `nil` if no definition is set.

```lua
sequence = BioSequence.new("seq_id", "gctagctg", "This is a test sequence")
print(sequence:definition())
```

A `string` parameter representing the sequence definition can be provided to
the `definition` method to update the definition of the `BioSequence` object.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
sequence:definition("New definition for the sequence")
print(sequence:definition())
```

### `count`

The `count` method extracts or sets the count value from a `BioSequence` object.
When used with no parameter, it returns a `number` or `1` if no count is set.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
print(sequence:count())
```

A `number` parameter representing the count can be provided to the `count` method
to update the count of the `BioSequence` object.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
sequence:count(10)
print(sequence:count())
```

### `taxid`

The `taxid` method extracts or sets the taxonomical identifier from a `BioSequence` object.
When used with no parameter, it returns a `string` or `nil` if no taxid is set.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
print(sequence:taxid())
```

A `string` parameter representing the taxid can be provided to the `taxid` method
to update the taxonomical identifier of the `BioSequence` object.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
sequence:taxid("9606")
print(sequence:taxid())
```

### `taxon`

The `taxon` method extracts the taxonomical information from a `BioSequence` object.
When used with no parameter, it returns a `Taxon` object or `nil` if no taxonomic
data is associated with the sequence.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
taxon = sequence:taxon()
if taxon then
    print(taxon:name())
end
```

A `Taxon` parameter can be provided to the `taxon` method to update the taxonomic
information of the `BioSequence` object.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
taxon = Taxon.new("Homo sapiens", "9606")
sequence:taxon(taxon)
taxon = sequence:taxon()
if taxon then
    print(taxon:name())
end
```

### `attribute`

The `attribute` method extracts or sets an attribute value of a `BioSequence` object.
When used with one parameter (the attribute name), it returns the attribute value
or `nil` if the attribute does not exist.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
print(sequence:attribute("custom"))
```

A value can be provided as a third parameter to set an attribute on the `BioSequence`
object.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
sequence:attribute("custom", "value")
print(sequence:attribute("custom"))
```

### `len`

The `len` method returns the length of the nucleic sequence as a `number`.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
print(sequence:len())
```

### `has_sequence`

The `has_sequence` method checks if the `BioSequence` object contains a nucleic sequence.
It returns a `boolean` value (`true` or `false`).

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
print(sequence:has_sequence())
```

### `has_qualities`

The `has_qualities` method checks if the `BioSequence` object contains quality scores.
It returns a `boolean` value (`true` or `false`).

```lua
sequence = BioSequence.new("seq_id", "gctagctg", "@@@FFFF")
print(sequence:has_qualities())
```

### `source`

The `source` method extracts or sets the source information from a `BioSequence` object.
It returns a `string` or `nil` if no source is set.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
sequence:source("source_file.fasta")
print(sequence:source())
```

### `md5`

The `md5` method computes the MD5 hash of the sequence and returns it as a `table`
of 16 integers representing the hash bytes.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
md5_table = sequence:md5()
for i, byte_val in ipairs(md5_table) do
    print(byte_val)
end
```

### `md5_string`

The `md5_string` method computes the MD5 hash of the sequence and returns it as a
hexadecimal `string`.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
md5_str = sequence:md5_string()
print(md5_str)
```

### `subsequence`

The `subsequence` method extracts a subsequence from the `BioSequence` object.
It accepts two parameters: `start` and `end` positions (1-indexed inclusive).
It returns a new `BioSequence` object containing the subsequence.

```lua
sequence = BioSequence.new("seq_id", "gctagctgtgatgctgatgctagct")
subseq = sequence:subsequence(5, 10)
print(subseq:id())
print(subseq:sequence())
```

### `reverse_complement`

The `reverse_complement` method computes and returns the reverse complement of
the nucleic sequence as a new `BioSequence` object.

```lua
sequence = BioSequence.new("seq_id", "gctagctg")
revcomp = sequence:reverse_complement()
print(revcomp:sequence())
```

### `fasta`

The `fasta` method converts the `BioSequence` object to FASTA format string.
It accepts an optional `format` parameter ("json" or "obi") to specify the header
format. Default format is JSON header.

```lua
sequence = BioSequence.new("seq_id", "gctagctg", "Test sequence")
fasta_str = sequence:fasta("json")
print(fasta_str)
```

```lua
sequence = BioSequence.new("seq_id", "gctagctg", "Test sequence")
fasta_str = sequence:fasta("obi")
print(fasta_str)
```

### `fastq`

The `fastq` method converts the `BioSequence` object to FASTQ format string.
It accepts an optional `format` parameter ("json" or "obi") to specify the header
format. Default format is JSON header.

```lua
sequence = BioSequence.new("seq_id", "gctagctg", "Test sequence", {65, 66, 67, 68, 69, 70, 71, 72})
fastq_str = sequence:fastq("json")
print(fastq_str)
```

### `string`

The `string` method returns a string representation of the `BioSequence` object.
The format depends on whether the sequence has quality scores: FASTQ format if
qualities are present, FASTA format otherwise.
It accepts an optional `format` parameter ("json" or "obi") to specify the header format.

```lua
sequence = BioSequence.new("seq_id", "gctagctg", "Test sequence")
seq_str = sequence:string("obi")
print(seq_str)
```
