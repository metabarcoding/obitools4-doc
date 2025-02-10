---
archetype: "command"
title: "obicsv"
date: 2025-02-10
command: "obicsv"
category: basics
url: "/obitools/obicsv"
weight: 50
---

# `obicsv`

### Description 

Convert a sequence file to a CSV file.

### Synopsis

```bash
obicsv [--auto] [--batch-size <int>] [--compress|-Z] [--count] [--debug]
       [--definition|-d] [--ecopcr] [--embl] [--fasta] [--fastq]
       [--force-one-cpu] [--genbank] [--help|-h|-?] [--ids|-i]
       [--input-OBI-header] [--input-json-header] [--keep|-k <KEY>]...
       [--max-cpu <int>] [--na-value <NAVALUE>] [--no-order]
       [--no-progressbar] [--obipairing] [--out|-o <FILENAME>] [--pprof]
       [--pprof-goroutine <int>] [--pprof-mutex <int>] [--quality|-q]
       [--sequence|-s] [--skip-empty] [--solexa] [--taxonomy|-t <string>]
       [--taxon] [--version] [<args>]
```

### Options

#### {{< obi obicsv >}} specific options:

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
obicsv --help
```
