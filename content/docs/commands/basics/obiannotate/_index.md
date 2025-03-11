---
archetype: "command"
title: "obiannotate"
date: 2025-02-10
command: "obiannotate"
category: basics
url: "/obitools/obiannotate"
weight: 10
---

# `obiannotate`: edit sequence annotations

## Description 

Add or edit annotations associated with sequences in a sequence file.

## Synopsis

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

## Options

#### {{< obi obiannotate >}} specific options

##### Identifier modification

- {{< cmd-options/set-identifier >}}

##### Tag modification

- {{< cmd-options/obiannotate/clear >}}
- {{< cmd-options/delete-tag >}}
- {{< cmd-options/keep >}}
- {{< cmd-options/rename-tag >}}
- {{< cmd-options/set-tag >}}

##### Sequence-related annotation

- {{< cmd-options/length >}}
- {{< cmd-options/pattern >}}
- {{< cmd-options/pattern-error >}}
- {{< cmd-options/pattern-name >}}

##### Sequence modification

- {{< cmd-options/obiannotate/cut >}}

##### Taxonomy annotation

- {{< cmd-options/obiannotate/add-lca-in >}}
- {{< cmd-options/obiannotate/lca-error >}}
- {{< cmd-options/scientific-name >}}
- {{< cmd-options/scientific-name >}}

#### Taxonomy options

- {{< cmd-options/taxonomy/taxonomy >}}
- {{< cmd-options/taxonomy/taxonomic-rank >}}
- {{< cmd-options/taxonomy/taxonomic-path >}}
- {{< cmd-options/taxonomy/with-taxon-at-rank >}}


{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obiannotate --help
```
