---
archetype: "command"
title: "Obiconvert: Convert a sequence file"
date: 2025-01-08
command: "obiconvert"
url: "/obitools/obiconvert"
---

## `obiconvert`: Convert a sequence file

### Description 

Convert a sequence file to fasta, fastq, or json format.

### Synopsis

```bash
obiconvert [--batch-size <int>] [--compress|-Z] [--debug] [--ecopcr] [--embl]
           [--fasta] [--fasta-output] [--fastq] [--fastq-output]
           [--force-one-cpu] [--genbank] [--help|-h|-?] [--input-OBI-header]
           [--input-json-header] [--json-output] [--max-cpu <int>]
           [--no-order] [--no-progressbar] [--out|-o <FILENAME>]
           [--output-OBI-header|-O] [--output-json-header]
           [--paired-with <FILENAME>] [--pprof] [--pprof-goroutine <int>]
           [--pprof-mutex <int>] [--skip-empty] [--solexa]
           [--taxdump|-t <string>] [--version] [<args>]

```

### Options

#### {{< obi obiconvert >}} specific options:

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
obiconvert --help
```
