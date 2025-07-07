---
archetype: "command"
title: "obicsv"
date: 2025-02-10
command: "obicsv"
category: basics
url: "/obitools/obicsv"
weight: 50
---

# `obicsv`

### Description 

Convert a sequence file to a CSV file.

### Synopsis

```bash
obicsv [--auto] [--batch-size <int>] [--compress|-Z] [--count] [--csv]
       [--debug] [--definition|-d] [--ecopcr] [--embl] [--fail-on-taxonomy]
       [--fasta] [--fastq] [--force-one-cpu] [--genbank] [--help|-h|-?]
       [--ids|-i] [--input-OBI-header] [--input-json-header]
       [--keep|-k <KEY>]... [--max-cpu <int>] [--na-value <NAVALUE>]
       [--no-order] [--no-progressbar] [--obipairing] [--out|-o <FILENAME>]
       [--pprof] [--pprof-goroutine <int>] [--pprof-mutex <int>]
       [--quality|-q] [--raw-taxid] [--sequence|-s] [--silent-warning]
       [--solexa] [--taxon] [--taxonomy|-t <string>] [--u-to-t]
       [--update-taxid] [--version] [--with-leaves] [<args>]
```

### Options

#### {{< obi obicsv >}} specific options

- {{< cmd-options/obicsv/auto >}}
- {{< cmd-options/obicsv/count >}}
- {{< cmd-options/obicsv/definition >}}
- {{< cmd-options/obicsv/ids >}}
- {{< cmd-options/keep >}}
- {{< cmd-options/obicsv/na-value >}}
- {{< cmd-options/obipairing >}}
- {{< cmd-options/obicsv/quality >}}
- {{< cmd-options/obicsv/sequence >}}
- {{< cmd-options/obicsv/taxon >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
obicsv --help
```
