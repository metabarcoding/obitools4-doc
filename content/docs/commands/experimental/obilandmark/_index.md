---
archetype: "command"
title: "obilandmark"
date: 2025-02-10
command: "obilandmark"
category: experimental
url: "/obitools/obilandmark"
---

# `obilandmark`

## Description 



## Synopsis

```bash
obilandmark [--batch-size <int>] [--center|-n <int>] [--compress|-Z]
            [--debug] [--ecopcr] [--embl] [--fasta] [--fasta-output]
            [--fastq] [--fastq-output] [--force-one-cpu] [--genbank]
            [--help|-h|-?] [--input-OBI-header] [--input-json-header]
            [--json-output] [--max-cpu <int>] [--no-order] [--no-progressbar]
            [--out|-o <FILENAME>] [--output-OBI-header|-O]
            [--output-json-header] [--pprof] [--pprof-goroutine <int>]
            [--pprof-mutex <int>] [--skip-empty] [--solexa]
            [--taxonomy|-t <string>] [--version] [<args>]
```

## Options

#### {{< obi obilandmark >}} specific options

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obilandmark --help
```
