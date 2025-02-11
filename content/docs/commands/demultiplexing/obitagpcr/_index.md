---
archetype: "command"
title: "obitagpcr"
date: 2025-02-10
command: "obitagpcr"
category: demultiplexing
url: "/obitools/obitagpcr"
---

# `obitagpcr`:

## Description 



## Synopsis

```bash
obitagpcr --forward-reads|-F <FILENAME_F> --reverse-reads|-R <FILENAME_R>
          [--allowed-mismatches|-e <int>] [--batch-size <int>]
          [--compress|-Z] [--debug] [--delta|-D <int>] [--ecopcr] [--embl]
          [--exact-mode] [--fast-absolute] [--fasta] [--fasta-output]
          [--fastq] [--fastq-output] [--force-one-cpu]
          [--gap-penalty|-G <float64>] [--genbank] [--help|-h|-?]
          [--input-OBI-header] [--input-json-header] [--json-output]
          [--keep-errors] [--max-cpu <int>] [--min-identity|-X <float64>]
          [--min-overlap <int>] [--no-order] [--no-progressbar]
          [--out|-o <FILENAME>] [--output-OBI-header|-O]
          [--output-json-header] [--penalty-scale <float64>] [--pprof]
          [--pprof-goroutine <int>] [--pprof-mutex <int>] [--reorientate]
          [--skip-empty] [--solexa] [--tag-list|-t <string>] [--template]
          [--unidentified|-u <string>] [--version] [--with-indels]
          [--without-stat|-S] [<args>]
```

## Options

#### {{< obi obitagpcr >}} specific options

- {{< cmd-options/demultiplexing/forward-reads >}}
- {{< cmd-options/demultiplexing/reverse-reads >}}
- {{< cmd-options/demultiplexing/allowed-mismatches >}}
- {{< cmd-options/demultiplexing/delta >}}
- {{< cmd-options/demultiplexing/exact-mode >}}
- {{< cmd-options/demultiplexing/fast-absolute >}}
- {{< cmd-options/demultiplexing/gap-penalty >}}
- {{< cmd-options/demultiplexing/keep-errors >}}
- {{< cmd-options/demultiplexing/min-identity >}}
- {{< cmd-options/demultiplexing/min-overlap >}}
- {{< cmd-options/no-order >}}
- {{< cmd-options/demultiplexing/penalty-scale >}}
- {{< cmd-options/demultiplexing/reorientate >}}
- {{< cmd-options/demultiplexing/tag-list >}}
- {{< cmd-options/demultiplexing/template >}}
- {{< cmd-options/demultiplexing/unidentified >}}
- {{< cmd-options/demultiplexing/with-indels >}}
- {{< cmd-options/demultiplexing/without-stat >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obitagpcr --help
```
