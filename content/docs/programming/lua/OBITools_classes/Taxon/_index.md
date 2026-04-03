---
title: "Taxon"
weight: 40
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# The `Taxon` class 

## Constructor of `Taxon`

The `Taxon` constructor creates a new taxon within a taxonomy. It requires the following parameters:

- `taxonomy`: a `Taxonomy` object representing the taxonomic hierarchy.
- `taxid`: a `string` specifying the taxonomic identifier.
- `parent`: a `string` representing the parent taxon ID.
- `sname`: a `string` for the scientific name of the taxon.
- `rank`: a `string` indicating the taxonomic rank (e.g., "species", "genus", "family").
- `isroot`: an optional `boolean` parameter indicating if this is a root taxon. Default is `false`.

```lua
taxonomy = Taxonomy.new()
taxon = Taxon.new(
    taxonomy,
    "9606",
    "131567",
    "Homo sapiens",
    "species",
    false
)
```

## `Taxon` Methods

### `scientific_name`

The `scientific_name` method extracts or updates the scientific name of a `Taxon` object.

When used with no parameter, it returns the scientific name as a `string`.

```lua
taxonomy = Taxonomy.new()
taxon = Taxon.new(
    taxonomy,
    "9606",
    "131567",
    "Homo sapiens",
    "species",
    false
)
print(taxon:scientific_name())
```

A `string` parameter can be provided to update the scientific name of the `Taxon` object.

```lua
taxonomy = Taxonomy.new()
taxon = Taxon.new(
    taxonomy,
    "9606",
    "131567",
    "Homo sapiens",
    "species",
    false
)
taxon:scientific_name("Humanus sapiens")
print(taxon:scientific_name())
```

### `parent`

The `parent` method extracts the parent taxon from a `Taxon` object.
It returns a `Taxon` object representing the parent, or `nil` if no parent exists.

```lua
taxonomy = Taxonomy.new()
taxon = Taxon.new(
    taxonomy,
    "9606",
    "131567",
    "Homo sapiens",
    "species",
    false
)
parent = taxon:parent()
if parent then
    print(parent:scientific_name())
end
```

### `taxon_at_rank`

The `taxon_at_rank` method extracts the taxon at a specified rank from the `Taxon` object.
It accepts a `string` parameter representing the taxonomic rank.
It returns a `Taxon` object or `nil` if no taxon exists at that rank.

```lua
taxonomy = Taxonomy.new()
taxon = Taxon.new(
    taxonomy,
    "9606",
    "131567",
    "Homo sapiens",
    "species",
    false
)
genus_taxon = taxon:taxon_at_rank("genus")
if genus_taxon then
    print(genus_taxon:scientific_name())
end
```

### `species`

The `species` method extracts the species taxon from a `Taxon` object.
It returns a `Taxon` object representing the species, or `nil` if no species data is available.

```lua
taxonomy = Taxonomy.new()
taxon = Taxon.new(
    taxonomy,
    "9606",
    "131567",
    "Homo sapiens",
    "species",
    false
)
species = taxon:species()
if species then
    print(species:scientific_name())
end
```

### `genus`

The `genus` method extracts the genus taxon from a `Taxon` object.
It returns a `Taxon` object representing the genus, or `nil` if no genus data is available.

```lua
taxonomy = Taxonomy.new()
taxon = Taxon.new(
    taxonomy,
    "9606",
    "131567",
    "Homo sapiens",
    "species",
    false
)
genus = taxon:genus()
if genus then
    print(genus:scientific_name())
end
```

### `family`

The `family` method extracts the family taxon from a `Taxon` object.
It returns a `Taxon` object representing the family, or `nil` if no family data is available.

```lua
taxonomy = Taxonomy.new()
taxon = Taxon.new(
    taxonomy,
    "9606",
    "131567",
    "Homo sapiens",
    "species",
    false
)
family = taxon:family()
if family then
    print(family:scientific_name())
end
```

### `string`

The `string` method returns a string representation of the `Taxon` object.

```lua
taxonomy = Taxonomy.new()
taxon = Taxon.new(
    taxonomy,
    "9606",
    "131567",
    "Homo sapiens",
    "species",
    false
)
taxon_str = taxon:string()
print(taxon_str)
```