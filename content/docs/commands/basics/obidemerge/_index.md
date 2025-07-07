---
archetype: "command"
title: "obidemerge"
date: 2025-02-10
command: "obidemerge"
category: basics
url: "/obitools/obidemerge"
weight: 60
---

# `obidemerge`

## Description 



## Synopsis

```bash
obidemerge [--batch-size <int>] [--compress|-Z] [--csv] [--debug]
           [--demerge|-d <string>] [--ecopcr] [--embl] [--fail-on-taxonomy]
           [--fasta] [--fasta-output] [--fastq] [--fastq-output]
           [--force-one-cpu] [--genbank] [--help|-h|-?] [--input-OBI-header]
           [--input-json-header] [--json-output] [--max-cpu <int>]
           [--no-order] [--no-progressbar] [--out|-o <FILENAME>]
           [--output-OBI-header|-O] [--output-json-header] [--pprof]
           [--pprof-goroutine <int>] [--pprof-mutex <int>] [--raw-taxid]
           [--silent-warning] [--skip-empty] [--solexa]
           [--taxonomy|-t <string>] [--u-to-t] [--update-taxid] [--version]
           [--with-leaves] [<args>]
```

## Options

#### {{< obi obidemerge >}} specific options

- {{< cmd-options/obidemerge/demerge >}}
- {{< cmd-options/paired-with >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obidemerge --help
```
