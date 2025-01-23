---
archetype: "command"
title: "Obitagpcr"
date: 2025-01-23
command: "obitagpcr"
url: "/obitools/obitagpcr"
---

## `obitagpcr`

### Description 



### Synopsis

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

### Options

#### {{< obi obitagpcr >}} specific options:

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
obitagpcr --help
```
