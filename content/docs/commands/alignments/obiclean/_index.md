---
archetype: "command"
title: "obiclean"
date: 2025-02-10
command: "obiclean"
category: alignments
url: "/obitools/obiclean"
weight: 10
---

# `obiclean`: a PCR aware denoising algorithm

## Description 

{{< obi obiclean >}} implements the denoising algorithms provided by {{% obitools4 %}}.

The original {{< obi obiclean >}} algorithm is a denoising (clustering) algorithm designed to filter out potential PCR-generated spurious sequences. 

This new version of {{< obi obiclean >}} adds two additional filters:
- A filter to set a threshold for the minimum number of samples a sequence must be present in to be retained (default: 1, can be changed using the `--min-sample-count` option). 
- A naive chimera detection algorithm. This is an experimental feature. The algorithm is not run by default. It can be enabled with the `--dectect-chimera' option.

{{< obi obiclean >}} can run in two modes:

- A tagging mode where no sequences are actually removed from the data set, they are just tagged. It is your responsibility to remove the sequences you don't want based on these tags and your filter rules, using other {{% obitools%}} commands.
- A filter mode where sequences that are considered to be false sequences by {{< obi obiclean >}} are removed from the dataset.


## The clustering algorithm

The algorithm implemented in {{< obi obiclean >}} aims to remove punctual PCR errors (nucleotide substitutions, insertions or deletions). Therefore, it is not applied to the whole data set at once, but to each sample (PCR) independently. 

Two pieces of information are used:

- The 'count' attributes of the sequence set.
- The pairwise sequence similarities calculated in each set of sequences belonging to a sample.
  
The result of the {{< obi obiclean >}} algorithm is the classification of each sequence set into one of three classes: `head`, `internal` or `singleton`.

Consider two sequences *S1* and *S2* occurring in the same sample (PCR). *S1* is a sequence variant of S2* if and only if:

- The ratio of the number of the occurrences of *S1* and *S2* is smaller than the parameter *R*. 
    {{< katex display=true >}}
    \frac{Count_{S1}}{Count_{S2}} < R
    {{< /katex >}}
    The default value of *R* is 1 and can be set between 0 and 1 using the `-r` option.
        
- The number of differences between *S1* and *S2* when aligning these sequences is less than a maximum number of differences that can be specified with the `-d` option (default = 1 error).
    {{< katex display=true >}}
    dist(S1,S2) < d
    {{< /katex >}}

This relation *is a sequence variant of* defines a [directed acyclic graph (DAG)](https://en.wikipedia.org/wiki/Directed_acyclic_graph) on the sequences belonging to a sample.
{{< obi obiclean >}} gives access to this graph using the `--save-graph` option. Below an example of command to run {{< obi obiclean >}} and produce the files 

```bash 
obiclean -r 0.1 \
         -Z \
         --save-graph sample-graph  \
         wolf_uniq.fasta.gz > wolf_clean.fasta.gz
```

- The `-r` option is used to set the ratio threshold between the sequence abundances.
- The `--save-graph` option asks {{< obi obiclean >}} to save the graph defined by the *"is a sequence variant of"* relation in a file per sample, using the [GML](https://en.wikipedia.org/wiki/Graph_Modelling_Language) format, in the directory named `sample-graph`.

  ```
  . 📂 sample-graph
  ├── 📄 13a_F730603.gml
  ├── 📄 15a_F730814.gml
  ├── 📄 26a_F040644.gml
  └── 📄 29a_F260619.gml
  ```

- The `-Z` option is for compressing the output file.

The [yEd](https://www.yworks.com/products/yed) program allows visualizing the graph described for each sample.



{{< fig src="13a_F730603.svg" 
    title="obiclean graph for the sample 13a_F730603"
    caption="Each dot represents a sequence. The surface of the dot is proportional to the abundance of the sequence in the sample. The arrows represent the relation *is a sequence variant of*, starting from the derived sequence to its supposed original version. The number on each arrow indicates the distance between both sequences, here 1 everywhere. That sample corresponds to the diet analysis of a wolf. Therefore, one true sequence (the prey) is expected. It corresponds to the big blue circle."
>}}

From the graph, a sequence *S* can be classified as follows:

-   `head`: 
    -   there exists **at least one** sequence in the
        dataset that is a variant of *S*
    -   there exists **no** sequence record in the dataset such
        that *S* is a variant of this sequence

-   `internal`:
    -   there exists **at least one** sequence record in the
        dataset such that *S* is a variant of this sequence
        record

-  `singleton`:
    -   there exists **no** sequence record in the dataset that
        is a variant of *S*
    -   there exists **no** sequence record in the dataset such
        that *S* is a variant of this sequence record


Finally, each sequence record is annotated with three new attributes
`head`, `internal` and `singleton`. The attribute values are the numbers
of samples in which the sequence record has been classified in this
manner.

## Synopsis

```bash
obiclean [--batch-size <int>] [--compressed|-Z] [--debug]
         [--distance|-d <int>] [--ecopcr] [--embl] [--fasta] [--fasta-output]
         [--fastq] [--fastq-output] [--force-one-cpu] [--genbank] [--head|-H]
         [--help|-h|-?] [--input-OBI-header] [--input-json-header]
         [--json-output] [--max-cpu <int>] [--min-eval-rate <int>]
         [--min-sample-count <int>] [--no-order] [--no-progressbar]
         [--out|-o <FILENAME>] [--output-OBI-header|-O]
         [--output-json-header] [--pprof] [--pprof-goroutine <int>]
         [--pprof-mutex <int>] [--ratio|-r <float64>] [--sample|-s <string>]
         [--save-graph <string>] [--save-ratio <string>] [--skip-empty]
         [--solexa] [--version] [<args>]
```

## Options

#### {{< obi obiclean >}} specific options

- {{< cmd-option name="min-sample-count" param="INTEGER" >}}
  Minimum number of samples a sequence must be present in to be considered in the analysis. (default: 1)  
  {{< /cmd-option >}}

- {{< cmd-options/alignments/distance >}}
- {{< cmd-options/alignments/head >}}
- {{< cmd-options/alignments/min-eval-rate >}}
- {{< cmd-options/alignments/ratio >}}
- {{< cmd-options/alignments/sample >}}
- {{< cmd-options/alignments/save-graph >}}
- {{< cmd-options/alignments/save-ratio >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obiclean --help
```
