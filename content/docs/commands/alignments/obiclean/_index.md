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
- A naive chimera detection algorithm. This is an experimental feature. It is not run by default. It can be enabled with the `--dectect-chimera` option.

{{< obi obiclean >}} can run in two modes:

- A tagging mode where no sequences are actually removed from the data set, they are just tagged. It is your responsibility to remove the sequences you don't want based on these tags and your filter rules, using other {{% obitools %}} commands.
- A filter mode in which sequences that are considered to be false sequences by {{< obi obiclean >}} are removed from the data set.

{{< obi obiclean >}} relies on per-sample sequence abundance information to apply its algorithms. Therefore, the input data set must first be dereplicated using the {{< obi obiuniq >}} command with the `-m sample` option.

{{< mermaid class="workflow" >}}
graph TD
  A@{ shape: doc, label: "my_sequences_uniq.fasta" }
  C[obiclean]
  D@{ shape: doc, label: "my_sequences_clean.fasta" }
  A --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}



## The clustering algorithm

The algorithm implemented in {{< obi obiclean >}} aims to remove punctual PCR errors (nucleotide substitutions, insertions or deletions). Therefore, it is not applied to the whole data set at once, but to each sample (PCR) independently. 

Two pieces of information are used:

- The 'count' attributes of the sequence set.
- The pairwise sequence similarities calculated in each set of sequences belonging to a sample.
  
The result of the {{< obi obiclean >}} algorithm is the classification of each sequence set into one of three classes: `head`, `internal` or `singleton`.

Consider two sequences *S1* and *S2* that occur in the same sample (PCR). *S1* is a sequence variant of S2* if and only if

- The ratio of the number of occurrences of *S1* and *S2* is less than the parameter *R*. 
    {{< katex display=true >}}
    \frac{Count_{S1}}{Count_{S2}} < R
    {{< /katex >}}
    The default value of *R* is 1 and can be set between 0 and 1 using the `-r` option.
        
- The number of differences between *S1* and *S2* when aligning these sequences is less than a maximum number of differences that can be specified with the `-d` option (default = 1 error).
    {{< katex display=true >}}
    dist(S1,S2) < d
    {{< /katex >}}

This relation, *is a sequence variant of*, defines a [Directed Acyclic Graph (DAG)](https://en.wikipedia.org/wiki/Directed_acyclic_graph) on the sequences belonging to a sample.
{{< obi obiclean >}} gives access to this graph using the `--save-graph` option. The following is an example of a command to run {{< obi obiclean >}} and create the graph files:

```bash 
obiclean -r 0.1 \
         -Z \
         --save-graph sample-graph  \
         wolf_uniq.fasta.gz > wolf_clean.fasta.gz
```

- The `-r` option is used to set the ratio threshold between the sequence abundances.
- The `--save-graph` option tells {{< obi obiclean >}} to save the graph defined by the *"is a sequence variant of"* relation in a file per sample, using the [GML](https://en.wikipedia.org/wiki/Graph_Modelling_Language) format, in the directory named `sample-graph`.

<pre>
  . 📂 sample-graph
  ├── 📄 <a href="sample-graph/13a_F730603.gml" dowload="13a_F730603.gml">13a_F730603.gml</a>
  ├── 📄 <a href="sample-graph/15a_F730814.gml" dowload="15a_F730814.gml">15a_F730814.gml</a>
  ├── 📄 <a href="sample-graph/26a_F040644.gml" dowload="26a_F040644.gml">26a_F040644.gml</a>
  └── 📄 <a href="sample-graph/29a_F260619.gml" dowload="29a_F260619.gml">29a_F260619.gml</a>
</pre>

- The `-Z` option is used to compress the output file.

The program [yEd] (https://www.yworks.com/products/yed) allows you to visualize the graph described for each sample.


{{< fig src="13a_F730603.svg" 
    title="obiclean graph for the sample 13a_F730603"
    caption="Each dot represents one sequence. The area of the dot is proportional to the abundance of the sequence in the sample. The arrows represent the relationship *is a sequence variant of*, starting from the derived sequence to its presumed original version. The number on each arrow indicates the distance between the two sequences, here 1 everywhere. This sample corresponds to the dietary analysis of a wolf. Therefore, one true sequence (the prey) is expected. It corresponds to the big blue circle."
>}}

From the graph topology, each sequence *S* is classified into one of the following three classes

- `head`
    - There is **at least one** sequence in the sample that is a variant of *S*.
    - There is **no** sequence in the sample such that *S* is a variant of that sequence.

- `internal`
    - There is **at least one** sequence in the sample such that *S* is a variant of this sequence.

- `singleton`
    - There is **no** sequence in the sample that is a variant of *S*.
    - There is **no** sequence in the sample that is a variant of this sequence.

This class is sample dependent, as a graph is built per sample and recorded in the `obiclean_status` tag, as shown below for one of the sequences extracted from the result file [`wolf_clean.fasta.gz`](wolf_clean.fasta.gz).

```fasta
>HELIUM_000100422_612GNAAXX:7:91:7524:17193#0/1_sub[28..127] {"ali_dir":"left","ali_length":62,"count":8,"direction":"reverse","experiment":"wolf_diet","forward_match":"ttagataccccactatgc","forward_mismatches":0,"forward_primer":"ttagataccccactatgc","merged_sample":{"15a_F730814":5,"29a_F260619":3},"mode":"alignment","obiclean_head":false,"obiclean_headcount":0,"obiclean_internalcount":2,"obiclean_mutation":{"HELIUM_000100422_612GNAAXX:7:22:2603:18023#0/1_sub[28..127]":"(a)->(g)@26"},"obiclean_samplecount":2,"obiclean_singletoncount":0,"obiclean_status":{"15a_F730814":"i","29a_F260619":"i"},"obiclean_weight":{"15a_F730814":5,"29a_F260619":3},"reverse_match":"tagaacaggctcctctag","reverse_mismatches":0,"reverse_primer":"tagaacaggctcctctag","seq_a_single":46,"seq_b_single":46}
ttagccctaaacacaagtaattaatgtaacaaaattattcgccagagtactaccggcaat
agcttaaaactcaaaggacttggcggtgctttataccctt
```

### Tags added to each sequence by the clustering algorithm

- `obiclean_head`: `true` if the sequence is a *head* or *singleton* in at least one sample, `false` otherwise.
- obiclean_samplecount: The number of samples the sequence occurs in the data set (here 2).
- obiclean_headcount: The number of samples where the sequence is classified as *head* (here 0).
- obiclean_internalcount: The number of samples where the sequence is classified as *internal* (here 2).
- obiclean_singletoncount: The number of samples where the sequence is classified as *singleton* (here 0).
- `obiclean_status`: A JSON map indexed by the name of the sample in which the sequence was found. The value indicates the classification of the sequence in this sample: `i` for *internal*, `s` for *singleton* or `h` for *head*.
- `obiclean_weight`: A JSON map indexed by the name of the sample in which the sequence was found. The value indicates the number of times the sequence and its derivatives were found in this sample (here 5 for sample *15a_F73081*).
- `obiclean_mutation`: A JSON map indexed by sequence `id`s. Each entry of the map contains the sequence `id` of the parent sequence and the position of the mutation between the parent sequence and the sequence in the variant. Only sequences belonging to the class *internal* in at least one sample are annotated with this tag.
  
  Here: `(a)->(g)@26` indicates that the `a` in the parent sequence `HELIUM_000100422_612GNAAXX:7:22:2603:18023#0/1_sub[28..127]` in this variant has been replaced by a `g` at position 26.

## The Chimera Detection Algorithm

This new version of {{< obi obiclean >}} implements a naive chimera detection algorithm.
It is an experimental feature. The algorithm is only run when the `--dectect-chimera` option is used.
It is applied to sequences that have already been classified by the clustering algorithm presented above.

The algorithm defines a chimeric sequence *S* as a sequence classified as `head` or `singleton` by the clustering algorithm, for which there exists in the sample a pair of sequences {{< katex >}}\{S_{Pre} ; S_{Suf}\}{{< /katex >}} that are more frequent than *S*, and such that the concatenation of the shared prefix between *S* and {{< katex >}}S_{Pre}{{< /katex >}} and the shared suffix between *S* and {{< katex >}}S_{Suf}{{< /katex >}} is equal to *S*.

{{< katex display=true >}}
S = Common\_prefix(S,S_{Pre}) + Common\_suffix(S,S_{Suf})
{{< /katex >}}

```bash 
obiclean -r 0.1 \
         -Z \
         --detect-chimera  \
         wolf_uniq.fasta.gz > wolf_clean_chimera.fasta.gz
```

Extracted from the result file [`wolf_clean_chimera.fasta.gz`](wolf_clean_chimera.fasta.gz), the sequence shown below illustrates how a chimeric sequence is annotated.

```fasta
>HELIUM_000100422_612GNAAXX:7:21:6999:18567#0/1_sub[28..127] {"ali_dir":"left","ali_length":62,"chimera":{"29a_F260619":"{HELIUM_000100422_612GNAAXX:7:26:10054:16185#0/1_sub[28..127]}/{HELIUM_000100422_612GNAAXX:7:102:9724:19316#0/1_sub[28..127]}@(24)"},"count":1,"direction":"reverse","experiment":"wolf_diet","forward_match":"ttagataccccactatgc","forward_mismatches":0,"forward_primer":"ttagataccccactatgc","forward_tag":"gcctcct","merged_sample":{"29a_F260619":1},"mode":"alignment","obiclean_head":true,"obiclean_headcount":0,"obiclean_internalcount":0,"obiclean_samplecount":1,"obiclean_singletoncount":1,"obiclean_status":{"29a_F260619":"s"},"obiclean_weight":{"29a_F260619":1},"pairing_mismatches":{"(A:21)->(G:02)":67,"(A:34)->(C:02)":31,"(A:34)->(G:02)":29,"(C:28)->(G:02)":42,"(C:34)->(A:02)":30,"(G:32)->(T:02)":55,"(T:33)->(G:02)":35},"reverse_match":"tagaacaggctcctctag","reverse_mismatches":0,"reverse_primer":"tagaacaggctcctctag","reverse_tag":"gcctcct","score":306,"score_norm":0.806,"seq_a_single":46,"seq_ab_match":50,"seq_b_single":46}
ttagccctaaacacaagtaattaatataacaaaattattcgccagagtactaccggcaat
agcttaaaactcaaaggacttggcggtgctgtatacccgt
````

### Tags added to each chimeric sequence by the chimera detection algorithm

A `chimera` tag is added to the sequence. The tag contains a JSON map indexed by the names of the samples in which the chimeric sequence was detected. The value indicates the two parental sequences and the position of the transition between the two sequences in the chimera:

```
{"29a_F260619":"{HELIUM_000100422_612GNAAXX:7:26:10054:16185#0/1_sub[28..127]}/{HELIUM_000100422_612GNAAXX:7:102:9724:19316#0/1_sub[28..127]}@(24)"}
```

Which reads as 

- Sequence: `HELIUM_000100422_612GNAAXX:7:21:6999:18567#0/1_sub[28..127]` 
  - was detected as chimera in sample: 29a_F260619 
  - between the sequences: 
    - `HELIUM_000100422_612GNAAXX:7:26:10054:16185#0/1_sub[28..127]` as prefix
    - `HELIUM_000100422_612GNAAXX:7:102:9724:19316#0/1_sub[28..127]` as suffix
    - The junction is at position 24 on the chimeric sequence `HELIUM_000100422_612GNAAXX:7:21:6999:18567#0/1_sub[28..127]`.


## Filtering the output

### Remove sequences annotated as spurious.

By default, {{< obi obiclean >}} only annotates each sequence with different tags describing its classification in the different samples. Therefore, there are as many sequences in the result file as in the input file. This can be verified using the {{< obi obicount >}} command on the previous input and result files, [`wolf_uniq.fasta.gz`](wolf_uniq.fasta.gz) and [`wolf_clean_chimera.fasta.gz`](wolf_clean_chimera.fasta.gz) respectively.

```bash
obicount wolf_uniq.fasta.gz | csvlook
```
```
| entities |       n |
| -------- | ------- |
| variants |   4 313 |
| reads    |  42 452 |
| symbols  | 428 403 |
```

```bash
obicount wolf_uniq_chimera.fasta.gz | csvlook
```
```
| entities |       n |
| -------- | ------- |
| variants |   4 313 |
| reads    |  42 452 |
| symbols  | 428 403 |
```

{{< obi obiclean >}} can be run in filter mode, which removes a sequence from the result sequence set if it is considered spurious in all samples in which it occurs. Spurious sequences are those classified as *internal* or *chimeric*.

This filtering is done by setting the `-H` option.

```bash 
obiclean -r 0.1 \
         -Z \
         --detect-chimera  \
         -H \
         wolf_uniq.fasta.gz > wolf_clean_chimera_head.fasta.gz
```

```bash
obicount wolf_clean_chimera_head.fasta.gz | csvlook
```
```
| entities |       n |
| -------- | ------- |
| variants |   2 322 |
| reads    |  35 623 |
| symbols  | 230 953 |
```

### Remove sequences occurring in less than *k* samples

It can be considered as reasonable to remove a sequence that occurs in less than *k* samples, especially if PCR technical replicates have been realized and several samples of the data set actually corresponds to these technical replicates of a single biological sample. By default, the minimum number of samples is set to 1. This means that no sequences are discarded by this filter. The `-min-sample-count` option allows setting this threshold at an upper value.
A value of *2* has already a strong effect:

```bash
obiclean -r 0.1 \
         --detect-chimera  \
         -H \
         --min-sample-count 2 \
         wolf_uniq.fasta.gz \
    | obicount | csvlook
```
```
| entities |      n |
| -------- | ------ |
| variants |     13 |
| reads    | 12 697 |
| symbols  |  1 297 |
```

This is equivalent to post-filtering the result of the {{< obi obiclean >}} command using the following {{< obi obigrep >}} command:

```bash
obiclean -r 0.1 \
         --detect-chimera  \
         -H \
         wolf_uniq.fasta.gz \
    | obigrep -p 'annotations.obiclean_samplecount>=2' \
    | obicount | csvlook
```
```
| entities |      n |
| -------- | ------ |
| variants |     13 |
| reads    | 12 697 |
| symbols  |  1 297 |
```


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

### {{< obi obiclean >}} specific options

#### Clustering algorithm options

- {{< cmd-options/alignments/distance >}}
- {{< cmd-options/alignments/ratio >}}
- {{< cmd-options/alignments/sample >}}

#### Chimera detection options

- {{< cmd-option name="detect-chimera" >}}
  Detect chimera sequences. (default: false)  
  {{< /cmd-option >}}

#### Filtering options

- {{< cmd-options/alignments/head >}}
- {{< cmd-option name="min-sample-count" param="INTEGER" >}}
  Minimum number of samples a sequence must be present in to be considered in the analysis. (default: 1)  
  {{< /cmd-option >}}

#### Dumping internal clustering data 

- {{< cmd-options/alignments/min-eval-rate >}}
- {{< cmd-options/alignments/save-graph >}}
- {{< cmd-options/alignments/save-ratio >}}

### shared options

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obiclean --help
```
