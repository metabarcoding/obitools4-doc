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

`obiannotate` is a tool for editing sequence records in a dataset. It enables you to add, delete or modify annotations, as well as edit identifiers, definitions and sequences.

There are two particularly important groups of options in {{< obi obiannotate >}}. The first group, which is shared with {{< obi obigrep >}}, is used to select sequences. The second group specifies the changes to be made to the selected sequence records. In {{< obi obigrep >}}, the selection options determine which sequences the program will retain in its output. By contrast, {{< obi obiannotate >}} includes every sequence occuring in the input dataset in the output file; however, only the sequences selected by the selection options are modified according to the editing options. Non-selected sequences are transferred to the result without modification.

### The selection options

They correspond to the selection options described in the {{% obi obigrep %}} documentation. 

### The edition options

#### Edition of the annotations

{{% obitools4 %}} store annotations attached to each sequence using a *tag*/*value* system. The annotation of a sequence if a set of *tags*, each of them being associated to a value. Therefore, annotating a sequence is changing this set of *tags* by adding new tags, deleting some others, or changing the value associated to a tag.

##### Adding annotations

To add a new *tag*/*value* pair to a sequence, {{< obi obiannotate >}} proposes the generic option `--set-tag`
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

The argument of the `--set-tag` option `foo=3` can be decomposed into two parts separated by an equal sign.
The left part, `foo`, is the name of the target tag, and the right part is the value to be assigned to the tag.

The left part must be a string. The right part is actually an [{{% obitools4 %}} expression language]({{< ref "/docs/programming/expression" >}}). Here the expression is a simple `3`, which is evaluated to the *3* integer value.

In order to assign a string value to a tag, the right-hand side of the option argument must correspond to a valid [{{% obitools4 %}} expression language]({{< ref "/docs/programming/expression" >}}) string. For example the text `bar` must be indicated as `"bar"`, with double quotation marks flanking the text to be assigned. However, to prevent the Bash UNIX shell from interpreting the quotation marks, the option value must be protected by a single quotation mark on each side: `'foo="bar"'`.
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

As the right part is an expression, it can be more complex and perform some basic computations. In the next example the *foo* tag is assigned a value based on the sequence identifier prefixed by `"bar-"`. 

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

As the selection options are shared between {{< obi obiannotate >}} and {{< obi obigrep >}}, a good method of checking which sequences will be modified by {{< obi obiannotate >}} is to first check the selection options with obigrep. Only sequences present in the {{< obi obigrep >}} output will be edited by {{< obi obiannotate >}}.

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

##### Renaming tags

Renaming tags can be useful when accounting for changes in a pipeline, i.e. adapting old datasets to new scripts. It can also be useful for saving annotations produced by an {{< obitools >}} command before rerunning it with different parameters. Consider the following {{% fasta %}} file:

{{% code "five_tags.fasta" fasta true %}}

If you want to keep the taxonomic annotations as a reference before running the {{< obi obitag >}} command to produce a new one, so that you can compare the new one to the old one later, you can rename the `taxid` tag to `ref_taxid` and then run the o{{< obi obitag >}}bitag command. This will set a new `taxid` tag.

```bash
obiannotate --rename-tag ref_taxid=taxid  five_tags.fasta
```
```
>seqA1 {"count":1,"ref_taxid":"taxon:9606 [Homo sapiens]@species","tata":"bar","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"ref_taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies","tata":"bar","toto":"tata"}
tagctagctagctagctagctagctagcta
>seqA2 {"count":5,"ref_taxid":"taxon:9605 [Homo]@genus","tata":"foo","toto":"tutu"}
gtagctagctagctagctagctagctaga
>seqC1 {"count":15,"ref_taxid":"taxon:9604 [Hominidae]@family","tata":"foo","toto":"foo"}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"count":25,"tata":"bar"}
cgatggctccatgctagtgctagtcgatga
```

##### Adding a serial number to each sequence

Adding a serial number to each sequence can be useful. This can be done using the  {{< obi obiannotate >}} command with the `--number` option. This option adds a new tag to each sequence with the name `seq_number` and an integer value that increments for each sequence.

```bash
obiannotate --number empty.fasta
```
```
>seqA1 {"seq_number":1}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"seq_number":2}
tagctagctagctagctagctagctagcta
>seqA2 {"seq_number":3}
gtagctagctagctagctagctagctaga
>seqC1 {"seq_number":4}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"seq_number":5}
cgatggctccatgctagtgctagtcgatga
```

###### Adding sequence related annotations

* Annotating sequences with their length
  
The sequence length can be added to the annotation using the `--length` option which adds the 
`seq_length`.

```bash
obiannotate --length empty.fasta
```
```
>seqA1 {"seq_length":27}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"seq_length":30}
tagctagctagctagctagctagctagcta
>seqA2 {"seq_length":29}
gtagctagctagctagctagctagctaga
>seqC1 {"seq_length":29}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"seq_length":30}
cgatggctccatgctagtgctagtcgatga
```

* Counting occurrences of a set of patterns 

The `--aho-corasick` option allow for counting the occurrences of a set of patterns stored in a text, one pattern per line. The patterns are strictly matched against both strands of the DNA sequence using the Aho-Corasick multiple pattern matching algorithm. The option requires as argument the name of the file containing these patterns.

{{% code "motifs.txt" txt true %}}

```bash
obiannotate --aho-corasick motifs.txt empty.fasta 
```
```
>seqA1 {"aho_corasick":2,"aho_corasick_Fwd":2,"aho_corasick_Rev":0}
cgatgctgcatgctagtgctagtcgat
>seqB1 
tagctagctagctagctagctagctagcta
>seqA2 
gtagctagctagctagctagctagctaga
>seqC1 {"aho_corasick":2,"aho_corasick_Fwd":1,"aho_corasick_Rev":1}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"aho_corasick":2,"aho_corasick_Fwd":1,"aho_corasick_Rev":1}
cgatggctccatgctagtgctagtcgatga
```

When used with the `--aho-corasick` option {{% obi obiannotate %}} adds the three following options:

  - `aho_corasick`: the total number of match on the sequence
  - `aho_corasick_Fwd`: the number of match on the forward strand
  - `aho_corasick_Rev`: the number of match on the reverse strand

* Matching a primer against sequences 

It is possible to identify sequences that match a primer using the same algorithm than the one used by {{% obi obipcr %}} or {{% obi obimultiplex %}}. Four options controle this feature:

- `--pattern <PATTERN>`: the primer sequence to be searched. The pattern is following the [DNA Pattern grammar]({{< ref "../../../patterns/dnagrep" >}}) allowing to use the IUPAC DNA codes and to indicates non mutable positions.
- `--pattern-error <INT>` : the maximum error allowed when matching the primer. Default is 0.

```bash
obiannotate --pattern tagctagctcgctagcta \
            --pattern-error 3 \
            empty.fasta
```
```
>seqA1 
cgatgctgcatgctagtgctagtcgat
>seqB1 {"pattern":"tagctagctcgctagcta","pattern_error":1,"pattern_location":"1..18","pattern_match":"tagctagctagctagcta"}
tagctagctagctagctagctagctagcta
>seqA2 {"pattern":"tagctagctcgctagcta","pattern_error":1,"pattern_location":"2..19","pattern_match":"tagctagctagctagcta"}
gtagctagctagctagctagctagctaga
>seqC1 
cgatgctccatgctagtgctagtcgatga
>seqB2 
cgatggctccatgctagtgctagtcgatga
```

- `--pattern-name <STRING>`
  
```bash
obiannotate --pattern tagctagctcgctagcta \
            --pattern-error 3 \
            --pattern-name primer1 \
            empty.fasta
```
```
>seqA1 
cgatgctgcatgctagtgctagtcgat
>seqB1 {"primer1_error":1,"primer1_location":"1..18","primer1_match":"tagctagctagctagcta","primer1_pattern":"tagctagctcgctagcta"}
tagctagctagctagctagctagctagcta
>seqA2 {"primer1_error":1,"primer1_location":"2..19","primer1_match":"tagctagctagctagcta","primer1_pattern":"tagctagctcgctagcta"}
gtagctagctagctagctagctagctaga
>seqC1 
cgatgctccatgctagtgctagtcgatga
>seqB2 
cgatggctccatgctagtgctagtcgatga
```

- `--allows-indels`: by default the program will not allow indels in patterns, but you can use this option to enable them. When enabled, an error can be a mismatch or an insertion/deletion.


###### Edit taxonomy related annotations

--scientific-name

--with-taxon-at-rank <RANK_NAME> 

--taxonomic-rank 

--taxonomic-path   


--raw-taxid

--add-lca-in <SLOT_NAME> 
  --lca-error <#.###>

##### Deleting annotations

There are three options for deleting annotations associated with a sequence. The easiest is the `--clear` option. This command removes all annotations associated with a sequence.

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

Combining the `-C 10` selection option, which selects all sequences that occur at most ten times, and the `--clear` option will delete annotations only on the selected sequences. The annotations on other sequences are kept.

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

Using the `--delete-tag` option, it is possible to delete a tag based on its name. In the following example, the **taxid** tag is deleted. The se**seqB2**qB2 sequence is not affected because it does not exhibit a **taxid** tag.

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

You can insert several `--delete-tag` options in a single {{< obi obiannotate >}} command.

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

The last method for deleting annotations is indirect. It is based on the `--keep` option, which indicates which annotation should be kept. Consequently, all the other tags that are not kept are deleted.

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

Similarly to the `--delete-tag` option, several `--keep` options can be provided to keep multiple annotations.

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

You can update the identifier of a sequence using the `--set-id` option. One useful application of this option is substituting the long id generated by the sequencer with a new, short id based on a number incremented from sequence to sequence, as with the id generated by the `--number` option. To do so, use two piped {{< obi obiannotate >}} commands. The first command adds the `seq_number` annotation to the sequences. Then, the second command updates the sequence id from the newly added `seq_number` tag.

```bash
obiannotate --number empty.fasta \
  | obiannotate --set-id 'sprintf("motus_%04d", annotations.seq_number)' 
```
```
>motus_0001 {"seq_number":1}
cgatgctgcatgctagtgctagtcgat
>motus_0002 {"seq_number":2}
tagctagctagctagctagctagctagcta
>motus_0003 {"seq_number":3}
gtagctagctagctagctagctagctaga
>motus_0004 {"seq_number":4}
cgatgctccatgctagtgctagtcgatga
>motus_0005 {"seq_number":5}
cgatggctccatgctagtgctagtcgatga
```


The `sprintf` function in the [{{% obitools4 %}} expression language]({{< ref "/docs/programming/expression" >}}) is used to format sequence identifiers. It requires a format string, `"motus_%04d"` in this case, which describes how the new identifier will be generated. The `%04d` in the format string will be replaced by the second argument of the `sprintf` function, `annotations.seq_number`. This argument is the number associated with the sequence in the file. The `d` specifies that the number is a decimal integer, and the `4` specifies that the number will be padded to four digits. The `0` before the `4` specifies that the number will be padded with zeros.

The results of the `printf` function are presented above. The first sequence is identified as `motus_0001`, the second as `motus_0002`, and so on.

#### Edition of the sequence

##### Extracting a fragment of the sequence

You can extract a fragment of a sequence using the `--cut` option. This option requires an argument in the form of `#:###`, where `#` is the start position and `###` is the end position of the fragment. Position numbering is one-based, and the fragment includes the limits.
<!-- J'ai relu jusqu'ici -->

```bash
obiannotate --cut 2:7 five_tags.fasta > five_tags_sub_2_7.fasta
```
{{< code "five_tags_sub_2_7.fasta" fasta true >}}

If `#` is absent the fragment extracted starts from the beginning of the sequence.

```bash
obiannotate --cut :7 five_tags.fasta 
```
```
>seqA1_sub[1..7] {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgct
>seqB1_sub[1..7] {"tata":"bar","taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies","toto":"tata"}
tagctag
>seqA2_sub[1..7] {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagcta
>seqC1_sub[1..7] {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgct
>seqB2_sub[1..7] {"count":25,"tata":"bar"}
cgatggc
```

If `###` is absent the fragment extracted ends at the end of the sequence.

```bash
obiannotate --cut 2: five_tags.fasta 
```
```
>seqA1_sub[2..27] {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
gatgctgcatgctagtgctagtcgat
>seqB1_sub[2..30] {"tata":"bar","taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies","toto":"tata"}
agctagctagctagctagctagctagcta
>seqA2_sub[2..29] {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
tagctagctagctagctagctagctaga
>seqC1_sub[2..29] {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
gatgctccatgctagtgctagtcgatga
>seqB2_sub[2..30] {"count":25,"tata":"bar"}
gatggctccatgctagtgctagtcgatga
```

Following python usage negative coordinates have to be considered from the end of the sequence. `-1` is the last position of the sequence, `-2` is the second last position of the sequence, and so on.

```bash
obiannotate --cut='-7:-2' five_tags.fasta 
```
```
>seqA1_sub[22..26] {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
gtcga
>seqB1_sub[25..29] {"tata":"bar","taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies","toto":"tata"}
tagct
>seqA2_sub[24..28] {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gctag
>seqC1_sub[24..28] {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatg
>seqB2_sub[25..29] {"count":25,"tata":"bar"}
cgatg
```

> [!WARNING] 
> When using negative coordinates like in the above command to not confuse the shell interpretor,
> the option has to be written followed by the `=` sign without space between the option and the value: `--cut='-7:-2'` 

##### Editing the sequence itself

The nucleic sequence of a sequence record is considered by obitools as a special tag annotation name `sequence`. Therefore, it is possible to edit the sequence itself by using the `obiannotate` command with the `--set-tag` option.

```bash
obiannotate --set-tag sequence='"acgtacgt"' five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
acgtacgt
>seqB1 {"tata":"bar","taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies","toto":"tata"}
acgtacgt
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
acgtacgt
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
acgtacgt
>seqB2 {"count":25,"tata":"bar"}
acgtacgt
```

As for the other tags, the `--set-tag` option requires a expression expressed using the [{{% obitools4 %}} expression language]({{< ref "/docs/programming/expression" >}}) and returning a string. 


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
            [--taxonomy|-t <string>] [--u-to-t] [--update-taxid]
            [--valid-taxid] [--version] [--with-leaves]
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
