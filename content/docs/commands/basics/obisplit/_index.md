---
archetype: "command"
title: "Obisplit"
date: 2025-01-23
command: "obisplit"
url: "/obitools/obisplit"
weight: 110
---

## `obisplit`

### Description 



### Synopsis

```bash
obisplit [--allows-indels] [--batch-size <int>] [--compress|-Z]
         [--config|-C <string>] [--debug] [--ecopcr] [--embl] [--fasta]
         [--fasta-output] [--fastq] [--fastq-output] [--force-one-cpu]
         [--genbank] [--help|-h|-?] [--input-OBI-header]
         [--input-json-header] [--json-output] [--max-cpu <int>] [--no-order]
         [--no-progressbar] [--out|-o <FILENAME>] [--output-OBI-header|-O]
         [--output-json-header] [--paired-with <FILENAME>]
         [--pattern-error <int>] [--pprof] [--pprof-goroutine <int>]
         [--pprof-mutex <int>] [--skip-empty] [--solexa]
         [--taxdump|-t <string>] [--template] [--version] [<args>]
```

### Options

#### {{< obi obisplit >}} specific options:

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
obisplit --help
```
