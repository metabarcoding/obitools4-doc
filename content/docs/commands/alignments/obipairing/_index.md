---
archetype: command
title: "obipairing"
date: 2025-02-10
command: obipairing
category: alignments
url: "/obitools/obipairing"
weight: 20
---

# `obipairing`: align forward and reverse paired reads

## Description 

When DNA metabarcoding sequences are generated as paired reads on the Illumina platform, {{< obi obipairing >}} aims to align both forward and reverse reads to generate full length amplicon sequences.

### Input data

The {{< obi obipairing >}} command requires two input files:

- One file contains the forward reads.
- The second file contains the reverse reads.

Both files must have the same number of sequences, and the sequences must be in the same order. This means that the first sequence of the forward reads file must correspond to the first sequence of the reverse reads file. {{< obi obipairing >}} will assume this order and only align sequences that occur in the same rank.

Consider the following example, where the forward reads file is [`forward.fastq`]({{< relref "forward.fastq" >}}) and the reverse reads file is [`reverse.fastq`]({{< relref "reverse.fastq" >}}) and both consist of 4 sequences:


{{< code "forward.fastq" fastq true >}}
  
{{< code "reverse.fastq" fastq true >}}

The first sequence of the [`forward.fastq`]({{< relref "forward.fastq" >}}) file having the id `LH00534:26:2237MWLT1:2:1101:3663:1096` will be paired with the first sequence of the [`reverse.fastq`]({{< relref "reverse.fastq" >}}) file having the same id `LH00534:26:2237MWLT1:2:1101:3663:1096`, not because they have the same identifier but because they are both the first sequence of their respective files.

### The simplest {{< obi obipairing >}} command

The minimal {{< obi obipairing >}} command to align the [`forward.fastq`]({{< relref "forward.fastq" >}}) and [`reverse.fastq`]({{< relref "reverse.fastq" >}}) files is:

```bash
obipairing -F forward.fastq -R reverse.fastq > paired.fastq
```

{{< mermaid class="workflow" >}}
graph TD
  A@{ shape: doc, label: "forward.fastq" }
  B@{ shape: doc, label: "reverse.fastq" }
  C[obipairing]
  D@{ shape: doc, label: "paired.fastq" }
  A --> C
  B --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}

it will produce a file named [`paired.fastq`]({{< relref "paired.fastq" >}}) with the following content:

{{< code "paired.fastq" fastq true >}}


### The alignment process

{{< obi obipairing >}} will align the reads following a two-step procedure to increase computation speed.
The first step aligns the reads using a [FASTA derived algorithm]({{< relref "fasta-like.md" >}}).
Based on results of the first step, a second alignment step is on the overlapping region only using an exact dynamic programming algorithm.



It is possible to disable this first alignment step at the cost of an increase in the computation time by using the `--exact-mode` option.

`--fasta-absolute`

Three tags are added to the FASTQ header for each read to report the results of this first step alignment.

- `paring_fast_count` :
- `paring_fast_overlap` :
- `paring_fast_score` :



#### The exact alignment of the overlapping regions

`--delta`



### Annotations added to the FASTQ header for each read

- mode
- ali_dir
- ali_length
- paring_fast_count
- paring_fast_overlap
- paring_fast_score
- score
- score_norm
- seq_a_single
- seq_ab_match
- seq_b_single
- pairing_mismatches

## Synopsis

```bash
obipairing --forward-reads|-F <FILENAME_F> --reverse-reads|-R <FILENAME_R>
           [--batch-size <int>] [--compress|-Z] [--debug] [--delta|-D <int>]
           [--ecopcr] [--embl] [--exact-mode] [--fast-absolute] [--fasta]
           [--fasta-output] [--fastq] [--fastq-output] [--force-one-cpu]
           [--gap-penality|-G <float64>] [--genbank] [--help|-h|-?]
           [--input-OBI-header] [--input-json-header] [--json-output]
           [--max-cpu <int>] [--min-identity|-X <float64>]
           [--min-overlap <int>] [--no-order] [--no-progressbar]
           [--out|-o <FILENAME>] [--output-OBI-header|-O]
           [--output-json-header] [--penality-scale <float64>] [--pprof]
           [--pprof-goroutine <int>] [--pprof-mutex <int>] [--skip-empty]
           [--solexa] [--version] [--without-stat|-S] [<args>]
```

## Options

#### {{< obi obipairing >}} mandatory options

- {{< cmd-option name="forward-reads" short="F" param="FILENAME" >}}
  The name of the file containing the forward reads.
  {{< /cmd-option >}}

- {{< cmd-option name="reverse-reads" short="R" param="FILENAME" >}}
  The name of the file containing the reverse reads.
  {{< /cmd-option >}}

#### Other {{< obi obipairing >}} specific options

- {{< cmd-option name="delta" short="D" param="INTEGER" >}}
  Length added to the fast-detected overlap for the exact alignment algorithm (default: 5 nucleotides).  
  {{< /cmd-option >}}

- {{< cmd-option name="exact-mode" >}}
  Do not run fast alignment heuristic. (default: a fast algorithm is run at first to accelerate the final exact alignment).  
  {{< /cmd-option >}}

- {{< cmd-option name="fast-absolute" >}}
  Compute absolute fast score, this option has no effect in exact mode (default: false).
  {{< /cmd-option >}}

- {{< cmd-option name="gap-penality" short="G" param="FLOAT64" >}}
  Gap penalty expressed as the multiply factor applied to the mismatch score between two nucleotides with a quality of 40 (default 2). (default: 2.000000)
  {{< /cmd-option >}}

- {{< cmd-option name="min-identity" short="X" param="FLOAT64" >}}
  Minimum identity between ovelaped regions of the reads to consider the alignment (default: 0.900000).
  {{< /cmd-option >}}

- {{< cmd-option name="min-overlap" param="INTEGER" >}}
  Minimum overlap between both the reads to consider the alignment (default: 20).
  {{< /cmd-option >}}

- {{< cmd-option name="penality-scale" param="FLOAT64" >}}
  Scale factor applied to the mismatch score and the gap penality (default 1).
  {{< /cmd-option >}}

- {{< cmd-option name="without-stat" short="S" >}}
  Remove alignment statistics from the produced consensus sequences (default: false).
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obipairing --help
```
