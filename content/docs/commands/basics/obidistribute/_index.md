---
archetype: "command"
title: "obidistribute"
date: 2025-01-23
command: "obidistribute"
category: basics
url: "/obitools/obidistribute"
weight: 70
---

# `obidistribute`: split a sequence file into multiple files

## Description 

Distribute a sequence file accross multiple output files.

## Synopsis

```bash
obidistribute --pattern|-p <string> [--append|-A] [--batch-size <int>]
              [--batches|-n <int>] [--classifier|-c <string>] [--compress|-Z]
              [--csv] [--debug] [--directory|-d <string>] [--ecopcr] [--embl]
              [--fasta] [--fasta-output] [--fastq] [--fastq-output]
              [--force-one-cpu] [--genbank] [--hash|-H <int>] [--help|-h|-?]
              [--input-OBI-header] [--input-json-header] [--json-output]
              [--max-cpu <int>] [--na-value <string>] [--no-order]
              [--no-progressbar] [--out|-o <FILENAME>]
              [--output-OBI-header|-O] [--output-json-header] [--pprof]
              [--pprof-goroutine <int>] [--pprof-mutex <int>]
              [--silent-warning] [--skip-empty] [--solexa] [--u-to-t]
              [--version] [<args>]
```

## Options

#### Required options

- {{< cmd-options/obidistribute/pattern >}}

#### {{< obi obidistribute >}} specific options

- {{< cmd-options/obidistribute/append >}}
- {{< cmd-options/obidistribute/batches >}}
- {{< cmd-options/obidistribute/classifier >}}
- {{< cmd-options/obidistribute/directory >}}
- {{< cmd-options/obidistribute/hash >}}
- {{< cmd-options/obidistribute/na-value >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obidistribute --help
```
