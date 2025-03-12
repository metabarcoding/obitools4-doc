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
- A filter to set a threshold for the minimum number of samples (PCRs) a sequence must be present to be retained (default: 1, can be changed using the `--min-sample-count` option). 
- A naive chimera detection algorithm. This is an experimental feature. It is not run by default. It can be enabled with the `--dectect-chimera` option.

{{< obi obiclean >}} can run in two modes:

- A tagging mode where no sequences are actually removed from the data set, they are just tagged. It is your responsibility to remove the sequences you do not want based on these tags and your filter rules, using {{< obi obigrep >}}.
- A filter mode in which sequences that are considered to be artifactual sequences by {{< obi obiclean >}} are removed from the data set.

{{< obi obiclean >}} relies on per-sample (PCR) sequence abundance information to apply its algorithms. Therefore, the input data set must first be dereplicated using the {{< obi obiuniq >}} command with the `-m sample` option.

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

- The **count** attributes of the sequence set.
- The pairwise sequence similarities calculated in each set of sequences belonging to a sample.
  
The result of the {{< obi obiclean >}} algorithm is the classification of each sequence set into one of three classes: `head`, `internal` or `singleton`.

Consider two sequences *S1* and *S2* that occur in the same sample (PCR). *S1* is a sequence variant of *S2* if and only if

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
- obiclean_samplecount: the number of samples the sequence occurs in the data set (here 2).
- obiclean_headcount: the number of samples where the sequence is classified as *head* (here 0).
- obiclean_internalcount: the number of samples where the sequence is classified as *internal* (here 2).
- obiclean_singletoncount: the number of samples where the sequence is classified as *singleton* (here 0).
- `obiclean_status`: a JSON map indexed by the name of the sample in which the sequence was found. The value indicates the classification of the sequence in this sample: `i` for *internal*, `s` for *singleton* or `h` for *head*.
- `obiclean_weight`: a JSON map indexed by the name of the sample in which the sequence was found. The value indicates the number of times the sequence and its derivatives were found in this sample (here 5 for sample *15a_F73081*).
- `obiclean_mutation`: a JSON map indexed by sequence `id`s. Each entry of the map contains the sequence `id` of the parent sequence and the position of the mutation between the parent sequence and the sequence in the variant. Only sequences belonging to the class *internal* in at least one sample are annotated with this tag.
  
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

### Removal of sequences annotated as artifacts.

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

{{< obi obiclean >}} can be run in filter mode, allowing a sequence to be removed from the resulting sequence set if it is considered artifactual in all samples where it appears. Artifactual sequences are those classified as *internal* or *chimeric*.

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

### Remove sequences occurring in less than *k* samples (PCRs)

It may be considered reasonable to eliminate a sequence present in fewer than k samples, particularly if technical PCR replicates have been performed and several samples in the dataset actually correspond to these technical replicates of a single biological sample. By default, the minimum number of samples is set to 1, meaning that no sequences are rejected by this filter. The `-min-sample-count` option can be used to set this threshold to a higher value. 
A value of *2* already has a significant effect:

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
| variants |     12 |
| reads    | 12 695 |
| symbols  |  1 197 |
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
| variants |     12 |
| reads    | 12 695 |
| symbols  |  1 197 |
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

### *obiclean* specific options

#### Clustering algorithm options

- {{< cmd-option name="distance" short="d" param="INTEGER" >}}
  maximum numbers of differences between two variant sequences. (default: 1)
  {{< /cmd-option >}}
- {{< cmd-option name="ratio" short="r" param="FLOAT" >}}
  threshold ratio between counts (rare/abundant counts) of two sequence records so that the less abundant one is a variant of the more abundant (default: 1.00).
  {{< /cmd-option >}}
- {{< cmd-option name="sample" short="s" param="STRING" >}}
  name of the attribute containing sample descriptions (default: "sample").  
  {{< /cmd-option >}}

#### Chimera detection options

- {{< cmd-option name="detect-chimera" >}}
  enable chimera detection. (default: false)  
  {{< /cmd-option >}}

#### Filtering options

- {{< cmd-option name="head" short="H" >}}
  remove from the result data set, the sequences annotated as spurious in all the samples (default: false).
  {{< /cmd-option >}}
- {{< cmd-option name="min-sample-count" param="INTEGER" >}}
  minimum number of samples a sequence must be present in to be considered in the analysis. (default: 1)  
  {{< /cmd-option >}}

#### Dumping internal clustering data 

- {{< cmd-option name="save-graph" param="DIRNAME" >}}
  save the clustering graph for each sample (PCR) in a GML file in the directory precised as parameter of the option (default: false).
  {{< /cmd-option >}}
- {{< cmd-option name="save-ratio" param="FILENAME" >}}
  create a CSV file containing abundance ratio statistics for the edges of the clustering graphs above the `--min-eval-rate` threshold.
  If the option `-Z` is used conjointly with the option `--save-graph`, in addition to the result file, the ratio CSV file is also compressed using GZIP.
  {{< /cmd-option >}}
- {{< cmd-option name="min-eval-rate" param="INTEGER" >}}
  the minimum abundance of the destination sequence of an edge to be stored in the CSV file produced by the `--save-ratio` option (default: 1000).
  {{< /cmd-option >}}

### shared options

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

### Determining the ratio parameter

The ratio parameter (option `-r`) defines the ratio threshold between the frequency of the variant of a sequence and its original sequence. It can be used to distinguish between two closely related true sequences and a true sequence with its variant. To get an idea of the ratio threshold to use, the `obiclean` command with the `--save-ratio` option can be used. This option creates a CSV file containing the abundance ratio statistics from the edges of the clustering graphs. Only a subset of the edges are kept in the CSV file:

- Those corresponding to a single mutation (distance between the original and the mutated sequence is 1).
- Those where the original sequence has a weight greater than the threshold (determined by the `--min-eval-rate` option).

The last condition is used to avoid estimating the ratio from edges with too few sequences, in order to limit the stochastic effect on ratio estimation.

```bash
obiclean -Z \
         --save-ratio wolf_ratio_R1.csv.gz  \
         wolf_uniq.fasta.gz > wolf_clean_R1.fasta.gz
```

The `--save-ratio` requires a parameter `FILENAME` that is the name of the CSV file to create. The file is compressed using GZIP if the option `-Z` is used.

```bash
gzcat wolf_ratio_R1.csv.gz | head | csvlook
```
```
| Sample      | Origin_id                                                  | Origin_status | Origin | Mutant | Origin_Weight | Mutant_Weight | Origin_Count | Mutant_Count | Position | Origin_length |  A |  C |  G |  T |
| ----------- | ---------------------------------------------------------- | ------------- | ------ | ------ | ------------- | ------------- | ------------ | ------------ | -------- | ------------- | -- | -- | -- | -- |
| 26a_F040644 | HELIUM_000100422_612GNAAXX:7:5:15939:5437#0/1_sub[28..126] | h             | a      | -      |        12 830 |          True |       10 385 |         True |       44 |            99 | 35 | 25 | 16 | 23 |
| 26a_F040644 | HELIUM_000100422_612GNAAXX:7:5:15939:5437#0/1_sub[28..126] | h             | a      | -      |        12 830 |          True |       10 385 |         True |       72 |            99 | 35 | 25 | 16 | 23 |
| 26a_F040644 | HELIUM_000100422_612GNAAXX:7:5:15939:5437#0/1_sub[28..126] | h             | a      | -      |        12 830 |          True |       10 385 |         True |       42 |            99 | 35 | 25 | 16 | 23 |
| 26a_F040644 | HELIUM_000100422_612GNAAXX:7:5:15939:5437#0/1_sub[28..126] | h             | a      | -      |        12 830 |          True |       10 385 |         True |       57 |            99 | 35 | 25 | 16 | 23 |
| 26a_F040644 | HELIUM_000100422_612GNAAXX:7:5:15939:5437#0/1_sub[28..126] | h             | a      | -      |        12 830 |          True |       10 385 |         True |       76 |            99 | 35 | 25 | 16 | 23 |
| 26a_F040644 | HELIUM_000100422_612GNAAXX:7:5:15939:5437#0/1_sub[28..126] | h             | a      | -      |        12 830 |          True |       10 385 |         True |       73 |            99 | 35 | 25 | 16 | 23 |
| 26a_F040644 | HELIUM_000100422_612GNAAXX:7:5:15939:5437#0/1_sub[28..126] | h             | a      | -      |        12 830 |          True |       10 385 |         True |       16 |            99 | 35 | 25 | 16 | 23 |
| 26a_F040644 | HELIUM_000100422_612GNAAXX:7:5:15939:5437#0/1_sub[28..126] | h             | a      | -      |        12 830 |          True |       10 385 |         True |       32 |            99 | 35 | 25 | 16 | 23 |
| 26a_F040644 | HELIUM_000100422_612GNAAXX:7:5:15939:5437#0/1_sub[28..126] | h             | a      | -      |        12 830 |          True |       10 385 |         True |       73 |            99 | 35 | 25 | 16 | 23 |
```

The ratio CSV file [`wolf_ratio_R1.csv.gz`](wolf_ratio_R1.csv.gz) contains the following columns:

- `Sample`: The name of the sample where the observation is done.
- `Origin_id`: The ID of the original sequence corresponding to described mutant.
- `Origin_status`: The status of the original sequence in the sample.
- `Origin`: Original sequence at the mutation site.
- `Mutant`: Mutant sequence at the mutation site.
- `Origin_Weight`: Observed weight of the original sequence in the sample.
- `Mutant_Weight`: Observed weight of the mutant sequence in the sample.
- `Origin_Count`: Observed count of the original sequence in the sample.
- `Mutant_Count`: Observed count of the mutant sequence in the sample.
- `Position`: Position of the mutation in the original sequence.
- `Origin_length`: Length of the original sequence.
- `A`: Count of *A* nucleotides in the original sequence.
- `C`: Count of *C* nucleotides in the original sequence.
- `G`: Count of *G* nucleotides in the original sequence.
- `T`: Count of *T* nucleotides in the original sequence.

From the file [`wolf_ratio_R1.csv.gz`](wolf_ratio_R1.csv.gz), a histogram of the ratio of the weight of the mutant to the weight of the original can be plotted using the following command:

```bash
gzcat wolf_ratio_R1.csv.gz \
    | octosql -o csv "select log10(float(Mutant_Weight) / float(Origin_Weight)) as ratio 
                        from stdin.csv" \
    | uplot -H hist -n 25
```
```
                                  ratio
                ┌                                        ┐ 
   [-4.2, -4.0) ┤▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 107                    
   [-4.0, -3.8) ┤▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 200    
   [-3.8, -3.6) ┤▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 208   
   [-3.6, -3.4) ┤▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 119                  
   [-3.4, -3.2) ┤▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 145              
   [-3.2, -3.0) ┤▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 146             
   [-3.0, -2.8) ┤▇▇▇▇▇▇▇▇▇▇▇▇ 71                           
   [-2.8, -2.6) ┤▇▇▇▇▇▇▇▇ 45                               
   [-2.6, -2.4) ┤▇▇▇▇ 26                                   
   [-2.4, -2.2) ┤▇ 6                                       
   [-2.2, -2.0) ┤▇ 7                                       
   [-2.0, -1.8) ┤ 2                                        
   [-1.8, -1.6) ┤ 0                                        
   [-1.6, -1.4) ┤ 0                                        
   [-1.4, -1.2) ┤ 2                                        
```

The file [`wolf_ratio_R1.csv.gz`](wolf_ratio_R1.csv.gz) describes the following number of edges (look the number of rows in the CSV file):


```bash
gzcat wolf_ratio_R1.csv.gz \
  | csvtk dim
```
```
file  num_cols  num_rows
-           15     1,084
```


Most edges in the graph connect a PCR variant sequence to its parent sequence. Only a few edges correspond to a connection between two closely related true sequences that differ only by a single mutation; they are not frequent enough to distort the shape of the distribution. Therefore, this histogram can be considered as the distribution of the ratio between a variant sequence and its parent sequence. We can observe that no ratio in this histogram is greater than {{< katex >}}10^{-1}{{</ katex >}}, and only 4 out of 1084 edges have a ratio greater than {{< katex >}}10^{-2}{{</ katex >}}. Using the `--ratio 0.1` option will not split any edges, using the `--ratio 0.01` option will split 4 edges over the edges used for the statistics. Because of all the edges discarded from the ratio table (involving too few original sequences), the effect on the number of MOTUs produced may be greater.

Below we run the {{< obi obiclean >}} command with several different values for the `--ratio` option, ranging from 1 to 0.01. For each run, the number of MOTUs produced is printed by piping the output of {{< obi obiclean >}} to the {{< obi obicount >}} and `csvlook` commands.

- Run with a ratio of 1

```
obiclean -r 1 -H wolf_uniq.fasta.gz \
  | obicount | csvlook
```
```
| entities |       n |
| -------- | ------- |
| variants |   2 046 |
| reads    |  35 111 |
| symbols  | 203 349 |
```

- Run with a ratio of 1/2

```
obiclean -r 0.5 -H wolf_uniq.fasta.gz \
  | obicount | csvlook
```
```
| entities |       n |
| -------- | ------- |
| variants |   2 046 |
| reads    |  35 111 |
| symbols  | 203 349 |
```

- Run with a ratio of 1/10

```
obiclean -r 0.1 -H wolf_uniq.fasta.gz \
  | obicount | csvlook
```
```
| entities |       n |
| -------- | ------- |
| variants |   2 449 |
| reads    |  35 757 |
| symbols  | 243 515 |
```

- Run with a ratio of 1/100

```
obiclean -r 0.01 -H wolf_uniq.fasta.gz \
  | obicount | csvlook
```
```
| entities |       n |
| -------- | ------- |
| variants |   3 215 |
| reads    |  37 546 |
| symbols  | 319 820 |
```

As you can see, the number of MOTUs produced increases as the `-ratio` option decreases, but the ratio of 0.5 has no effect on the number of MOTUs produced compared to the default ratio of 1.0.
