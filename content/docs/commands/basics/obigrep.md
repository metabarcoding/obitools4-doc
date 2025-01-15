---
archetype: "command"
title: "Obigrep: Filter a sequence file"
date: 2025-01-15
command: "obigrep"
url: "/obitools/obigrep"
---

## `obigrep`: Filter a sequence file

### Description 

Filter a sequence file to keep only the entries you want based on multiple criteria.

### Synopsis

```bash
obigrep [--allows-indels] [--approx-pattern <PATTERN>]...
        [--attribute|-a <KEY=VALUE>]... [--batch-size <int>] [--compress|-Z]
        [--debug] [--definition|-D <PATTERN>]... [--ecopcr] [--embl]
        [--fasta] [--fasta-output] [--fastq] [--fastq-output]
        [--force-one-cpu] [--genbank] [--has-attribute|-A <KEY>]...
        [--help|-h|-?] [--id-list <FILENAME>] [--identifier|-I <PATTERN>]...
        [--input-OBI-header] [--input-json-header] [--inverse-match|-v]
        [--json-output] [--max-count|-C <COUNT>] [--max-cpu <int>]
        [--max-length|-L <LENGTH>] [--min-count|-c <COUNT>]
        [--min-length|-l <LENGTH>] [--no-order] [--no-progressbar]
        [--only-forward] [--out|-o <FILENAME>] [--output-OBI-header|-O]
        [--output-json-header]
        [--paired-mode <forward|reverse|and|or|andnot|xor>]
        [--paired-with <FILENAME>] [--pattern-error <int>] [--pprof]
        [--pprof-goroutine <int>] [--pprof-mutex <int>]
        [--predicate|-p <EXPRESSION>]... [--save-discarded <FILENAME>]
        [--sequence|-s <PATTERN>]... [--skip-empty] [--solexa]
        [--taxdump|-t <string>] [--version] [<args>]
```

### Options

#### {{< obi obigrep >}} specific options:

- {{< cmd-option name="identifier" short="I" param="REGEX" >}}
  Regular expression pattern to be tested against the sequence identifier. The pattern is case insensitive.
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
obigrep --help
```
