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

{{< obi obigrep >}} is a tool for selecting a subset of sequences based on a set of criteria. Sequences from the input data set that match all criteria are retained and printed in the result, while the other sequences are discarded. The criteria can be based on the sequence identifier, the sequence itself or the annotations on the sequence.

Selection criteria can be based on different aspects of the sequence data, such as

* The sequence identifier (ID) 
* The sequence annotations
* The sequence itself

### Selection based on sequence identifier (ID)

There are two ways to select sequences based on their identifier: 

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

- the `^` at the beginning means that the string should start with that pattern 
- `seq` is an exact match for that string 
- `[AB]` means any character in the set {A, B} 
- `1` is an exact match for that character 
- `$` at the end of the pattern means that the string should end with that pattern.

 If the starting `^` had been omitted, the pattern would have matched any sequence ID containing "seq" followed by a character from the set {A, B} and ending with "1", for example the IDs `my_seqA1` or `my_seqB1` would have been matched. 

If the ending '$' had been omitted, the pattern would have matched any sequence ID starting with 'seq' followed by a character in the set {A, B} and containing '1', e.g. the ids `seqA102` or `seqB1023456789` would have been matched.

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

Each sequence record may have a sequence definition describing the sequence. In {{% fasta %}} or {{% fastq %}} format, this definition is in the header of each sequence record after the second word (the first being the sequence id), or after the annotations between braces in the {{% obitools4 %}} extended version of these formats.

{{< code "three_def.fasta" fasta true >}}

In the `three_def.fasta` example file:

- `seqA1` has no definition
- `seqB1` definition is `my beautiful sequence`
- `seqA2` definition is `my pretty sequence`

The `-D` or `--definition` allows you to specify a [regular pattern]({{% ref "docs/patterns/regular/_index.html" %}}) to select only sequences whose definition matches the pattern. The example below selects sequences with a definition containing the word `pretty`.

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
- The `--max-count` or `-c` options, followed by a numeric argument, select sequence records with a `count` less than or equal to that argument.

> [!NOTICE] 
> If the `count` tag is missing from a data set, it is assumed to be equal to *1*.

```bash
obigrep -c 2 five_tags.fasta
```
```
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgctgcatgctagtgctagtcgatga
>seqB2 {"count":25,"tata":"bar"}
tagctagctagctagctagctagctagcta
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

The taxonomy based selection is always based on the `taxid` attribute of a sequence, even it this one carry other taxonomic information stored in other attribute like `scientific_name` or `family_taxid`. To be able to use the taxonomy based selection with {{< obi obigrep >}}, it is mandatory to load a taxonomy using the `-t` or `--taxonomy` option.

##### Selecting sequences belonging a clade

If you don't have a taxonomy dump already downloaded, you must at first download one using the following {{< obi obitaxonomy >}} command.
The taxonomy will be stored in a file named `ncbitaxo.tgz`. It is possible to provide this compressed archive later on to other {{% obitools4 %}}.

```bash
obitaxonomy --download-ncbi --out ncbitaxo.tgz
```

To select the sequences belonging the *Homo sapiens* species, the first step is to extract from the downloaded taxonomy the taxid corresponding to the species of interest using the {{< obi obitaxonomy >}} command. 

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

Only sequences *seqA1* and *seqB1* annotated as belonging to the target clade *Homo sapiens* or one of its subspecies *Homo sapiens neanderthalensis* are retained. Sequence *seqA2* is not retained as it is annotated at genus level as Homo and therefore does not belong to the Homo sapiens clade, nor is sequence *seqC1* annotated at family level as *Hominidae*. The last sequence *seqB2* has no taxonomic annotation and is therefore considered to be annotated at the root of taxonomy and therefore not part of the Homo sapiens species clade.

##### Excluding sequences belonging a clade

The `-i`or `--ignore-taxon` in its long form, does the opposite selection of the `-r` option presented above. It retains only sequences not belonging the target clade taxid passed as its argument.

```bash
obigrep -t ncbitaxo.tgz -i taxon:9606 five_tags.fasta
```
```
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgctgcatgctagtgctagtcgatga
>seqB2 {"count":25,"tata":"bar"}
tagctagctagctagctagctagctagcta
```

Here only the sequence *seqA2*, *seqC1* and *seqB2* are retained because none of them belongs the *Homo sapiens* species.

##### Keep only sequence with taxonomic information at a given rank

A taxid, when associated with a taxonomy, not only provides information at its taxonomic rank, but also allows retrieval of information at any rank above it. For example, from a species taxid, it is expected that by querying the taxonomy it will be possible to retrieve the taxid of the corresponding genus or family. {{< obi obigrep >}} allows you to select sequences annotated by a taxid capable of providing information at a given taxonomic rank using the `--require-rank` option.

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

`seqA2` and `seqC1` are discarded as they are annotated at genus and family level respectively, while `seqB2` is discarded as it is not taxonomically annotated and is therefore considered to be annotated at the root of the taxonomy.


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



## Synopsis

```bash
obigrep [--allows-indels] [--approx-pattern <PATTERN>]...
        [--attribute|-a <KEY=VALUE>]... [--batch-size <int>] [--compress|-Z]
        [--debug] [--definition|-D <PATTERN>]... [--ecopcr] [--embl]
        [--fasta] [--fasta-output] [--fastq] [--fastq-output]
        [--force-one-cpu] [--genbank] [--has-attribute|-A <KEY>]...
        [--help|-h|-?] [--id-list <FILENAME>] [--identifier|-I <PATTERN>]...
        [--ignore-taxon|-i <TAXID>]... [--input-OBI-header]
        [--input-json-header] [--inverse-match|-v] [--json-output]
        [--max-count|-C <COUNT>] [--max-cpu <int>] [--max-length|-L <LENGTH>]
        [--min-count|-c <COUNT>] [--min-length|-l <LENGTH>] [--no-order]
        [--no-progressbar] [--only-forward] [--out|-o <FILENAME>]
        [--output-OBI-header|-O] [--output-json-header]
        [--paired-mode <forward|reverse|and|or|andnot|xor>]
        [--paired-with <FILENAME>] [--pattern-error <int>] [--pprof]
        [--pprof-goroutine <int>] [--pprof-mutex <int>]
        [--predicate|-p <EXPRESSION>]... [--require-rank <RANK_NAME>]...
        [--restrict-to-taxon|-r <TAXID>]... [--save-discarded <FILENAME>]
        [--sequence|-s <PATTERN>]... [--skip-empty] [--solexa]
        [--taxonomy|-t <string>] [--version] [<args>]
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
