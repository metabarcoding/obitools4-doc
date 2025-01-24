---
archetype: "command"
title: "Obiannotate: Edit sequence annotations"
date: 2024-10-09
command: "obiannotate"
url: "/obitools/obiannotate"
weight: 10
---

## `obiannotate`: Edit sequence annotations

### Description 

Add or edit annotations associated with sequences in a sequence file.

### Synopsis

```bash
obiannotate [--add-lca-in <SLOT_NAME>] [--aho-corasick <string>]
            [--allows-indels] [--approx-pattern <PATTERN>]...
            [--attribute|-a <KEY=VALUE>]... [--batch-size <int>] [--clear]
            [--compress|-Z] [--cut <###:###>] [--debug]
            [--definition|-D <PATTERN>]... [--delete-tag <KEY>]... [--ecopcr]
            [--embl] [--fasta] [--fasta-output] [--fastq] [--fastq-output]
            [--force-one-cpu] [--genbank] [--has-attribute|-A <KEY>]...
            [--help|-h|-?] [--id-list <FILENAME>]
            [--identifier|-I <PATTERN>]... [--input-OBI-header]
            [--input-json-header] [--inverse-match|-v] [--json-output]
            [--keep|-k <KEY>]... [--lca-error <#.###>] [--length]
            [--max-count|-C <COUNT>] [--max-cpu <int>]
            [--max-length|-L <LENGTH>] [--min-count|-c <COUNT>]
            [--min-length|-l <LENGTH>] [--no-order] [--no-progressbar]
            [--only-forward] [--out|-o <FILENAME>] [--output-OBI-header|-O]
            [--output-json-header]
            [--paired-mode <forward|reverse|and|or|andnot|xor>]
            [--paired-with <FILENAME>] [--pattern <string>]
            [--pattern-error <int>] [--pattern-name <string>] [--pprof]
            [--pprof-goroutine <int>] [--pprof-mutex <int>]
            [--predicate|-p <EXPRESSION>]...
            [--rename-tag|-R <NEW_NAME=OLD_NAME>]... [--scientific-name]
            [--sequence|-s <PATTERN>]... [--set-identifier <EXPRESSION>]
            [--set-tag|-S <KEY=EXPRESSION>]... [--skip-empty] [--solexa]
            [--taxonomy|-t <string>] [--taxonomic-path] [--taxonomic-rank]
            [--version] [--with-taxon-at-rank <RANK_NAME>]... [<args>]
```

### Options

#### {{< obi obiannotate >}} specific options:

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
obiannotate --help
```
