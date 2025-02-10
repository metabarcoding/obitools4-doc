---
archetype: "command"
title: "obicleandb"
date: 2025-02-10
command: "obicleandb"
category: experimental
url: "/obitools/obicleandb"
---

# `obicleandb`: clean a sequence reference database

## Description 

Clean a sequence reference database for trivial wrong taxonomic annotations.

## Synopsis

```bash
obicleandb [--batch-size <int>] [--compress|-Z] [--debug] [--ecopcr] [--embl]
           [--fasta] [--fasta-output] [--fastq] [--fastq-output]
           [--force-one-cpu] [--genbank] [--help|-h|-?]
           [--ignore-taxon|-i <TAXID>]... [--input-OBI-header]
           [--input-json-header] [--json-output] [--max-cpu <int>]
           [--no-order] [--no-progressbar] [--out|-o <FILENAME>]
           [--output-OBI-header|-O] [--output-json-header] [--pprof]
           [--pprof-goroutine <int>] [--pprof-mutex <int>]
           [--require-rank <RANK_NAME>]...
           [--restrict-to-taxon|-r <TAXID>]... [--skip-empty] [--solexa]
           [--taxonomy|-t <string>] [--update-taxids] [--version] [<args>]
```

## Options

#### {{< obi obicleandb >}} specific options

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obicleandb --help
```
