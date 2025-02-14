---
archetype: "command"
title: "obimultiplex"
date: 2025-02-10
command: "obimultiplex"
category: demultiplexing
url: "/obitools/obimultiplex"
---

# `obimultiplex`: demultiplex the sequences

## Description 



## Synopsis

```bash
obimultiplex [--allowed-mismatches|-e <int>] [--batch-size <int>]
             [--compress|-Z] [--debug] [--ecopcr] [--embl] [--fasta]
             [--fasta-output] [--fastq] [--fastq-output] [--force-one-cpu]
             [--genbank] [--help|-h|-?] [--input-OBI-header]
             [--input-json-header] [--json-output] [--keep-errors]
             [--max-cpu <int>] [--no-order] [--no-progressbar]
             [--out|-o <FILENAME>] [--output-OBI-header|-O]
             [--output-json-header] [--paired-with <FILENAME>] [--pprof]
             [--pprof-goroutine <int>] [--pprof-mutex <int>] [--skip-empty]
             [--solexa] [--tag-list|-s <string>] [--taxonomy|-t <string>]
             [--template] [--unidentified|-u <string>] [--version]
             [--with-indels] [<args>]
```

## Options

#### {{< obi obimultiplex >}} specific options

- {{< cmd-options/demultiplexing/allowed-mismatches >}}
- {{< cmd-options/demultiplexing/keep-errors >}}
- {{< cmd-options/paired-with >}}
- {{< cmd-options/demultiplexing/tag-list >}}
- {{< cmd-options/demultiplexing/template >}}
- {{< cmd-options/demultiplexing/unidentified >}}
- {{< cmd-options/demultiplexing/with-indels >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obimultiplex --help
```
