---
archetype: "command"
title: "obidemerge"
date: 2025-02-10
command: "obidemerge"
category: basics
url: "/obitools/obidemerge"
weight: 60
---

# `obidemerge`

## Description 



## Synopsis

```bash
obidemerge [--batch-size <int>] [--compress|-Z] [--debug]
           [--demerge|-d <string>] [--ecopcr] [--embl] [--fasta]
           [--fasta-output] [--fastq] [--fastq-output] [--force-one-cpu]
           [--genbank] [--help|-h|-?] [--input-OBI-header]
           [--input-json-header] [--json-output] [--max-cpu <int>]
           [--no-order] [--no-progressbar] [--out|-o <FILENAME>]
           [--output-OBI-header|-O] [--output-json-header]
           [--paired-with <FILENAME>] [--pprof] [--pprof-goroutine <int>]
           [--pprof-mutex <int>] [--skip-empty] [--solexa]
           [--taxonomy|-t <string>] [--version] [<args>]
```

## Options

#### {{< obi obidemerge >}} specific options

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obidemerge --help
```
