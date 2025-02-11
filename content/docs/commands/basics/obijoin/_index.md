---
archetype: "command"
title: "obijoin"
date: 2025-02-10
command: "obijoin"
category: basics
url: "/obitools/obijoin"
weight: 90
---

# `obijoin`: join annotations from a file to a sequence file

## Description 

Perform a join operation to transfer annotations from a file to a sequence file.

## Synopsis

```bash
obijoin --join-with|-j <string> [--batch-size <int>] [--by|-b <string>]...
        [--compress|-Z] [--debug] [--ecopcr] [--embl] [--fasta]
        [--fasta-output] [--fastq] [--fastq-output] [--force-one-cpu]
        [--genbank] [--help|-h|-?] [--input-OBI-header] [--input-json-header]
        [--json-output] [--max-cpu <int>] [--no-order] [--no-progressbar]
        [--out|-o <FILENAME>] [--output-OBI-header|-O] [--output-json-header]
        [--paired-with <FILENAME>] [--pprof] [--pprof-goroutine <int>]
        [--pprof-mutex <int>] [--skip-empty] [--solexa]
        [--taxonomy|-t <string>] [--update-id|-i] [--update-quality|-q]
        [--update-sequence|-s] [--version] [<args>]
```

## Options

#### Required options

- {{< cmd-options/obijoin/join-with >}}

#### {{< obi obijoin >}} specific options

- {{< cmd-options/obijoin/by >}}
- {{< cmd-options/paired-with >}}
- {{< cmd-options/obijoin/update-id >}}
- {{< cmd-options/obijoin/update-quality >}}
- {{< cmd-options/obijoin/update-sequence >}}

#### Taxonomic options

- {{< cmd-options/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obijoin --help
```
