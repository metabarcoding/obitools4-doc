---
archetype: "command"
title: "obigrep"
date: 2025-02-10
command: "obigrep"
category: basics
url: "/obitools/obigrep"
weight: 80
---

# `obigrep`: filter a sequence file

## Description 

{{< obi obigrep >}} is a tool for selecting a subset of sequences based on a set of criteria. Sequences from the input dataset that match all the criteria are retained and printed in the result, while other sequences are discarded.

Selection criteria can be based on different aspects of the sequence data, such as

* The sequence identifier (ID) 
* The sequence annotations
* The sequence itself

### Selection based on sequence identifier (ID)

There are two ways of selecting sequences according to their identifier: 

* Using a [regular pattern]({{% ref "docs/patterns/regular/_index.html" %}}) with option `-I`
* Using a list of identifiers (IDs) provided in a file with option `--id-list`
  
On the following five-sequences sample file:

{{< code "five_ids.fasta" fastq true >}}

To select sequences with IDs "seqA1" and "seqB1", you can use the command

```bash
obigrep -I '^seq[AB]1$' five_ids.fasta
```
```
>seqA1 
cgatgctgcatgctagtgctagtcgat
>seqB1 
tagctagctagctagctagctagctagcta
```

The explanations for the regular pattern `^seq[AB]1$` are

- the `^` at the beginning means that the string must start with that pattern 
- `seq` is an exact match for that string 
- `[AB]` means any character in the set {A, B} 
- `1` is an exact match for that character 
- `$` at the end of the pattern means that the string must end with that pattern.

 If the starting `^` had been omitted, the pattern would have matched any sequence ID containing "seq" followed by a character from the set {A, B} and ending with "1", for example the IDs `my_seqA1` or `my_seqB1` would have been selected. 

If the ending '$' had been omitted, the pattern would have matched any sequence ID starting with 'seq' followed by a character in the set {A, B} and containing '1', e.g. the ids `seqA102` or `seqB1023456789` would have been selected.

Another solution to extract these sequence IDs would be to use a text file containing them, one per line, as follows

{{< code "seqAB.txt" txt true >}}

This `seqAB.txt` can then be used as an index file by  {{< obi obigrep >}}:

```bash
obigrep --id-list seqAB.txt five_ids.fasta
```
```
>seqA1 
cgatgctgcatgctagtgctagtcgat
>seqB1 
tagctagctagctagctagctagctagcta
```

### Selection based on sequence definition

Each sequence record can have a sequence definition describing the sequence. In {{% fasta %}} or {{% fastq %}} format, this definition is found in the header of each sequence record after the second word (the first being the sequence id), or after the annotations between braces in the {{% obitools4 %}} extended version of these formats.

{{< code "three_def.fasta" fasta true >}}

In the `three_def.fasta` example file:

- `seqA1` has no definition
- `seqB1` definition is `my beautiful sequence`
- `seqA2` definition is `my pretty sequence`

The `-D` or `--definition` option lets you specify a [regular pattern]({{% ref "docs/patterns/regular/_index.html" %}}) to select only those sequences whose definition matches the pattern. The example below selects sequences whose definition contains the word `pretty`.

```bash
obigrep -D pretty three_def.fasta
```
```
>seqA2 {"count":10,"definition":"my pretty sequence"}
gtagctagctagctagctagctagctaga
```

As you can see in the results, all the {{% obitools4 %}} include the definition present in the original file as a new annotation tag called `definition`. So it is actually this tag that is tested by the `-D` option.

### Selection based on the annotations

#### Selection based on any annotation

The {{< obi obigrep >}} tool can also be used to select sequences based on their annotations. Annotation are constituted by all the tags and values added to each sequence header in the {{% fasta %}}/{{% fastq %}} file. For instance, if you have a sequence file with the following headers:

{{< code "five_tags.fasta" fasta true >}}

##### Selecting sequences having a tag whatever its value

The `-A` option allows for selecting sequences having the given attribute whatever its value. In the following example, all the sequences having the `count` attribute are selected.

```bash
obigrep -A "count" five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgctgcatgctagtgctagtcgatga
>seqB2 {"count":25,"tata":"bar"}
tagctagctagctagctagctagctagcta
```

Only four sequences are retained, the sequence `seqB1` is excluded because it does not have the tag `count`.

##### Selecting sequences having a tag with a specific value

The `-a` option allows for selecting sequences having the given attribute affected to a value matching the provided [regular pattern]({{% ref "docs/patterns/regular.md" %}}). In the following example, only the sequence *seqA1* having the `toto` attribute containing the value `titi` is selected.

```bash
obigrep -a toto="titi" five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
```

As the value is a [regular pattern]({{% ref "docs/patterns/regular.md" %}}), it is possible to be less strict, and for example,
the following command will select all sequences with the `toto` attribute containing a value beginning (`^` at the start of the expression) with `t`.

```bash
obigrep -a toto="^t" five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"tata":"bar","taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies","toto":"tata"}
tagctagctagctagctagctagctagcta
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
```

The sequence `seqC1` is excluded because its `toto` attribute contains the value `foo`, which does not begin with `t`, while `seqB2` is excluded because it does not have a `toto` attribute.

#### Selection based on the sequence abundances

In amplicon sequencing experiments, a sequence may be observed many times. The {{< obi obiuniq >}} command can be used to dereplicate strictly identical sequences. The number of strictly identical sequence reads merged into a single sequence record is stored in the `count` annotation tag of that sequence record. It is common to filter out sequences that are too rare or too abundant, depending on the purpose of the experiment. There are two ways to select sequence records based on this `count` tag.

- the `--min-count` or `-c` options, followed by a numeric argument, select sequence records with a `count` greater than or equal to that argument.
- The `--max-count` or `-C` options, followed by a numeric argument, select sequence records with a `count` less than or equal to that argument.

> [!NOTICE] 
> If the `count` tag is missing from a data set, it is assumed to be equal to *1*.

```bash
obigrep -c 2 five_tags.fasta
```
```
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"count":25,"tata":"bar"}
cgatggctccatgctagtgctagtcgatga
```

Remove singleton sequences (sequences observed only once), here the sequences `seqA1` having a `count` tag equal to *1*, and `seqB1` having no `count` tag defined. 

The next command excludes from its results all the sequences occurring at least ten times.

```bash
obigrep -C 10 five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"tata":"bar","taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies","toto":"tata"}
tagctagctagctagctagctagctagcta
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
```

As usual, both options can be combined

```bash
obigrep -c 2 -C 10 five_tags.fasta
```
```
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
```

#### Selection based on taxonomic annotation.

Taxonomy-based selection is always performed on the `taxid` attribute of a sequence, even if it contains other taxonomic information stored in other attribute such as `scientific_name` or `family_taxid`. To use  taxonomy-based selection with {{< obi obigrep >}}, it is mandatory to load a taxonomy using the `-t` or `--taxonomy` option.

##### Selecting sequences belonging a clade

If you do not have a taxonomy dump already downloaded, you must first download one using the following {{< obi obitaxonomy >}} command.
The taxonomy will be stored in a file named `ncbitaxo.tgz`. This compressed archive can be supplied to other {{% obitools4 %}} at a later date.

```bash
obitaxonomy --download-ncbi --out ncbitaxo.tgz
```

To select the sequences belonging to the *Homo sapiens* species, the first step is to extract the taxid corresponding to the species of interest from the downloaded taxonomy using the {{< obi obitaxonomy >}} command. 

- The `-t` option indicates the taxonomy to load
- The `--fixed` option indicates to consider the query string as the exact name of the species, not as a [regular pattern]({{% ref "docs/patterns/regular.md" %}}).
- The `--rank species` indicates that our interest is only on taxa having the **species** taxonomic rank.
- `"Homo sapiens"` is the query string used to match the taxonomy names.

The `csvlook` command aims to present nicely the {{% csv %}} output of {{< obi obitaxonomy >}}.

```bash
obitaxonomy -t ncbitaxo.tgz --fixed --rank species "Homo sapiens" | csvlook -I
```
```
| taxid                             | parent                  | taxonomic_rank | scientific_name |
| --------------------------------- | ----------------------- | -------------- | --------------- |
| taxon:9606 [Homo sapiens]@species | taxon:9605 [Homo]@genus | species        | Homo sapiens    |
```

The {{< obi obigrep >}} option to select sequences belonging a taxon is `-r` or `--restrict-to-taxon`. The option requires as argument the taxid of the clade of interest, here `9606` for *Homo sapiens*. 

```bash
obigrep -t ncbitaxo.tgz -r taxon:9606 five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"tata":"bar","taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies","toto":"tata"}
tagctagctagctagctagctagctagcta
```

Only sequences *seqA1* and *seqB1* annotated as belonging to the target clade *Homo sapiens* or one of its subspecies *Homo sapiens neanderthalensis* are retained. Sequence *seqA2* is not retained as it is annotated at genus level as *Homo* and therefore does not belong to the *Homo sapiens* clade, nor is sequence *seqC1* annotated at family level as *Hominidae*. The last sequence *seqB2* has no taxonomic annotation and is therefore considered to be annotated at the root of the taxonomy and no part of the *Homo sapiens* species clade.

##### Excluding sequences belonging a clade

The `-i` or `--ignore-taxon` in its long form, performs the reverse selection of the `-r` option presented above. It only retains sequences that do not belong to the taxid target clade passed as an argument.

```bash
obigrep -t ncbitaxo.tgz -i taxon:9606 five_tags.fasta
```
```
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"count":25,"tata":"bar"}
cgatggctccatgctagtgctagtcgatga
```

Here, only the sequence *seqA2*, *seqC1* and *seqB2* are retained as none of them belongs to the *Homo sapiens* species.

##### Keep only sequence with taxonomic information at a given rank

A taxid, when associated with a taxonomy, not only provides information at its taxonomic rank, but also makes it possible to retrieve information at any higher rank. For example, from a species taxid, it is expected that by querying the taxonomy, it will be possible to retrieve the corresponding genus or family taxid. {{< obi obigrep >}} allows you to select sequences annotated by a taxid capable of providing information at a given taxonomic rank using the `--require-rank` option.

To retrieve all ranks defined by a taxonomy, it is possible to use the {{< obi obitaxonomy >}} command with the `-l` option.

```bash
obitaxonomy -t ncbitaxo.tgz -l | csvlook
```
```
| rank             |
| ---------------- |
| domain           |
| phylum           |
| class            |
| suborder         |
| subcohort        |
| superphylum      |
| subspecies       |
| varietas         |
| subgenus         |
| parvorder        |
| acellular root   |
| genotype         |
| subtribe         |
| subkingdom       |
| subfamily        |
| kingdom          |
| isolate          |
| superorder       |
| section          |
| subvariety       |
| genus            |
| serogroup        |
| tribe            |
| forma            |
| infraclass       |
| superclass       |
| serotype         |
| no rank          |
| family           |
| species group    |
| subclass         |
| infraorder       |
| pathogroup       |
| realm            |
| order            |
| biotype          |
| species subgroup |
| species          |
| strain           |
| clade            |
| cohort           |
| series           |
| cellular root    |
| morph            |
| subphylum        |
| forma specialis  |
| superfamily      |
| subsection       |
```

This allows us to check that the **species** rank is defined and to filter the `five_tags.fasta` test file to retain only sequences with information available at the **species** level.

```bash
obigrep -t ncbitaxo.tgz --require-rank species five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"tata":"bar","taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies","toto":"tata"}
tagctagctagctagctagctagctagcta
```

Only two sequences are selected by this command, because `seqA1` is annotated at the **species** level, and `seqB1` is annotated at the **subspecies** taxonomic rank, which allows for retrieving **species** level information. 

`seqA2` and `seqC1` are discarded as they are annotated at genus and family levels, respectively. `seqB2` is discarded as it is not taxonomically annotated and is therefore considered to be annotated at the root of the taxonomy.


##### Keep only sequences annotated with valid taxids



{{< code "six_invalid.fasta" fasta true >}}

```bash
obigrep -t ncbitaxo.tgz --valid-taxid six_invalid.fasta
```
```bash
WARN[0005] seqD1: Taxid: taxon:9607 is unknown from taxonomy (Taxid taxon:9607 is not part of the taxonomy NCBI Taxonomy) 
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"tata":"bar","taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies","toto":"tata"}
tagctagctagctagctagctagctagcta
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgctgcatgctagtgctagtcgatga
```

### Selection based on the sequence

#### Selection based on the sequence length

Two options `-l` (`--min-length`) and `-L` (`--max-length`) allow to select sequences based on their length. A sequence is selected if its length is greater or equal to the `--min-length` and less or equal to the `--max-length`. If only one of these options is used, only the specified limit is applied.

In the [`five_tags.fasta`](five_tags.fasta), one sequence is 27 base pairs (bp) long, two are 29 bp and the two last 30 bp long.

To select only sequences with a minimum length of 29 bp, the following command can be executed

```bash
obigrep -l 29 five_tags.fasta
```
```
>seqB1 {"tata":"bar","taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies","toto":"tata"}
tagctagctagctagctagctagctagcta
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"count":25,"tata":"bar"}
cgatggctccatgctagtgctagtcgatga
```

To select only sequences with a maximum length of 29 bp, the following command can be executed

```bash
obigrep -L 29 five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgctccatgctagtgctagtcgatga
```

Interestingly, in both cases, both 29-bp sequences were selected.

#### Selection based on the sequence

Sequence records can be selected on the sequence itself. There are two pattern matching algorithms available, depending on the options used:
* `--sequence` or `-s` : The pattern is a [regular pattern]({{% ref "docs/patterns/regular/_index.html" %}}) used to match the sequence records. The pattern is not case-sensitive.
* `--approx-pattern` : This option uses the same algorithm as {{< obi obipcr >}} and {{< obi obimultiplex >}} to locate primers. The description of the pattern follows the [same grammar]({{% ref "docs/patterns/dnagrep/_index.html" %}}).
  
While [regular pattern]({{% ref "docs/patterns/regular/_index.html" %}}) allows for more complex expression in describing the look-up sequence, the [DNA Patterns]({{% ref "docs/patterns/dnagrep/_index.html" %}}) have the advantage of offering discrepancy between the pattern and the actual sequence (mismatches and indels). To set the number and the type of allowed errors use the `--pattern-error` and the `--allows-indels` options. 

In the next example, sequences containing the pattern `tgc` present twice at least in the sequence eventually separated by any number of bases (`.*`) are searched. This can be expressed as the [regular pattern]({{% ref "docs/patterns/regular/_index.html" %}}) : `tgc.*tgc`

```bash
obigrep -s 'tgc.*tgc' five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"count":25,"tata":"bar"}
cgatggctccatgctagtgctagtcgatga
```

If we are interested in sequence matching this pattern `gatgctgcat`, but want to allow a certain number of errors, we can use the `--approx-pattern` option. Despite its name, this option does not allow any errors by default, so for simple patterns like the one we have here, both the `--approx-pattern` and the `-s` options are equivalent.

```bash
obigrep --approx-pattern gatgctgcat \
        five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
```

```bash
obigrep -s gatgctgcat \
        five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
```

However, `--approx-pattern` can be parameterized using the `--pattern-error` option. The following example allows two errors (differences) between the pattern and the matched sequence. Without a further option, these errors can only be substitutions. Thus, the value defined by `--pattern-error` is the maximum [Hamming distance](https://en.wikipedia.org/wiki/Hamming_distance) between the pattern and the matched sequence.

```bash
obigrep --approx-pattern gatgctgcat \
        --pattern-error 2 \
        five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgctccatgctagtgctagtcgatga
```

By adding the `--allows-indels` option, obigrep will allow indels in the pattern. This means that it can match sequences where the differences between the pattern and the matched sequence are insertions or deletions. Insertion or deletion of a symbol is considered one error. Therefore, with `--pattern-error 2` and `--allows-indels` you can allow two mismatches, two insertions or deletions, or one mismatch and one indel. In this case, the `--pattern-error' defines the maximum [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance) allowed between the pattern and the matched sequence.

```bash
obigrep --approx-pattern gatgctgcat \
        --pattern-error 2 \
        --allows-indels \
        five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgctccatgctagtgctagtcgatga
>seqB2 {"count":25,"tata":"bar"}
cgatggctccatgctagtgctagtcgatga
```

### Defining you own predicate

You can create your own predicate to filter your dataset. A predicate is an expression that returns a logical value of true or false when evaluated. It is defined using the `--predicate` (`-p`) option and the [{{% obitools4 %}} expression language]({{< ref "/docs/programming/expression" >}}). The predicate is evaluated on each sequence in the dataset. Sequences that result in a `true` value are retained in the result, while those that result in a `false` value are discarded.

The following command, for example, filters out all sequences with a *count* annotation of less than 2 and greater than 10.

```bash
obigrep -c 2 -C 10 five_tags.fasta
```
```
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
```

The following predicate can be used to substitute for it:

```bash
obigrep -p 'sequence.Count() >= 2 && sequence.Count() <= 10' five_tags.fasta
```
```
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
```

The [{{% obitools4 %}} expression language]({{< ref "/docs/programming/expression" >}}) provides `min` and `max` functions. These functions extract the minimum and maximum values from a map or vector, respectively.

In the file  [`some_uniq_seq.fasta`](some_uniq_seq.fasta), the 'merged_sample` tag on each sequence indicates how the corresponding reads are distributed among samples.

{{< code "some_uniq_seq.fasta" fasta true >}}

It is possible to extract the contingency table from this file using the {{< obi obimatrix >}} command. The `--transpose` option transposes the matrix so that sequences are in rows and samples are in columns.

```bash
obimatrix --transpose some_uniq_seq.fasta \
  | csvtomd
```
```markdown
id     |  15a_F730814  |  29a_F260619
-------|---------------|-------------
Seq_1  |  1            |  1
Seq_2  |  12           |  10
Seq_3  |  15           |  7
```

To select sequences that occur at least ten times in a sample, you have to determine the maximum value of the `merged_sample` tag and compare it to the value ten.

This can be done using a predicate expression:

```bash
obigrep -p 'max(annotations.merged_sample) >= 10' some_uniq_seq.fasta 
```
```
>Seq_2 {"count":22,"merged_sample":{"15a_F730814":12,"29a_F260619":10}}
ttagccctaaacacaagtaattaatataacaaaattattcgccagagtactaccggcaat
atcttaaaactcaaaggacttggcggtgctttataccctt
>Seq_3 {"count":22,"merged_sample":{"15a_F730814":15,"29a_F260619":7}}
ttagccctaaacacaagtaattaatataacaaaattattcgccagagtactaccggcgat
agcttaaaactcaaaggacttggcggtgctttataccctt
```

As you can see from the results, `seq_1` is discarded because it does not appear in any of the samples.
It does not occur more than ten times. The maximum number of occurrences of `seq_1` is *1*.

## Working with paired sequence files:

{{% obitools4 %}} can handle paired sequence files. This means that it processes the paired sequences in the two files together. In particular, for {{< obi obigrep >}}, it will apply the same filtering to both files. This ensures that each sequence in the result files is paired with its correct counterpart.

The most important option for manipulating paired sequence files is the `--paired-with` option. This allows you to specify the name of a file containing sequences to be paired with those in the main sequence file. Since an obitools4 command that processes paired sequences produces two paired result files, the standard output cannot be used to store the results. Instead, you must use the `--out` option to specify where the results should be written.

Considering the two paired input files:

{{< code "forward.fastq" fastq true >}}

{{< code "reverse.fastq" fastq true >}}

To conserve only sequences starting with a **t**, use the following command:
<!-- Should it be **t** or **T** ? or it is equivalent? -->
```bash
obigrep -s '^t' \
        --paired-with reverse.fastq \
        --out start_t.fastq \
        forward.fastq
```

After running the {{< obi obigrep >}} command, if you check the directory contents, you will obtain two new files named [`start_t_R1.fastq`](start_t_R1.fastq) and [`start_t_R2.fastq`](start_t_R2.fastq), in addition to the two input files, [`forward.fastq`](foward.fastq) and [`reverse.fastq`](reverse.fastq).  These file names are created by adding the suffixes `_R1` and `_R2` to the `start_t.fastq` file name specified in the `--out` option. The `start_t_R1.fastq` file (suffix `_R1`) contains the reads from the main file ([`forward.fastq`](foward.fastq)), while `start_t_R2.fastq` (suffix `_R2`) contains the reads from the file specified by the '--paired-with' option ([`reverse.fastq`](reverse.fastq)).

```
% ls -l
total 135568
-rw-r--r--@ 1 coissac  staff      1504 13 mai 18:09 forward.fastq
-rw-r--r--@ 1 coissac  staff      1504 13 mai 18:09 reverse.fastq
-rw-r-----@ 1 coissac  staff      1179 13 mai 18:14 start_t_R1.fastq
-rw-r-----@ 1 coissac  staff      1179 13 mai 18:14 start_t_R2.fastq
```

Inspecting the file  [`start_t_R1.fastq`](start_t_R1.fastq) makes the effect of  {{< obi obigrep >}} clear. Every sequence starts with **t**.

{{< code "start_t_R1.fastq" fastq true >}}
However, when we look at the file  [`start_t_R2.fastq`](start_t_R2.fastq), the second sequence starts with a **c**. In fact, the {{< obi obigrep>}} constraint was only applied to the [`forward.fastq`](foward.fastq) file. The sequences were selected from the [`reverse.fastq`](reverse.fastq) file because they are paired with one of the sequences selected from the [`forward.fastq`](foward.fastq) file.

{{< code "start_t_R2.fastq" fastq true >}}

The `--paired-mode` option can be used to specify how the {{< obi obigrep >}} filtering constraints are applied to both files. The option requires an argument that can take four different values:

- `forward`: the selection rules apply only to the forward reads; the reverse reads are selected because they are paired with a selected forward read. This is the default behaviour presented above.
- `reverse`: the selection rules apply only to the reverse reads; the forward reads are selected because they are paired with a selected reverse read.

```bash
obigrep -s '^t' \
        --paired-with reverse.fastq \
        --paired-mode reverse \
        --out start_t_rev.fastq \
        forward.fastq
```

{{< code "start_t_rev_R1.fastq" fastq true >}}

{{< code "start_t_rev_R2.fastq" fastq true >}}


- `and`: the selection rules must be true for both reads of the pair

```bash
obigrep -s '^t' \
        --paired-with reverse.fastq \
        --paired-mode and \
        --out start_t_and.fastq \
        forward.fastq
```

{{< code "start_t_and_R1.fastq" fastq true >}}

{{< code "start_t_and_R2.fastq" fastq true >}}


- `or`:  the selection rules must be true for at least one read of the pair. The second read is selected because its counterpart has been selected by the {{< obi obigrep >}} rules.

```bash
obigrep -s '^t' \
        --paired-with reverse.fastq \
        --paired-mode or \
        --out start_t_or.fastq \
        forward.fastq
```

{{< code "start_t_or_R1.fastq" fastq true >}}

{{< code "start_t_or_R2.fastq" fastq true >}}

- `andnot`: the selection rules must be true on the forward sequence but not on the reverse one.

```bash
obigrep -s '^t' \
        --paired-with reverse.fastq \
        --paired-mode andnot \
        --out start_t_andnot.fastq \
        forward.fastq
```

{{< code "start_t_andnot_R1.fastq" fastq true >}}

{{< code "start_t_andnot_R2.fastq" fastq true >}}

- `xor`: the selection rules must be true on only one read of the pair, not on both.

```bash
obigrep -s '^t' \
        --paired-with reverse.fastq \
        --paired-mode xor \
        --out start_t_xor.fastq \
        forward.fastq
```

{{< code "start_t_xor_R1.fastq" fastq true >}}

{{< code "start_t_xor_R2.fastq" fastq true >}}


## Synopsis

```bash
obigrep [--allows-indels] [--approx-pattern <PATTERN>]...
        [--attribute|-a <KEY=VALUE>]... [--batch-size <int>] [--compress|-Z]
        [--csv] [--debug] [--definition|-D <PATTERN>]... [--ecopcr] [--embl]
        [--fail-on-taxonomy] [--fasta] [--fasta-output] [--fastq]
        [--fastq-output] [--force-one-cpu] [--genbank]
        [--has-attribute|-A <KEY>]... [--help|-h|-?] [--id-list <FILENAME>]
        [--identifier|-I <PATTERN>]... [--ignore-taxon|-i <TAXID>]...
        [--input-OBI-header] [--input-json-header] [--inverse-match|-v]
        [--json-output] [--max-count|-C <COUNT>] [--max-cpu <int>]
        [--max-length|-L <LENGTH>] [--min-count|-c <COUNT>]
        [--min-length|-l <LENGTH>] [--no-order] [--no-progressbar]
        [--only-forward] [--out|-o <FILENAME>] [--output-OBI-header|-O]
        [--output-json-header]
        [--paired-mode <forward|reverse|and|or|andnot|xor>]
        [--paired-with <FILENAME>] [--pattern-error <int>] [--pprof]
        [--pprof-goroutine <int>] [--pprof-mutex <int>]
        [--predicate|-p <EXPRESSION>]... [--raw-taxid]
        [--require-rank <RANK_NAME>]... [--restrict-to-taxon|-r <TAXID>]...
        [--save-discarded <FILENAME>] [--sequence|-s <PATTERN>]...
        [--silent-warning] [--skip-empty] [--solexa] [--taxonomy|-t <string>]
        [--u-to-t] [--update-taxid] [--valid-taxid] [--version]
        [--with-leaves] [<args>]
```

## Options

{{< option-sets/selection >}}

### Matching the sequence annotations

### Taxonomy based filtering

If the user specifies a taxonomy when calling {{< obitools obigrep >}} (see `--taxonomy` option), it is possible to filter the sequences based on taxonomic properties. Each of the following options can be used multiple times if needed to specify multiple taxids or ranks.

- {{< cmd-option name="restrict-to-taxon" short="r" param="TAXID" >}}
  Only sequences having a taxid belonging the provided taxid are conserved.
  {{< /cmd-option >}}

- {{< cmd-option name="ignore-taxon" short="i" param="TAXID" >}}
  Sequences having a taxid belonging the provided taxid are discarded.
  {{< /cmd-option >}}

- {{< cmd-option name="require-rank" param="RANK_NAME" >}}
  Only sequences having a taxid able to provide information at the <RANK_NAME> level are conserved.
  As an example, the NCBI taxid 74635 corresponding to *Rosa canina* is able to provide information at the *species*, *genus* or *family* level. But, taxid 3764 (*Rosa* genus) is not able to provide information at the *species* level. Many of the taxid related to environmental samples have partial classification and a taxon at the *species* level is not always connected to a taxon at the *genus* level as parent. They can sometimes be connected to a taxon at higher level. 
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obigrep --help
```
