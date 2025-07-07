---
archetype: "command"
title: "obiuniq"
date: 2025-02-10
command: "obiuniq"
category: basics
url: "/obitools/obiuniq"
weight: 130
---

# `obiuniq`: dereplicate a sequence file

## Description 

Dereplicate a sequence file, by merging identical sequences.

## Synopsis

```bash
obiuniq [--batch-size <int>] [--category-attribute|-c <CATEGORY>]...
        [--chunk-count <int>] [--compress|-Z] [--csv] [--debug] [--ecopcr]
        [--embl] [--fail-on-taxonomy] [--fasta] [--fasta-output] [--fastq]
        [--fastq-output] [--force-one-cpu] [--genbank] [--help|-h|-?]
        [--in-memory] [--input-OBI-header] [--input-json-header]
        [--json-output] [--max-cpu <int>] [--merge|-m <KEY>]...
        [--na-value <NA_NAME>] [--no-order] [--no-progressbar]
        [--no-singleton] [--out|-o <FILENAME>] [--output-OBI-header|-O]
        [--output-json-header] [--pprof] [--pprof-goroutine <int>]
        [--pprof-mutex <int>] [--raw-taxid] [--silent-warning] [--skip-empty]
        [--solexa] [--taxonomy|-t <string>] [--u-to-t] [--update-taxid]
        [--version] [--with-leaves] [<args>]
```

## Options

#### {{< obi obiuniq >}} specific options

- {{< cmd-options/obiuniq/category-attribute >}}
- {{< cmd-options/obiuniq/chunk-count >}}
- {{< cmd-options/in-memory >}}
- {{< cmd-options/obiuniq/merge >}}
- {{< cmd-options/obiuniq/na-value >}}
- {{< cmd-options/obiuniq/no-singleton >}}
- {{< cmd-options/paired-with >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obiuniq --help
```
