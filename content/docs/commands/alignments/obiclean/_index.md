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

Consider two sequences *S1* and *S2* occurring in the same sample (PCR). *S1* is a sequence variant of *S2* if and only if:

- The ratio of the number of the occurrences of *S1* and *S2* is smaller than the parameter *R*. 
    {{< katex display=true >}}
    \frac{Count_{S1}}{Count_{S2}} < R
    {{< /katex >}}
    The default value of *R* is 1 and can be set between 0 and 1 using the `-r` option.
        
- The number of differences between *S1* and *S2* when aligning these sequences is less than a maximum number of differences that can be specified with the `-d` option (default = 1 error).
    {{< katex display=true >}}
    dist(S1,S2) < d
    {{< /katex >}}

This relation, *is a sequence variant of*, defines a [directed acyclic graph (DAG)](https://en.wikipedia.org/wiki/Directed_acyclic_graph) on the sequences belonging to a sample.
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

- The `-Z` option is for compressing the output file.

The [yEd](https://www.yworks.com/products/yed) program allows visualizing the graph described for each sample.



{{< fig src="13a_F730603.svg" 
    title="obiclean graph for the sample 13a_F730603"
    caption="Each dot represents one sequence. The area of the dot is proportional to the abundance of the sequence in the sample. The arrows represent the relationship *is a sequence variant of*, starting from the derived sequence to its presumed original version. The number on each arrow indicates the distance between the two sequences, here 1 everywhere. This sample corresponds to the dietary analysis of a wolf. Therefore, one true sequence (the prey) is expected. It corresponds to the big blue circle."
>}}

From the graph topology, each sequence *S* is classified in one of three following classes:

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

That class is sample dependent as a graph is built per sample, and recorded in the `obiclean_status` tag as examplarized below by one of the sequence extracted from the result file [`wolf_clean.fasta.gz`](wolf_clean.fasta.gz).

```fasta
>HELIUM_000100422_612GNAAXX:7:91:7524:17193#0/1_sub[28..127] {"ali_dir":"left","ali_length":62,"count":8,"direction":"reverse","experiment":"wolf_diet","forward_match":"ttagataccccactatgc","forward_mismatches":0,"forward_primer":"ttagataccccactatgc","merged_sample":{"15a_F730814":5,"29a_F260619":3},"mode":"alignment","obiclean_head":false,"obiclean_headcount":0,"obiclean_internalcount":2,"obiclean_mutation":{"HELIUM_000100422_612GNAAXX:7:22:2603:18023#0/1_sub[28..127]":"(a)->(g)@26"},"obiclean_samplecount":2,"obiclean_singletoncount":0,"obiclean_status":{"15a_F730814":"i","29a_F260619":"i"},"obiclean_weight":{"15a_F730814":5,"29a_F260619":3},"reverse_match":"tagaacaggctcctctag","reverse_mismatches":0,"reverse_primer":"tagaacaggctcctctag","seq_a_single":46,"seq_b_single":46}
ttagccctaaacacaagtaattaatgtaacaaaattattcgccagagtactaccggcaat
agcttaaaactcaaaggacttggcggtgctttataccctt
```

### Tags added by the clustering algorithm to each sequence

- `obiclean_head`: `true` if the sequence is a *head* or *singleton* in at least one sample, `false` otherwise.
- `obiclean_samplecount`: The number of samples in which the sequence is occurring in the dataset (here 2).
- `obiclean_headcount`: The number of samples in which the sequence is classified as *head* (here 0).
- `obiclean_internalcount`: The number of samples in which the sequence is classified as *internal* (here 2).
- `obiclean_singletoncount`: The number of samples in which the sequence is classified as *singleton* (here 0).
- `obiclean_status`: A JSON map indexed by the name of the sample where the sequence was found. The value indicates the classification of the sequence in that sample: `i` for *internal*, `s` for *singleton* or `h` for *head*.
- `obiclean_weight`: A JSON map indexed by the name of the sample where the sequence was found. The value indicates the number of times the sequence and its derivate sequences were found in that sample (here 5 for sample *15a_F73081*).
- `obiclean_mutation`: A JSON map indexed a sequence `id`. Each entry of the map contains the sequence `id` of the parental sequence and the position of the transition between the parental sequence and the sequence in the variant. Only sequence belonging the class *internal* in at least a sample are annotated by this tag.
  
  Here: `(a)->(g)@26` indicates that the `a`  in the parental sequence `HELIUM_000100422_612GNAAXX:7:22:2603:18023#0/1_sub[28..127]` has been replaced by a `g` in this variant at the position 26.

## The chimera detection algorithm

This new version of {{< obi obiclean >}} implements a naive chimera detection algorithm.
It is an experimental feature. The algorithm is run only if the `--dectect-chimera' option is used.
It is applied on sequences that have already been classified by the clustering algorithm presented above.

The algorithm defined a chimeric sequence *S* as a sequence for which it exists in the sample a pair of sequences {{< katex >}}S_{Pre}{{< /katex >}} and {{< katex >}}S_{Suf}{{< /katex >}} more abundante than *S* such as the concatenation of the shared prefix between *S* and {{< katex >}}S_{Pre}{{< /katex >}} and of the shared suffix between *S* and {{< katex >}}S_{Suf}{{< /katex >}} is equal to *S*.

```bash 
obiclean -r 0.1 \
         -Z \
         --detect-chimera  \
         wolf_uniq.fasta.gz > wolf_clean_chimera.fasta.gz
```

Extracted from the result file [`wolf_clean_chimera.fasta.gz`](wolf_clean_chimera.fasta.gz), the sequence presented below illustrate how a chimeric sequence is annotated.

```fasta
>HELIUM_000100422_612GNAAXX:7:21:6999:18567#0/1_sub[28..127] {"ali_dir":"left","ali_length":62,"chimera":{"29a_F260619":"{HELIUM_000100422_612GNAAXX:7:26:10054:16185#0/1_sub[28..127]}/{HELIUM_000100422_612GNAAXX:7:102:9724:19316#0/1_sub[28..127]}@(24)"},"count":1,"direction":"reverse","experiment":"wolf_diet","forward_match":"ttagataccccactatgc","forward_mismatches":0,"forward_primer":"ttagataccccactatgc","forward_tag":"gcctcct","merged_sample":{"29a_F260619":1},"mode":"alignment","obiclean_head":true,"obiclean_headcount":0,"obiclean_internalcount":0,"obiclean_samplecount":1,"obiclean_singletoncount":1,"obiclean_status":{"29a_F260619":"s"},"obiclean_weight":{"29a_F260619":1},"pairing_mismatches":{"(A:21)->(G:02)":67,"(A:34)->(C:02)":31,"(A:34)->(G:02)":29,"(C:28)->(G:02)":42,"(C:34)->(A:02)":30,"(G:32)->(T:02)":55,"(T:33)->(G:02)":35},"reverse_match":"tagaacaggctcctctag","reverse_mismatches":0,"reverse_primer":"tagaacaggctcctctag","reverse_tag":"gcctcct","score":306,"score_norm":0.806,"seq_a_single":46,"seq_ab_match":50,"seq_b_single":46}
ttagccctaaacacaagtaattaatataacaaaattattcgccagagtactaccggcaat
agcttaaaactcaaaggacttggcggtgctgtatacccgt
````

### Tags added by the chimera detection algorithm to each sequence

A tag `chimera` is added to the sequence. The tag contains a JSON map indexed by the name of the samples where the chimeric sequence was found. The value indicate the two parental sequences and the position of the transition between the two sequences in the chimera:

```
{"29a_F260619":"{HELIUM_000100422_612GNAAXX:7:26:10054:16185#0/1_sub[28..127]}/{HELIUM_000100422_612GNAAXX:7:102:9724:19316#0/1_sub[28..127]}@(24)"}
```

Which has to be read as 

- sequence: `HELIUM_000100422_612GNAAXX:7:21:6999:18567#0/1_sub[28..127]` 
  - has been detected as a chimera in sample: 29a_F260619 
  - between the sequences: 
    - `HELIUM_000100422_612GNAAXX:7:26:10054:16185#0/1_sub[28..127]` as prefix
    - `HELIUM_000100422_612GNAAXX:7:102:9724:19316#0/1_sub[28..127]` as suffix
    - The junction is at position 24 on the chimeric sequence `HELIUM_000100422_612GNAAXX:7:21:6999:18567#0/1_sub[28..127]`


## Filtering the output

### To remove sequences annotated as spurious sequences

For that filter a spurious sequence is a sequence that is classified as `internal` in all the samples where it occurs, or a sequence detected as `chimera` in all the samples where it occurs.

By default, {{< obi obiclean >}} is only tagging annotating every sequence with various tags describing their classification in the different samples. Therefore, in the result file, there is as many sequences than in the output file. This can be verified using the {{< obi obicount >}} command on the previous input and result files, [`wolf_uniq.fasta.gz`](wolf_uniq.fasta.gz) and [`wolf_clean_chimera.fasta.gz`](wolf_clean_chimera.fasta.gz) respectively.

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

{{< obi obiclean >}} can be run in filter mode, where a sequence, that is considered spurious in all the sample where it occurs, is removed from result dataset. Spurious sequences are the ones classified as `internal` or `chimera`.

That filtering is done by setting the `-H` option.

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
