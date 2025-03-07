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

{{% obitools %}} are not a metabarcoding data analysis pipeline, but a set of tools for developing customized analysis, while avoiding the black-box effect of a ready-to-use pipeline. A particular effort in the development of {{% obitools4 %}} has been to use data formats that can be easily interfaced with other software.

{{% obitools %}} correspond to a set of UNIX commands that are used from a command line interface, also named a terminal, to perform various tasks on DNA sequence files. A UNIX command can be considered as a process that takes a set of inputs and produces a set of outputs.

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

Most {{% obitools %}} take a single input file and produce a single output file. Among the inputs, one has a special status, the standard input (*stdin*). Symmetrically, there is the standard output (*stdout*). By default, as any other UNIX command, the {{% obitools %}} read their data from *stdin* and write their results to *stdout*.

{{< mermaid class="workflow" >}}
graph LR
  A@{ shape: doc, label: "stdin" }
  C[Unix command]
  D@{ shape: doc, label: "stdout" }
  A --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}

If nothing is specified, the UNIX system connects standard input to the terminal keyboard and standard output to the terminal screen. So if you run, as example, the {{< obi obiconvert >}} command in your terminal without any arguments, it will appear to stop and do nothing, when in fact it is waiting for you to type something on the keyboard. To stop it, just press *Ctrl+D* or *Ctrl+C*. *Ctrl+D* terminates the input and stops the program. *Ctrl+C* kills the program.

## Specifying the input data

{{% obitools %}} are dedicated to process DNA sequence files. Thus, most of them accept as inputs DNA sequence files. They can be formatted in the most common sequence file formats, {{% fasta %}}, {{% fastq %}}, {{% embl %}} and {{% genbank %}} flat files. Data can also be provided as CSV files. The {{% obitools %}} usually recognize the file format of the input data, but options are provided to force a specific format (*i.e.* `--fasta`, `--fastq`, `--genbank`, `--embl`).

The most common way to specify the file containing the DNA sequences to be processed is to specify its name as an argument. Here is an example using {{< obi obicount >}} to count the number of DNA sequences in a file named `my_file.fasta`.

```bash
obicount my_file.fasta
```

But it is also possible to pass the data using the Unix redirection mechanism (*i.e.* `>` and `<`, [more details](https://en.wikipedia.org/wiki/Redirection_(computing))).

```bash
obicount < my_file.fasta
```

The {{% obitools %}} can also be used to process a set of files. In this case, the {{% obitools %}} will process the files in the order in which they appear on the command line.

```bash
obicount my_file1.fasta my_file2.fasta my_file3.fasta
```

The wildcard character (*i.e.* `*`) can be used to specify a set of files to be processed.

```bash
obicount my_file*.fasta
```

If the files are in a subdirectory, the directory name can be specified, without the need to specify any file name. In that case, the {{% obitools %}} will process all the sequence files present in the subdirectory. The search for the sequence files is done recursively in the specified directory and all its subdirectories.

```bash
obicount my_sub_directory
```

The files considered as DNA sequence files are those with the file extension `.fasta`, `.fastq`, `.genbank` or `.embl`, `.seq` or `.dat`. Files with the second extension `.gz` (*e.g.* `.fasta.gz`) are also considered to be DNA sequence files and are processed without having to uncompressed them.

Imagine a folder called `Genbank` which contains a complete copy of the Genbank database organized into subdirectories, one per division. Each division subdirectory contains a set of {{% fasta %}} compressed (`.gz`) files.

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

By default, {{% obitools %}} write their output to standard output (*stdout*), which means that the results of a command are printed to the terminal screen. 

Most {{% obitools %}} produce sequence files as output. The output sequence file is in {{% fasta %}} or {{% fastq %}} format, depending on whether it contains quality scores ({{% fastq %}}) or not ({{% fasta %}}). The output format for sequence files can be forced using the `--fasta-output` or `--fastq-output` options. If the `--fastq-output` option is used for a data set without quality information, a default quality score of 40 will be used for each nucleotide. A third option is the `--json-output` option, which outputs the data in a {{% json %}} format.

Except for {{< obi obisummary >}}, the {{% obitools %}} which produce other
types of data output them in CSV format. The {{< obi obisummary >}} command
returns its results in [JSON](https://en.wikipedia.org/wiki/JSON) or
[YAML](https://en.wikipedia.org/wiki/YAML) format.

The {{< obi obicomplement >}} command computes the reverse-complement of the DNA sequences provided as input. 

{{< code "two_sequences.fasta" fasta true >}} 

If the `two_sequences.fasta` file is processed with the {{< obi obicomplement >}} command, without indicating the output file name, the result is written to terminal screen.

```bash
obicomplement two_sequences.fasta
```
{{< code "two_sequences_comp.fasta" fasta false >}} 

To save the results in a file, two possible options are available. The first one is to redirect the output to a file, as in the following example.

```bash
obicomplement two_sequences.fasta > two_sequences_comp.fasta
```

The second option is to use the `--out` option.

```bash
obicomplement two_sequences.fasta --out two_sequences_comp.fasta
```

Both methods will produce the same result, a file named <a href="two_sequences_comp.fasta" download="two_sequences_comp.fasta">`two_sequences_comp.fasta`</a> containing the reverse-complement of the DNA sequences contained in <a href="two_sequences.fasta" download="two_sequences.fasta">`two_sequences.fasta`</a>.

## Combining {{% obitools %}} commands using pipes

As the {{% obitools %}} are UNIX commands, and their default behaviour is to read their input from *stdin* and write their output to *stdout*, it is possible to combine them using the Unix pipe mechanism (*i.e.* `|`). For example, you can reverse-complement the file `two_sequences.fasta` with the command {{% obi obicomplement %}}, and then count the number of DNA sequences in the resulting file with the command {{% obi obicount %}}, without saving the intermediate results, by linking the *stdout* of {{% obi obicomplement %}} to the *stdin* of {{% obi obicount %}}.
<!-- I suggest to use obigrep instead of obicomplement as the first command. obigrep can be to select sequences longer (or shorter) than xxx bp. As a consequence, the file two_sequence.fasta should be changed -->


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

The {{% obitools %}} provide several tools to perform computations on the sequences. The result of such a computation may be the selection of a subset of the input sequences, a modification of the sequences themselves, or it may only lead to the estimation of some properties of the sequences. In the latter case, the {{% obitools %}} stores the estimated properties of the associated sequence in a {{% fasta %}} or {{% fastq %}} file. To achieve this, the {{% obitools %}} add structured information in the form of a JSON map to the header of each sequence. The JSON map allows the results of calculations to be stored in key-value pairs. Each {{% obitools %}} command adds one or more key-value pairs to the JSON map as needed to annotate a sequence. Below is an example of a {{% fasta %}} formatted sequence with a JSON map added to its header containing three key-value pairs: `count` associated with the value `2`, `is_annotated` associated with the value `true` and `xxxx` associated with the value `yyyy`.

```
>sequence1 {"count": 2, "is_annotated": true, "xxxx": "yyy"}
cgacgtagctgtgatgcagtgcagttatattttacgtgctatgtttcagtttttttt
fdcgacgcagcggag
```

### The key names

Keys can be any string. Their names are case-sensitive. The keys `count`,
`Count` and `COUNT` are all considered to different keys. Some key names are
reserved by the {{% obitools %}} and have special meanings (*e.g.* `count`
contains if present an integer value indication how many times that sequence has
been observed, `taxid` that contains string value corresponding to a taxonomic
identifier from a taxonomy). 

### The tag values

The values can be any string, integer, float, or boolean values. Values can also
be of composite types but with some limitations compared to the
[JSON](https://en.wikipedia.org/wiki/JSON) format. In {{% obitools4 %}} annotations
you are not allowed to nest composite type. A list cannot contain a list or a map.

A list is an ordered set of values, here as example a set of integer values:

```json
[1,3,2,12]
```

A map is a set of values indexed by a key which is a string. Here as example a
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

Using the {{< obi obiannotate >}} command, it is possible to edit these annotations,
by adding some new ones, deleting some others, renaming keys or changing values. 

> [!CAUTION]
> You are free to add, edit and delete even the {{% obitools4 %}}
> reserved keys to mimic the results of an {{% obitools4 %}} commands. But take
> care of the impact of such manually modified values. It is of better usage, to
> not change reserved annotation keys.

## {{% obitools4 %}} and the taxonomic information

## Manipulating paired sequence files with {{% obitools4 %}}

Notably Illumina sequencing machines are providing paired-sequence data set.
The two paired reads correspond to two sequencing of the same DNA molecule from both
its ends. We are commonly speaking of the forward and reverse reads.

Today, such paired reads are provided to the biologist as two {{% fastq %}} files.
The assumption on these files is that the two reads corresponding to
sequencing of the same DNA molecule occur in both the file at the same rank. If
manipulations of the data leading to the deletion or insertion of sequences in
those files are not done conjointly, it is highly probable that they will run
out of phasing, leading the both sequence not anymore occurring at the same
rank.

{{< code "forward.fastq" fastq true >}}
  
{{< code "reverse.fastq" fastq true >}}

In the two files above, the first sequence of the [`forward.fastq`](forward.fastq) file having the id `M01334:147:000000000-LBRVD:1:1101:14968:1570` will be paired with the first sequence of the [`reverse.fastq`](reverse.fastq) file having the same id `M01334:147:000000000-LBRVD:1:1101:14968:1570`, not because they have the same identifier but because they are both the first sequence of their respective files.
