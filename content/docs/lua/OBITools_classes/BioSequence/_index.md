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
substituted by the new string. The method doesn't return anything.

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
substituted by the new string. The method doesn't return anything.

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

### `definition`

### `count`

### `taxid`

### `taxon`

### `attribute`

### `len`

### `has_sequence`

### `has_qualities`

### `source`

### `md5`

### `md5_string`

### `subsequence`

### `reverse_complement`

### `fasta`

### `fastq`

### `string`
