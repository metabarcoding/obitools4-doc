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
obiannotate [--add-lca-in <ATTRIBUTE>] [--aho-corasick <string>]
                 [--allows-indels] [--approx-pattern <PATTERN>]...
                 [--attribute|-a <KEY=VALUE>]... [--batch-size <int>] [--clear]
                 [--compressed|-Z] [--csv] [--cut <###:###>] [--debug]
                 [--definition|-D <PATTERN>]... [--delete-tag <KEY>]...
                 [--ecopcr] [--embl] [--fail-on-taxonomy] [--fasta]
                 [--fasta-output] [--fastq] [--fastq-output] [--force-one-cpu]
                 [--genbank] [--has-attribute|-A <KEY>]... [--help|-h|-?]
                 [--id-list <FILENAME>] [--identifier|-I <PATTERN>]...
                 [--ignore-taxon|-i <TAXID>]... [--input-OBI-header]
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
                 [--predicate|-p <EXPRESSION>]... [--raw-taxid]
                 [--rename-tag|-R <NEW_NAME=OLD_NAME>]...
                 [--require-rank <RANK_NAME>]...
                 [--restrict-to-taxon|-r <TAXID>]... [--scientific-name]
                 [--sequence|-s <PATTERN>]... [--set-identifier <EXPRESSION>]
                 [--set-tag|-S <KEY=EXPRESSION>]... [--skip-empty] [--solexa]
                 [--taxonomic-path] [--taxonomic-rank] [--taxonomy|-t <string>]
                 [--update-taxid] [--valid-taxid] [--version]
                 [--with-taxon-at-rank <RANK_NAME>]... [<args>]
```

## Options

#### {{< obi obiannotate >}} specific options

##### Identifier modification

- {{< cmd-option name="set-identifier" param="EXPRESSION" >}}
  An expression used to assigned the new id of the sequence.
  {{< /cmd-option >}}

##### Attribute modification

- {{< cmd-option name="clear" >}}
  Clears all attributes associated to the sequence records.
  {{< /cmd-option >}}
- {{< cmd-option name="delete-tag" param="KEY">}}
  Deletes attribute named `KEY`. When this attribute is missing, the sequence record is skipped and the next one is examined.
  {{< /cmd-option >}}
- {{< cmd-option name="keep" param="KEY" short="k">}}
  Keeps only attribute with key `KEY`. Several -k options can be combined.
  {{< /cmd-option >}}
- {{< cmd-option name="rename-tag" param="NEW_NAME=OLD_NAME" short="R">}}
  Changes attribute name `OLD_NAME` to `NEW_NAME`. When attribute named `OLD_NAME` is missing, the sequence record is skipped and the next one is examined.
  {{< /cmd-option >}}
- {{< cmd-option name="set-tag" param="KEY=EXPRESSION" short="S">}}
  Creates a new attribute named with a key `KEY` set with a value computed from `EXPRESSION`.
  {{< /cmd-option >}}

##### Sequence-related annotation

- {{< cmd-options/obiannotate/aho-corasick >}}
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

{{< option-sets/taxonomy >}}

- {{< cmd-options/taxonomy/taxonomic-rank >}}
- {{< cmd-options/taxonomy/taxonomic-path >}}
- {{< cmd-options/taxonomy/with-taxon-at-rank >}}

{{< option-sets/selection >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obiannotate --help
```
