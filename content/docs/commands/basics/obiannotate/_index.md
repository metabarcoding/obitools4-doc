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

`obiannotate` is a tool for editing the sequence records of a dataset. It allows you to add, delete or modify annotations of sequence records, as well as edit the identifier, definition or sequence itself.

There are two particularly important groups of options in {{< obi obiannotate >}}. The first group is shared with {{< obi obigrep >}} and enables the selection of sequences. The second group specifies the changes to be made to the sequence records. In {{< obi obigrep >}}, the selection options determine which sequences the program will retain in its output. In contrast, every sequence in the input dataset is included in the result produced by {{< obi obiannotate >}}; however, only the sequences selected by the selection options are modified according to the editing options. Non-selected sequences are transferred to the result without modification.

### The selection options

### The edition options

#### Edition of the annotations

{{% obitools4 %}} store annotations attached to each sequence using a *tag*/*value* mechanism. The annotation of a sequence if a set of *tags* each of them being associated to a value. Therefor, annotating a sequence is changing this set of *tags* by adding new tags, deleting some others or changing the value associated to a tag.

##### Adding annotations

To add a new *tag*/*value* pair to a sequence {{< obi obiannotate >}} propose the generic option `--set-tag`
Considering the following file:

{{< code "empty.fasta" fasta true >}}

To add a `foo` tag to each sequence associated to the numeric value `3` the command is:

```bash
obiannotate --set-tag foo=3 empty.fasta
```
```
>seqA1 {"foo":3}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"foo":3}
tagctagctagctagctagctagctagcta
>seqA2 {"foo":3}
gtagctagctagctagctagctagctaga
>seqC1 {"foo":3}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"foo":3}
cgatggctccatgctagtgctagtcgatga
```

The argument of the `--set-tag` option `foo=3` can be decomposed in two parts separated by the equal sign.
The left part `foo` is the name of the target tag, the right part is the value to assign to the tag.

The left part must be a string when the right part is actually an [{{% obitools4 %}} expression language]({{< ref "/docs/programming/expression" >}}). Here the expression is simple `3`, which is evaluated to the *3* integer value.

To assign as string value to a tag, the rigth part of the option argument must be a valid [{{% obitools4 %}} expression language]({{< ref "/docs/programming/expression" >}}) corresponding to a string: `"bar"` with double quotes flanking the text having to be assigned. But to prevent the Bash UNIX shell to interpret itself the option parameter `foo="bar"`, it has to be protected itself by single quote.

```bash
obiannotate --set-tag 'foo="bar"' empty.fasta
```
```
>seqA1 {"foo":"bar"}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"foo":"bar"}
tagctagctagctagctagctagctagcta
>seqA2 {"foo":"bar"}
gtagctagctagctagctagctagctaga
>seqC1 {"foo":"bar"}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"foo":"bar"}
cgatggctccatgctagtgctagtcgatga
```

As the right part is an expression, it can be more complex and realize some basic computations. In the next example the *foo* tag is valuated with the sequence identifier prefixed by `"bar-"`. 

```bash
obiannotate --set-tag 'foo="bar-" + sequence.Id()' empty.fasta
```
```
>seqA1 {"foo":"bar-seqA1"}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"foo":"bar-seqB1"}
tagctagctagctagctagctagctagcta
>seqA2 {"foo":"bar-seqA2"}
gtagctagctagctagctagctagctaga
>seqC1 {"foo":"bar-seqC1"}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"foo":"bar-seqB2"}
cgatggctccatgctagtgctagtcgatga
```

The complete description of the {{% obitools4 %}} expression language is available [here]({{< ref "/docs/programming/expression" >}}).

All the previous examples are tagging each sequence in the same way, but you can also use {{< obi obiannotate >}} to modify the annotation of only a subset of the sequence. As explained in the introduction of this documentation, this is achieved by combining selection and edition options.

For instance, to add a *foo* tag only to the single sequence having the id `seqA2`, is achieved by combining the selection option `-I seqA2` and the edition option  `--set-tag 'foo="bar"'`

```bash
obiannotate -I seqA2 --set-tag 'foo="bar"' empty.fasta
```
```
>seqA1 
cgatgctgcatgctagtgctagtcgat
>seqB1 
tagctagctagctagctagctagctagcta
>seqA2 {"foo":"bar"}
gtagctagctagctagctagctagctaga
>seqC1 
cgatgctccatgctagtgctagtcgatga
>seqB2 
cgatggctccatgctagtgctagtcgatga
```

Used with {{< obi obigrep >}} the `-I seqA2` would have selected only the modified sequence.

```bash
obigrep -I seqA2  empty.fasta
```
```
>seqA2 
gtagctagctagctagctagctagctaga
```

The selection options being shared between {{< obi obiannotate >}} and {{< obi obigrep >}}, good method to check which sequences will be modified by {{< obi obiannotate >}} is to check the selection options at first with {{< obi obigrep >}}. Only the sequences present in the {{< obi obigrep >}} output will be edited by {{< obi obiannotate >}}.

```bash
obigrep -l 30 empty.fasta
```
```
>seqB1 
tagctagctagctagctagctagctagcta
>seqB2 
cgatggctccatgctagtgctagtcgatga
```

```bash
obiannotate -l 30 \
            --set-tag 'foo="bar-" + sequence.Id()' \
            empty.fasta 
```
```
>seqA1 
cgatgctgcatgctagtgctagtcgat
>seqB1 {"foo":"bar-seqB1"}
tagctagctagctagctagctagctagcta
>seqA2 
gtagctagctagctagctagctagctaga
>seqC1 
cgatgctccatgctagtgctagtcgatga
>seqB2 {"foo":"bar-seqB2"}
cgatggctccatgctagtgctagtcgatga
```

--rename-tag

--number 

###### Adding sequence related annotations

--length  
--aho-corasick <string> 
--pattern <PATTERN>
  --pattern-name
  --pattern-error
  --allows-indels

###### Edit taxonomy related annotations

--scientific-name

--with-taxon-at-rank <RANK_NAME> 

--taxonomic-rank 

--taxonomic-path   


--raw-taxid

--add-lca-in <SLOT_NAME> 
  --lca-error <#.###>

##### Deleting annotations

There are three options that allow for deleting annotations associated with a sequence.
The easiest one is `--clear`. It removes every annotation associated to a sequence.

Considering the fasta sequence file

{{< code "five_tags.fasta" fasta true >}}

The next command removes all the annotations

```bash
obiannotate --clear five_tags.fasta
```
```
>seqA1 
cgatgctgcatgctagtgctagtcgat
>seqB1 
tagctagctagctagctagctagctagcta
>seqA2 
gtagctagctagctagctagctagctaga
>seqC1 
cgatgctccatgctagtgctagtcgatga
>seqB2 
cgatggctccatgctagtgctagtcgatga
```

If you combine a selection option, here `-C 10` which selects all the sequences occurring at most ten times, and the `--clear` option, you will delete annotations only on selected sequences. For other sequences the annotations are kept.

```bash
obiannotate -C 10 --clear five_tags.fasta
```
```
>seqA1 
cgatgctgcatgctagtgctagtcgat
>seqB1 
tagctagctagctagctagctagctagcta
>seqA2 
gtagctagctagctagctagctagctaga
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"count":25,"tata":"bar"}
cgatggctccatgctagtgctagtcgatga
```

It is possible to delete a given tag based on its name using the `--delete-tag` option. In the following example the **taxid** tag is deleted. As the **seqB2** sequence does not exhibe a **taxid** tag, it is not affected.

```bash
obiannotate --delete-tag taxid five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"tata":"bar","toto":"tata"}
tagctagctagctagctagctagctagcta
>seqA2 {"count":5,"tata":"foo","toto":"tutu"}
gtagctagctagctagctagctagctaga
>seqC1 {"count":15,"tata":"foo","toto":"foo"}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"count":25,"tata":"bar"}
cgatggctccatgctagtgctagtcgatga
```

Several  `--delete-tag`  options can be inserted in a single {{< obi obiannotate >}} command.

```bash
obiannotate --delete-tag taxid \
            --delete-tag count \
            five_tags.fasta
```
```
>seqA1 {"tata":"bar","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"tata":"bar","toto":"tata"}
tagctagctagctagctagctagctagcta
>seqA2 {"tata":"foo","toto":"tutu"}
gtagctagctagctagctagctagctaga
>seqC1 {"tata":"foo","toto":"foo"}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"tata":"bar"}
cgatggctccatgctagtgctagtcgatga
```

The last way to delete annotations is indirect. It is based on the `--keep` option, indicating the annotation to be kept. Consequently, all the other tags, the not kept, are deleted

```bash
obiannotate --keep taxid five_tags.fasta
```
```
>seqA1 {"taxid":"taxon:9606 [Homo sapiens]@species"}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies"}
tagctagctagctagctagctagctagcta
>seqA2 {"taxid":"taxon:9605 [Homo]@genus"}
gtagctagctagctagctagctagctaga
>seqC1 {"taxid":"taxon:9604 [Hominidae]@family"}
cgatgctccatgctagtgctagtcgatga
>seqB2 
cgatggctccatgctagtgctagtcgatga
```

Similarly to `--delete-tag` several `--keep` options can be provided to keep several annotations.

```bash
obiannotate --keep taxid \
            --keep count \
            five_tags.fasta
```
```
>seqA1 {"count":1,"taxid":"taxon:9606 [Homo sapiens]@species"}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies"}
tagctagctagctagctagctagctagcta
>seqA2 {"count":5,"taxid":"taxon:9605 [Homo]@genus"}
gtagctagctagctagctagctagctaga
>seqC1 {"count":15,"taxid":"taxon:9604 [Hominidae]@family"}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"count":25}
cgatggctccatgctagtgctagtcgatga
```

##### Changing annotation values


#### Edition of the identifier

--set-identifier
#### Edition of the definition

#### Edition of the sequence

--cut <###:###>    
--sequence

## Synopsis

```bash
obiannotate [--add-lca-in <SLOT_NAME>] [--aho-corasick <string>]
            [--allows-indels] [--approx-pattern <PATTERN>]...
            [--attribute|-a <KEY=VALUE>]... [--batch-size <int>] [--clear]
            [--compress|-Z] [--csv] [--cut <###:###>] [--debug]
            [--definition|-D <PATTERN>]... [--delete-tag <KEY>]... [--ecopcr]
            [--embl] [--fail-on-taxonomy] [--fasta] [--fasta-output]
            [--fastq] [--fastq-output] [--force-one-cpu] [--genbank]
            [--has-attribute|-A <KEY>]... [--help|-h|-?]
            [--id-list <FILENAME>] [--identifier|-I <PATTERN>]...
            [--ignore-taxon|-i <TAXID>]... [--input-OBI-header]
            [--input-json-header] [--inverse-match|-v] [--json-output]
            [--keep|-k <KEY>]... [--lca-error <#.###>] [--length]
            [--max-count|-C <COUNT>] [--max-cpu <int>]
            [--max-length|-L <LENGTH>] [--min-count|-c <COUNT>]
            [--min-length|-l <LENGTH>] [--no-order] [--no-progressbar]
            [--number] [--only-forward] [--out|-o <FILENAME>]
            [--output-OBI-header|-O] [--output-json-header]
            [--paired-mode <forward|reverse|and|or|andnot|xor>]
            [--pattern <string>] [--pattern-error <int>]
            [--pattern-name <string>] [--pprof] [--pprof-goroutine <int>]
            [--pprof-mutex <int>] [--predicate|-p <EXPRESSION>]...
            [--raw-taxid] [--rename-tag|-R <NEW_NAME=OLD_NAME>]...
            [--require-rank <RANK_NAME>]...
            [--restrict-to-taxon|-r <TAXID>]... [--scientific-name]
            [--sequence|-s <PATTERN>]... [--set-identifier <EXPRESSION>]
            [--set-tag|-S <KEY=EXPRESSION>]... [--silent-warning]
            [--skip-empty] [--solexa] [--taxonomic-path] [--taxonomic-rank]
            [--taxonomy|-t <string>] [--update-taxid] [--valid-taxid]
            [--version] [--with-leaves] [--with-taxon-at-rank <RANK_NAME>]...
            [<args>]
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
  Keeps only attribute named `KEY`. Several -k options can be combined.
  {{< /cmd-option >}}
- {{< cmd-option name="rename-tag" param="NEW_NAME=OLD_NAME" short="R">}}
  Changes attribute name `OLD_NAME` to `NEW_NAME`. When attribute named `OLD_NAME` is missing, the sequence record is skipped and the next one is examined.
  {{< /cmd-option >}}
- {{< cmd-option name="set-tag" param="KEY=EXPRESSION" short="S">}}
  Creates a new attribute named with a key `KEY` set with a value computed from `EXPRESSION`.
  {{< /cmd-option >}}

##### Sequence-related annotation

- {{< cmd-option name="aho-corasick" param="string">}}
  Adds an aho-corasick attribute with the count of matches of the provided patterns.
  {{< /cmd-option >}}
- {{< cmd-option name="length">}}
  Adds attribute with seq_length as a key and sequence length as a value.
  {{< /cmd-option >}}
- {{< cmd-option name="pattern" param="string">}}
  Adds a pattern attribute containing the pattern, a pattern_match attribute indicating the matched sequence, and a pattern_error slot indicating the number difference between the pattern and the match to the sequence.
  {{< /cmd-option >}}
- {{< cmd-options/pattern-name >}}

##### Sequence modification

- {{< cmd-option name="cut" param="###:###">}}
  A pattern describing how to cut the sequence.
  {{< /cmd-option >}}


##### Taxonomy annotation

- {{< cmd-option name="add-lca-in" param="KEY">}}
  From the taxonomic annotation of the sequence (taxid attribute or merged_taxid attribute), a new attribute named `KEY` is added with the taxid of the lowest common ancestor corresponding to the current annotation.
  {{< /cmd-option >}}
- {{< cmd-option name="lca-error" param="#.###">}}
  Error rate tolerated on the taxonomical description during the lowest common ancestor. At most a fraction of lca-error of the taxonomic information can disagree with the estimated LCA. (default: 0.000000)
  {{< /cmd-option >}}
- {{< cmd-option name="scientific-name">}}
  Annotates the sequence with its scientific name.
  {{< /cmd-option >}}

#### Taxonomy options

{{< option-sets/taxonomy >}}

- {{< cmd-option name="taxonomic-rank">}}
  Annotates the sequence with its taxonomic rank.
  {{< /cmd-option >}}
- {{< cmd-option name="taxonomic-path">}}
  Annotates the sequence with its taxonomic path.
  {{< /cmd-option >}}
- {{< cmd-option name="with-taxon-at-rank">}}
  Adds taxonomic annotation at taxonomic rank `RANK_NAME`.
  {{< /cmd-option >}}
  
{{< option-sets/selection >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obiannotate --help
```
