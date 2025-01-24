---
archetype: "command"
title: "Obimultiplex"
date: 2025-01-23
command: "obimultiplex"
url: "/obitools/obimultiplex"
---

## `obimultiplex`

### Description 



### Synopsis

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

### Options

#### {{< obi obimultiplex >}} specific options:

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
obimultiplex --help
```
