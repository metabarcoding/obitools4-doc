---
archetype: "command"
title: "Obiscript: apply a LUA script"
date: 2024-12-21
command: "obiscript"
url: "/obitools/obiscript"
---

## `obiscript` apply a LUA script to each sequence in a file.

### Description 

Apply a LUA script to each sequence in a sequence file.

### Synopsis

```bash
obiscript [--allows-indels] [--approx-pattern <PATTERN>]...
          [--attribute|-a <KEY=VALUE>]... [--batch-size <int>]
          [--compress|-Z] [--debug] [--definition|-D <PATTERN>]... [--ecopcr]
          [--embl] [--fasta] [--fasta-output] [--fastq] [--fastq-output]
          [--force-one-cpu] [--genbank] [--has-attribute|-A <KEY>]...
          [--help|-h|-?] [--id-list <FILENAME>]
          [--identifier|-I <PATTERN>]... [--input-OBI-header]
          [--input-json-header] [--inverse-match|-v] [--json-output]
          [--max-count|-C <COUNT>] [--max-cpu <int>]
          [--max-length|-L <LENGTH>] [--min-count|-c <COUNT>]
          [--min-length|-l <LENGTH>] [--no-order] [--no-progressbar]
          [--only-forward] [--out|-o <FILENAME>] [--output-OBI-header|-O]
          [--output-json-header]
          [--paired-mode <forward|reverse|and|or|andnot|xor>]
          [--paired-with <FILENAME>] [--pattern-error <int>] [--pprof]
          [--pprof-goroutine <int>] [--pprof-mutex <int>]
          [--predicate|-p <EXPRESSION>]... [--save-discarded <FILENAME>]
          [--script|-S <string>] [--sequence|-s <PATTERN>]... [--skip-empty]
          [--solexa] [--taxdump|-t <string>] [--template] [--version]
          [<args>]
```

### Options

#### {{< obi obiscript >}} mandatory option

- {{< cmd-option name="script" short="S" param="STRING" >}}
  The script to execute.
  {{< /cmd-option >}}


#### Other {{< obi obiscript >}} specific option

- {{< cmd-option name="template" >}}
  Print on the standard output a script template.
  {{< /cmd-option >}}



{{< option-sets/selection >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
obiscript --help
```
