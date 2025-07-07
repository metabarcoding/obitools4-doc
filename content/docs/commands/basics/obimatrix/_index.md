---
archetype: "command"
title: "obimatrix"
date: 2025-02-10
command: "obimatrix"
category: basics
url: "/obitools/obimatrix"
weight: 100
---

# `obimatrix`: convert a sequence file into a data matrix file

## Description 

Convert a mapping tag from a sequence file to a matrix file in CSV format.

## Synopsis

```bash
obimatrix [--batch-size <int>] [--csv] [--debug] [--ecopcr] [--embl]
          [--fasta] [--fastq] [--force-one-cpu] [--genbank] [--help|-h|-?]
          [--input-OBI-header] [--input-json-header] [--map <string>]
          [--max-cpu <int>] [--na-value <string>] [--no-order] [--pprof]
          [--pprof-goroutine <int>] [--pprof-mutex <int>]
          [--sample-name <string>] [--silent-warning] [--solexa]
          [--three-columns] [--transpose] [--u-to-t] [--value-name <string>]
          [--version] [<args>]
```

## Options

#### {{< obi obimatrix >}} specific options

- {{< cmd-options/obimatrix/map >}}
- {{< cmd-options/obimatrix/na-value >}}
- {{< cmd-options/obimatrix/sample-name >}}
- {{< cmd-options/obimatrix/three-columns >}}
- {{< cmd-options/obimatrix/transpose >}}
- {{< cmd-options/obimatrix/value-name >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obimatrix --help
```
