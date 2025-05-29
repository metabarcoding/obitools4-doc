---
title: "General operating principles"
weight: 22
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# General operating principles for {{% obitools %}}

{{% obitools %}}are not a metabarcoding data analysis pipeline, but a set of tools for developing customized analyses, while avoiding the black-box effect of a ready-to-use pipeline. A particular effort in the development of {{% obitools4 %}} has been to use data formats that can be easily interfaced with other software.

{{% obitools %}} correspond to a set of UNIX commands that are executed from a command line interface, also known as a terminal, to perform various tasks on DNA sequence files. A UNIX command can be considered as a process that takes a set of inputs and produces a set of outputs.

{{< mermaid class="workflow" >}}
graph LR
  A@{ shape: doc, label: "input 1" }
  B@{ shape: doc, label: "input 2" }
  C[Unix command]
  D@{ shape: doc, label: "output 1" }
  E@{ shape: doc, label: "output 2" }
  F@{ shape: doc, label: "output 3" }
  A --> C
  B --> C:::obitools
  C --> D
  C --> E
  C --> F
  classDef obitools fill:#99d57c
{{< /mermaid >}}

Most {{% obitools %}} take a single file as input and produce a single file as output. Among the inputs, one has a special status: the standard input (*stdin*). Symmetrically, there is the standard output (*stdout*). By default, like any other UNIX command, the {{% obitools %}} reads its data from *stdin* and write its results to *stdout*.

{{< mermaid class="workflow" >}}
graph LR
  A@{ shape: doc, label: "stdin" }
  C[Unix command]
  D@{ shape: doc, label: "stdout" }
  A --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}

If nothing is specified, the UNIX system connects standard input to the terminal keyboard and standard output to the terminal screen. So, for example, if you enter the {{< obi obiconvert >}} command in your terminal without any arguments, it will appear to stop and do nothing, when in fact it is waiting for you to type something on the keyboard. To stop it, just press *Ctrl+D* or *Ctrl+C*. *Ctrl+D* ends typing and stops the program. *Ctrl+C* kills the program.

## Specifying the input data

{{% obitools %}} are designed to process DNA sequence files. Most of them therefore accept DNA sequence files as input. They can be formatted in the most common sequence file formats, {{% fasta %}}, {{% fastq %}}, {{% embl %}} and {{% genbank %}} flat files. Data can also be supplied as CSV files. The {{% obitools %}} generally recognize the file format of input data, but options are provided to force a specific format (*i.e.* `--fasta`, `--fastq`, `--genbank`, `--embl`).

The most common way to specify the file containing the DNA sequences to be processed is to specify its name as an argument. Here is an example using {{< obi obicount >}} to count the number of DNA sequences in a file named `my_file.fasta`.

```bash
obicount my_file.fasta
```

But it is also possible to pass data using the Unix redirection mechanism (*i.e.* `>` and `<`, [more details](https://en.wikipedia.org/wiki/Redirection_(computing))).

```bash
obicount < my_file.fasta
```

{{% obitools %}} can also be used to process a set of files. In this case, {{% obitools %}} will process the files in the order in which they appear on the command line.

```bash
obicount my_file1.fasta my_file2.fasta my_file3.fasta
```

The wildcard character (*i.e.* `*`) can be used to specify a set of files to be processed.

```bash
obicount my_file*.fasta
```

If the files are located in a subdirectory, the directory name can be specified, without the need to specify any file name. In that case, {{% obitools %}} will process all the sequence files present in the subdirectory. Sequence files are searched recursively in the specified directory and all its sub-directories.

```bash
obicount my_sub_directory
```

Files considered to be DNA sequence files are those with the extension `.fasta`, `.fastq`, `.genbank` or `.embl`, `.seq` or `.dat`. Files with the second extension `.gz` (*e.g.* `.fasta.gz`) are also considered to be DNA sequence files and are processed without the need for decompression.

Imagine a folder called `Genbank` containing a complete copy of the Genbank database organized into subdirectories, one per division. Each division subdirectory contains a set of {{% fasta %}} compressed (`.gz`) files.

```
. 📂 Genbank
└── 📂 bct
│   └── 📄 gbbct1.fasta.gz
│   ├── 📄 gbbct2.fasta.gz
│   ├── 📄 gbbct3.fasta.gz
│   └── 📄 ...
└── 📂 inv
│   └── 📄 gbinv1.fasta.gz
│   ├── 📄 gbinv2.fasta.gz
│   ├── 📄 gbinv3.fasta.gz
│   └── 📄...
└── 📂 mam
│   └── 📄 gbmam1.fasta.gz
│   ├── 📄 gbmam2.fasta.gz
│   ├── 📄 gbmam3.fasta.gz
│   └── 📄...
└── 📂...
│
```

It is possible to count entries in the `gbbct1.fasta.gz` file with the command

```bash
obicount Genbank/bct/gbbct1.fasta.gz
```

to count the entries in the **bct** (bacterial) division with the command

```bash
obicount Genbank/bct
```

or to count the entries in the complete Genbank copy with the command

```bash
obicount Genbank
```

## Specifying what to do with the output

By default, {{% obitools %}} write their output to standard output (*stdout*), which means that the results of a command are printed out on the terminal screen. 

Most {{% obitools %}} produce sequence files as output. The output sequence file is in {{% fasta %}} or {{% fastq %}} format, depending on whether it contains quality scores ({{% fastq %}}) or not ({{% fasta %}}). The output format of sequence files can be forced using the `--fasta-output` or `--fastq-output` options. If the `--fastq-output` option is used for a dataset without quality information, a default quality score of 40 will be assigned to each nucleotide. A third option is the `--json-output` option, which produces data in {{% json %}} format.

With the exception of the {{< obi obisummary >}} command, the {{% obitools %}} which produce other
types of data return them in CSV format. The {{< obi obisummary >}} command
returns its results in [JSON](https://en.wikipedia.org/wiki/JSON) or
[YAML](https://en.wikipedia.org/wiki/YAML) formats.

The {{< obi obicomplement >}} command computes the reverse-complement of the DNA sequences provided as input. 

{{< code "two_sequences.fasta" fasta true >}} 

If the `two_sequences.fasta` file is processed with the {{< obi obicomplement >}} command, without indicating the name of the output file, the result is written to the terminal screen.

```bash
obicomplement two_sequences.fasta
```
{{< code "two_sequences_comp.fasta" fasta false >}} 

There are two options for saving the results to a file. The first is to redirect the output to a file, as in the following example.

```bash
obicomplement two_sequences.fasta > two_sequences_comp.fasta
```

The second option is to use the `--out` option.

```bash
obicomplement two_sequences.fasta --out two_sequences_comp.fasta
```

Both methods will produce the same result, a file named <a href="two_sequences_comp.fasta" download="two_sequences_comp.fasta">`two_sequences_comp.fasta`</a> containing the reverse-complement of the DNA sequences contained in <a href="two_sequences.fasta" download="two_sequences.fasta">`two_sequences.fasta`</a>.

## Combining {{% obitools %}} commands using pipes

Since {{% obitools %}} are UNIX commands, and their default behaviour is to read their input from *stdin* and write their output to *stdout*, it is possible to combine them using the Unix pipe mechanism (*i.e.* `|`). For example, you can reverse-complement the file `two_sequences.fasta` with the command {{% obi obicomplement %}}, and then count the number of DNA sequences in the resulting file with the command {{% obi obicount %}}, without saving the intermediate results, by linking the *stdout* of {{% obi obicomplement %}} to the *stdin* of {{% obi obicount %}}.

```bash
obicomplement two_sequences.fasta | obicount 
```
```
entities,n
variants,2
reads,3
symbols,200
```

The result of the {{% obi obicount %}} command is a CSV file. Therefore, it can itself be piped to another command, like [`csvtomd`](https://github.com/mplewis/csvtomd) to reformat the result in a Markdown table.

```bash
obicomplement two_sequences.fasta | obicount | csvtomd
```
```
entities  |  n
----------|-----
variants  |  2
reads     |  3
symbols   |  200
```

Or being plotted with the [`uplot`](https://github.com/red-data-tools/YouPlot) command.

```bash
obicomplement two_sequences.fasta | obicount | uplot barplot -H -d,
```
```
                               n
            ┌                                        ┐ 
   variants ┤ 2.0                                      
      reads ┤ 3.0                                      
    symbols ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 200.0   
            └                                        ┘ 
```

## The tagging system of {{% obitools %}}

{{% obitools %}} provide several tools for performing computations on the sequences. The result of such a computation may be the selection of a subset of the input sequences, a modification of the sequences themselves, or it may only lead to the estimation of some sequence properties. In the latter case, {{% obitools %}} store the estimated properties of the relevant sequence in a {{% fasta %}} or {{% fastq %}} file. To achieve this, {{% obitools %}} add structured information in the form of a JSON map to the header of each sequence. The JSON map allows calculation results to be stored in key-value pairs. Each {{% obitools %}} command adds one or more key-value pairs to the JSON map as required to annotate a sequence. Below is an example of a {{% fasta %}} formatted sequence with a JSON map added to its header containing three key-value pairs: `count` associated with the value `2`, `is_annotated` associated with the value `true` and `xxxx` associated with the value `yyyy`.

```
>sequence1 {"count": 2, "is_annotated": true, "xxxx": "yyy"}
cgacgtagctgtgatgcagtgcagttatattttacgtgctatgtttcagtttttttt
fdcgacgcagcggag
```

### The key names

Keys can be any string of characters. Their names are case-sensitive. The keys `count`,
`Count` and `COUNT` are all considered to be different keys. Some key names are
reserved by {{% obitools %}} and have special meanings (*e.g.* `count`
contains, if present, an integer value indicating how many times this sequence has
been observed, `taxid` contains a string corresponding to a taxonomic
identifier from a taxonomy). 

### The tag values

Values can be strings, integers, floats, or boolean values. Values can also
be of composite types but with some limitations compared to the
[JSON](https://en.wikipedia.org/wiki/JSON) format. In {{% obitools4 %}} annotations
it is not possible to nest composite types. A list cannot contain a list or a map.

A list is an ordered set of values, in this case a set of integer values:

```json
[1,3,2,12]
```

A map is a set of values indexed by a key, which is a string. As an example, here is a
map of integer values:

```json
{"toto":4,"titi":10,"tutu":1}
```

Maps are notably used by {{< obi obiuniq >}} to aggregate information collected
from the merged sequence records.

```fasta
>my_seq_O1 {"merged_sample":{"sample1":45,"sample_2":33}}
gctagctagctgtgatgtcgtagttgctgatgctagtgctagtcgtaaaaaat
```

Using the {{< obi obiannotate >}} command, it is possible to edit these annotations, adding new ones, deleting others, renaming keys or changing values. 

> [!CAUTION]
> You are free to add, edit and delete even the {{% obitools4 %}}
> reserved keys to mimic the results of an {{% obitools4 %}} commands. But beware
> of the impact of these manually modified values. It is best not to
> modified reserved annotation keys.

## {{% obitools4 %}} and the taxonomic information

One of the advantages of {{% obitools %}} is their ability to handle taxonomy annotations.
Each sequence in a sequence file can be individually taxonomically annotated by adding a `taxid` tag. Although several annotation tags can be related to taxonomic information, only the `taxid` tag really matters.

The tags associated with taxonomic annotations fall into three categories
- `taxid` The main taxonomic annotation
- Any tag ending with the `_taxid` suffix contains secondary taxid annotations, such as `family_taxid` which contains the taxid at the family level.
- Text tags ending with `_name`, such as `scientific_name` or `family_name`, which contain the textual representation corresponding to the taxids.

The last category is intended solely to facilitate the user's task, to make taxonomic information more comprehensible on a human level. The second category is also intended to help the user, bearing in mind that any taxonomy-based selection implemented by {{% obitools4 %}} is based solely on the `taxid` tag.

Taxonomic identifiers, *taxid*, are short strings that uniquely identify a taxon within a taxonomy. It is important to rely on *taxid* rather than Latin names to identify taxa, as several taxa share the same Latin name (*e.g.* Vertebrata is also a genus of red algae).

For example, in the [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy), the species *Homo sapiens* has the taxid *9606* and belongs to the genus *Homo*, which has the taxid *9605*. Although all NCBI taxids are numeric, the {{% obitools4 %}} treats them as strings: `"9606"` and `"9605"`.

The one way to specify a taxid to obitools is to provide this short string: `"9606"` or `"9605"`.

If the `--taxonomy` or `-t` option, which takes a filename as parameter, is used when calling a {{% obitools %}} command, the corresponding taxonomy will be loaded and every taxid present in a file (`taxid` and `*_taxid` tags) will be checked against the taxonomy. To download a copy of the [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy) you can use the {{< obi obitaxonomy >}} command:

```bash
obitaxonomy --download-ncbi --out ncbitaxo.tgz
```

This will create a new `ncbitaxo.tgz` file containing a local copy of the complete taxonomy.

The first consequence of this check is that all taxa are rewritten in their long form. `"9606"` becomes `"taxon:9606 [Homo sapiens]@species"`:

- `taxon`: is the taxonomy code (`TAXOCOD` is `taxon` for the [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy)).
- `9606`: is the taxid
- `Homo sapiens`: is the scientific name
- `species`: is the taxonomic rank

So the long form of a taxid can be written as `"TAXOCOD:TAXID [SCIENTIFIC NAME]@RANK"`.

If you look at the following files, you can see that the `taxid` tag is set to `62275` and `9606` for the first and second sequences respectively:

{{< code "two_sequences.fasta" "fasta" true >}}

If you use {{< obi obiconvert >}} without specifying a taxonomy, its only action is to convert potential old numeric taxids (`62275` and `9606`) to their string equivalents (`"62275"` and `"9606"`).

```bash
obiconvert two_sequences.fasta
```
```fasta
>AB061527 {"count":1,"definition":"Sorex unguiculatus mitochondrial NA, complete genome.","family_name":"Soricidae","family_taxid":"9376","genus_name":"Sorex","genus_taxid":"9379","obicleandb_level":"family","obicleandb_trusted":2.2137847111025621e-13,"species_name":"Sorex unguiculatus","species_taxid":"62275","taxid":"62275"}
ttagccctaaacttaggtatttaatctaacaaaaatacccgtcagagaactactagcaat
agcttaaaactcaaaggacttggcggtgctttatatccct
>AL355887 {"count":2,"definition":"Human chromosome 14 NA sequence BAC R-179O11 of library RPCI-11 from chromosome 14 of Homo sapiens (Human)XXKW HTG.; HTGS_ACTIVFIN.","family_name":"Hominidae","family_taxid":"9604","genus_name":"Homo","genus_taxid":"9605","obicleandb_level":"genus","obicleandb_trusted":0,"species_name":"Homo sapiens","species_taxid":"9606","taxid":"9606"}
ttagccctaaactctagtagttacattaacaaaaccattcgtcagaatactacgagcaac
agcttaaaactcaaaggacctggcagttctttatatccct
```

If the previously downloaded [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy) is specified to {{<obi obiconvert >}}, the output of the command will be as follows. You will notice that, this time, the taxa are given in their long form. The scientific name and taxonomic rank are also given.

```bash
obiconvert -t ncbitaxo.tgz two_sequences.fasta
```
```fasta
>AB061527 {"count":1,"definition":"Sorex unguiculatus mitochondrial NA, complete genome.","family_name":"Soricidae","family_taxid":"taxon:9376 [Soricidae]@family","genus_name":"Sorex","genus_taxid":"taxon:9379 [Sorex]@genus","obicleandb_level":"family","obicleandb_trusted":2.2137847111025621e-13,"species_name":"Sorex unguiculatus","species_taxid":"taxon:62275 [Sorex unguiculatus]@species","taxid":"taxon:62275 [Sorex unguiculatus]@species"}
ttagccctaaacttaggtatttaatctaacaaaaatacccgtcagagaactactagcaat
agcttaaaactcaaaggacttggcggtgctttatatccct
>AL355887 {"count":2,"definition":"Human chromosome 14 NA sequence BAC R-179O11 of library RPCI-11 from chromosome 14 of Homo sapiens (Human)XXKW HTG.; HTGS_ACTIVFIN.","family_name":"Hominidae","family_taxid":"taxon:9604 [Hominidae]@family","genus_name":"Homo","genus_taxid":"taxon:9605 [Homo]@genus","obicleandb_level":"genus","obicleandb_trusted":0,"species_name":"Homo sapiens","species_taxid":"taxon:9606 [Homo sapiens]@species","taxid":"taxon:9606 [Homo sapiens]@species"}
ttagccctaaactctagtagttacattaacaaaaccattcgtcagaatactacgagcaac
agcttaaaactcaaaggacctggcagttctttatatccct
```

If the check reveals that taxid is not present in the taxonomy, a warning is issued by the {{% obitools4 %}}.
As example, the {{< obi obiconvert >}} command applied to the following file:

{{< code "four_sequences.fasta" "fasta" true >}}

displays the following warning:

```bash
obiconvert -t ncbitaxo.tgz four_sequences.fasta
```
```
INFO[0000] Number of workers set 16                     
INFO[0000] Found 1 files to process                     
INFO[0000] four_sequences.fasta mime type: text/fasta   
INFO[0000] On output use JSON headers                   
INFO[0000] Output is done on stdout                     
INFO[0000] Data is writen to stdout                     
INFO[0000] NCBI Taxdump Tar Archive detected: ncbitaxo.tgz 
INFO[0000] Loading Taxonomy nodes                       
INFO[0003] 2653519 Taxonomy nodes read                  
INFO[0003] Loading Taxon names                          
INFO[0005] 2653519 taxon names read                     
INFO[0005] Loading Merged taxa                          
INFO[0005] 88919 merged taxa read                       
WARN[0005] AF023201: Taxid 67561 has to be updated to taxon:305503 [Lepidomeda copei]@species 
WARN[0005] JN897380: Taxid 1114968 has to be updated to taxon:2734678 [Neotrypaea thermophila]@species 
WARN[0005] KC236422: Taxid: 5799994 is unknown from taxonomy (Taxid 5799994 is not part of the taxonomy NCBI Taxonomy) 
```

Of the four sequences, only the first sequence has a taxid known from the [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy). The other three sequences have taxids that are not part of the [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy). In fact, the second and third sequences have taxids that were known in the [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy), but are now transferred to other taxids. The fourth sequence has a taxid that is actually unknown in the [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy). 

Since only the first sequence *AY189646* has a known taxid in the output, the taxids are rewritten in long form for this sequence only. For the other three sequences, the taxids are left as they were before. Nevertheless, all four sequences are present in the output.

```fasta
>AY189646 {"count":1,"definition":"Homo sapiens clone arCan119 12S ribosomal RNA gene, partial sequence; mitochondrial gene for mitochondrial product.","species_name":"Homo sapiens","taxid":"taxon:9606 [Homo sapiens]@species"}
ttagccctaaacctcaacagttaaatcaacaaaactgctcgccagaacactacgrgccac
agcttaaaactcaaaggacctggcggtgcttcatatccct
>AF023201 {"count":1,"definition":"Snyderichthys copei 12S ribosomal RNA gene, mitochondrial gene for mitochondrial RNA, complete sequence.","species_name":"Snyderichthys copei","taxid":"67561"}
tcagccataaacctagatgtccagctacagttagacatccgcccgggtactacgagcatt
agcttgaaacccaaaggacctgacggtgccttagaccccc
>JN897380 {"count":1,"definition":"Nihonotrypaea thermophila mitochondrion, complete genome.","species_name":"Nihonotrypaea thermophila","taxid":"1114968"}
tagccttaacaaacatactaaaatattaaaagttatggtctctaaatttaaaggatttgg
cggtaatttagtccag
>KC236422 {"count":1,"definition":"Nihonotrypaea japonica mitochondrion, complete genome.","species_name":"Nihonotrypaea japonica","taxid":"5799994"}
cagctttaacaaacatactaaaatattaaaagttatggtctctaaatttaaaggatttgg
cggtaatttagtccag
```

If the `--update-taxid` option is used, the {{% obitools4 %}} command will update the taxids of sequences that have been transferred to other taxids. When executed on the same sequence file, the same three warnings appear, but the first two warnings announce that the taxids have been updated.

```bash
obiconvert -t ncbitaxo.tgz --update-taxid four_sequences.fasta
```
```
WARN[0007] AF023201: Taxid: 67561 is updated to taxon:305503 [Lepidomeda copei]@species 
WARN[0007] JN897380: Taxid: 1114968 is updated to taxon:2734678 [Neotrypaea thermophila]@species 
WARN[0007] KC236422: Taxid: 5799994 is unknown from taxonomy (Taxid 5799994 is not part of the taxonomy NCBI Taxonomy) 
```

In the output, the taxids are rewritten in long format for the first sequence as before, but also for the next two sequences, taking into account their updated taxids.

```fasta
>AY189646 {"count":1,"definition":"Homo sapiens clone arCan119 12S ribosomal RNA gene, partial sequence; mitochondrial gene for mitochondrial product.","species_name":"Homo sapiens","taxid":"taxon:9606 [Homo sapiens]@species"}
ttagccctaaacctcaacagttaaatcaacaaaactgctcgccagaacactacgrgccac
agcttaaaactcaaaggacctggcggtgcttcatatccct
>AF023201 {"count":1,"definition":"Snyderichthys copei 12S ribosomal RNA gene, mitochondrial gene for mitochondrial RNA, complete sequence.","species_name":"Snyderichthys copei","taxid":"taxon:305503 [Lepidomeda copei]@species"}
tcagccataaacctagatgtccagctacagttagacatccgcccgggtactacgagcatt
agcttgaaacccaaaggacctgacggtgccttagaccccc
>JN897380 {"count":1,"definition":"Nihonotrypaea thermophila mitochondrion, complete genome.","species_name":"Nihonotrypaea thermophila","taxid":"taxon:2734678 [Neotrypaea thermophila]@species"}
tagccttaacaaacatactaaaatattaaaagttatggtctctaaatttaaaggatttgg
cggtaatttagtccag
>KC236422 {"count":1,"definition":"Nihonotrypaea japonica mitochondrion, complete genome.","species_name":"Nihonotrypaea japonica","taxid":"5799994"}
cagctttaacaaacatactaaaatattaaaagttatggtctctaaatttaaaggatttgg
cggtaatttagtccag
```

If the `--fail-on-taxonomy` option is used, the {{% obitools4 %}} command will abort if it encounters a taxid that is not in the [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy). If it is run on the same sequence file, you will see the error message that stops the command when reading the last sequence annotated with a taxid that is not in the [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy). If the `--update-taxid` option was not used, the command would also have been aborted on the sequence AF023201.

```bash
obiconvert -t ncbitaxo.tgz --update-taxid --fail-on-taxonomy four_sequences.fasta
```
```
WARN[0007] AF023201: Taxid: 67561 is updated to taxon:305503 [Lepidomeda copei]@species 
WARN[0007] JN897380: Taxid: 1114968 is updated to taxon:2734678 [Neotrypaea thermophila]@species 
FATA[0007] KC236422: Taxid: 5799994 is unknown from taxonomy (Taxid 5799994 is not part of the taxonomy NCBI Taxonomy) 
```

To remove invalid taxids from your file, you can use {{< obi obigrep >}} to keep only sequences with a valid taxid.
This is the role of the `--valid-taxid' option.

```bash
obigrep -t ncbitaxo.tgz \
        --update-taxid \
        --valid-taxid four_sequences.fasta
```
```
WARN[0006] KC236422: Taxid: 5799994 is unknown from taxonomy (Taxid 5799994 is not part of the taxonomy NCBI Taxonomy) 
WARN[0006] AF023201: Taxid: 67561 is updated to taxon:305503 [Lepidomeda copei]@species 
WARN[0006] JN897380: Taxid: 1114968 is updated to taxon:2734678 [Neotrypaea thermophila]@species 
```

If the same three warnings occur, you will notice that only the first three sequences are preserved in the resulting file.

```fasta
>AY189646 {"count":1,"definition":"Homo sapiens clone arCan119 12S ribosomal RNA gene, partial sequence; mitochondrial gene for mitochondrial product.","species_name":"Homo sapiens","taxid":"taxon:9606 [Homo sapiens]@species"}
ttagccctaaacctcaacagttaaatcaacaaaactgctcgccagaacactacgrgccac
agcttaaaactcaaaggacctggcggtgcttcatatccct
>AF023201 {"count":1,"definition":"Snyderichthys copei 12S ribosomal RNA gene, mitochondrial gene for mitochondrial RNA, complete sequence.","species_name":"Snyderichthys copei","taxid":"taxon:305503 [Lepidomeda copei]@species"}
tcagccataaacctagatgtccagctacagttagacatccgcccgggtactacgagcatt
agcttgaaacccaaaggacctgacggtgccttagaccccc
>JN897380 {"count":1,"definition":"Nihonotrypaea thermophila mitochondrion, complete genome.","species_name":"Nihonotrypaea thermophila","taxid":"taxon:2734678 [Neotrypaea thermophila]@species"}
tagccttaacaaacatactaaaatattaaaagttatggtctctaaatttaaaggatttgg
cggtaatttagtccag
```

## Manipulating paired sequence files with {{% obitools4 %}}

Sequencing machines, particularly Illumina machines, produce paired-read data sets.
The two paired reads correspond to two sequencings of the same DNA molecule from either end. They are commonly referred to as 'forward reads' and 'reverse reads'.

Today, these paired reads are provided to the biologist in the form of two {{% fastq %}} files.
These files assume that the two reads corresponding to the sequencing of the same DNA molecule are in the same position in the two files. If the data manipulations that delete or insert sequences in these files are not performed symmetrically, it is very likely that they will be out of phase, so that the two sequences will no longer be in the same position.

{{< code "forward.fastq" fastq true >}}
  
{{< code "reverse.fastq" fastq true >}}

In the two files above, the first sequence of the [`forward.fastq`](forward.fastq) file with the ID `M01334:147:000000000-LBRVD:1:1101:14968:1570` is paired with the first sequence of the [`reverse.fastq`](reverse.fastq) file with the same ID `M01334:147:000000000-LBRVD:1:1101:14968:1570`, not because they have the same identifier, but because they are both the first sequence of their respective files.

Some of the {{% obitools4 %}} commands, such as {{< obi obiconvert >}}, {{< obi obigrep >}} or {{< obi obiannotate >}} offer a `--paired-with` option. This option takes a filename as a parameter. It tells the {{% obitools4 %}} command that the file given as an argument is paired with the file being processed. Therefore, the {{% obitools4 %}} commands will process both the forward and reverse files in parallel.

As the `--paired-with` option allows the {{% obitools4 %}} command to process two files, it also produces two result files. As a result, standard output cannot be used to return the results. Therefore, when using the `--paired-with` option, the `--out` option must be used. The `--out` option takes a filename as a parameter and tells the {{% obitools4 %}} command to write the result to the specified file. As a single filename is given, the {{% obitools4 %}} command modifies this filename by adding a suffix `_R1` or `_R2` to create two filenames.

```bash
obiconvert --paired-with reverse.fastq \
           --out result.fasta \
           --fasta-output \
           forward.fastq 
```

This command processes the [`forward.fastq`](forward.fastq) and the [`reverse.fastq`](reverse.fastq) as two paired files. It then converts them into two fasta files named [`result_R1.fasta`](result_R1.fasta) and [`result_R2.fasta`](result_R2.fasta) for the forward and reverse reads respectively.

```bash
ls -l *.fast?
```
```
-rw-r--r--@ 1 myself  staff  1504  8 mar 15:09 forward.fastq
-rw-r-----@ 1 myself  staff   964  8 mar 17:36 result_R1.fasta
-rw-r-----@ 1 myself  staff   964  8 mar 17:36 result_R2.fasta
-rw-r--r--@ 1 myself  staff  1504  8 mar 15:09 reverse.fastq
```

The `ls` command is used here to see the results of the above {{< obi obiconvert >}} command, with the two resulting files and their names built by adding the suffixes `_R1` or `_R2` at the end of the filename just before the extension.
<!--  -->