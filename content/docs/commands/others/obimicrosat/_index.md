---
archetype: "command"
title: "Obimicrosat: extract microsatellite sequences"
date: 2025-01-23
command: "obimicrosat"
url: "/obitools/obimicrosat"
---

## `obimicrosat`: extract microsatellite sequences

### Description 

Extract sequence entries containing a microsatellite from a sequence file.

### Synopsis

```bash
obimicrosat [--batch-size <int>] [--compress|-Z] [--debug] [--ecopcr]
            [--embl] [--fasta] [--fasta-output] [--fastq] [--fastq-output]
            [--force-one-cpu] [--genbank] [--help|-h|-?] [--input-OBI-header]
            [--input-json-header] [--json-output] [--max-cpu <int>]
            [--max-unit-length|-M <int>] [--min-flank-length|-f <int>]
            [--min-length|-l <int>] [--min-unit-count <int>]
            [--min-unit-length|-m <int>] [--no-order] [--no-progressbar]
            [--not-reoriented|-n] [--out|-o <FILENAME>]
            [--output-OBI-header|-O] [--output-json-header]
            [--paired-with <FILENAME>] [--pprof] [--pprof-goroutine <int>]
            [--pprof-mutex <int>] [--skip-empty] [--solexa]
            [--taxonomy|-t <string>] [--version] [<args>]
```

### Options

#### {{< obi obimicrosat >}} specific options:

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
obimicrosat --help
```
