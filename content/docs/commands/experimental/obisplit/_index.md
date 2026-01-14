---
archetype: "command"
title: "obisplit"
date: 2025-01-23
command: "obisplit"
category: basics
url: "/obitools/obisplit"
weight: 110
---

# `obisplit`:

## Description 



## Synopsis

```bash
obisplit [--allows-indels] [--batch-size <int>] [--compress|-Z]
         [--config|-C <string>] [--csv] [--debug] [--ecopcr] [--embl]
         [--fail-on-taxonomy] [--fasta] [--fasta-output] [--fastq]
         [--fastq-output] [--force-one-cpu] [--genbank] [--help|-h|-?]
         [--input-OBI-header] [--input-json-header] [--json-output]
         [--max-cpu <int>] [--no-order] [--no-progressbar]
         [--out|-o <FILENAME>] [--output-OBI-header|-O]
         [--output-json-header] [--pattern-error <int>] [--pprof]
         [--pprof-goroutine <int>] [--pprof-mutex <int>] [--raw-taxid]
         [--silent-warning] [--skip-empty] [--solexa]
         [--taxonomy|-t <string>] [--template] [--u-to-t] [--update-taxid]
         [--version] [--with-leaves] [<args>]
```

## Options

#### {{< obi obisplit >}} specific options

- {{< cmd-options/obisplit/allows-indels >}}
- {{< cmd-options/obisplit/config >}}
- {{< cmd-options/obisplit/pattern-error >}}
- {{< cmd-options/obisplit/template >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obisplit --help
```
