---
title: "Taxonomy"
weight: 30
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# The `Taxonomy` class 

## Constructor of `Taxonomy`

The `Taxonomy` constructor creates a new taxonomy object. It requires the following parameters:

- `name`: a `string` specifying the name of the taxonomy.
- `code`: a `string` representing the taxonomy code.
- `charset`: an optional `string` parameter defining the character set for taxon IDs.
  Default value is ASCII alphanumeric characters.

```lua
taxonomy = Taxonomy.new("ITIS", "itis", "0123456789")
```

### Static Methods

#### `Taxonomy.default`

The `Taxonomy.default` static method returns the default taxonomy if one has been set.
It returns a `Taxonomy` object or raises an error if no default taxonomy exists.

```lua
obitax.RegisterTaxonomy()
obitax.SetDefaultTaxonomy(Taxonomy.new("default", "dt"))
default_taxo = Taxonomy.default()
print(default_taxo:name())
```

#### `Taxonomy.has_default`

The `Taxonomy.has_default` static method checks whether a default taxonomy has been set.
It returns a `boolean` value (`true` if a default taxonomy exists, `false` otherwise).

```lua
obitax.RegisterTaxonomy()
print(Taxonomy.has_default())
```

## `Taxonomy` Methods

### `name`

The `name` method extracts the taxonomy name from a `Taxonomy` object.
It returns a `string` representing the name of the taxonomy.

```lua
taxonomy = Taxonomy.new("ITIS", "itis", "0123456789")
print(taxonomy:name())
```

### `code`

The `code` method extracts the taxonomy code from a `Taxonomy` object.
It returns a `string` representing the code of the taxonomy.

```lua
taxonomy = Taxonomy.new("ITIS", "itis", "0123456789")
print(taxonomy:code())
```

### `taxon`

The `taxon` method extracts a taxon from a `Taxonomy` object by its taxonomic identifier.
It accepts a `string` parameter representing the taxon ID.
It returns a `Taxon` object or `nil` if the taxon does not exist.

```lua
taxonomy = Taxonomy.new("ITIS", "itis", "0123456789")
taxonomy:taxon("1", "0", "Bacteria", "root", true)
taxon = taxonomy:taxon("1")
if taxon then
    print(taxon:scientific_name())
end
```