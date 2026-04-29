---
archetype: "command"
title: "obitagpcr"
date: 2025-02-10
command: "obitagpcr"
category: demultiplexing
url: "/obitools/obitagpcr"
---

# `obitagpcr`: split paired-end raw reads per sample

## Description

The {{< obi obitagpcr >}} command processes paired-end raw reads from amplicon
sequencing experiments and assigns each read pair to the correct biological
sample/PCR replicate. It relies on two successive operations:

1. **Paired-end assembly** — forward (R1) and reverse (R2) reads are merged
   into a single consensus amplicon using the same overlap-based algorithm as
   {{< obi obipairing >}}.
2. **Demultiplexing** — each assembled amplicon is matched against a list of
   known primers and barcodes (tags) to identify the sample of origin, using
   the same engine as {{< obi obimultiplex >}}.

However, unlike the chaining of these two steps using {{< obi obipairing >}} and {{< obi obimultiplex >}} commands, {{< obi obitagpcr >}} forgets the assembled amplicon and only tags the forward and the reverse reads with the deduced sample ID.

{{< mermaid >}}
graph LR
    R1["Forward reads<br/>(R1.fastq)"] --> OBT{{obitagpcr}}
    R2["Reverse reads<br/>(R2.fastq)"] --> OBT
    CSV["NGSFilter CSV<br/>(--tag-list)"] --> OBT
    OBT --> OUT_R1["result_R1.fastq"]
    OBT --> OUT_R2["result_R2.fastq"]
    OBT -. "--unidentified" .-> UNID["unassigned.fastq"]
{{< /mermaid >}}

{{< obi obitagpcr >}} is an alternative entry point for Illumina paired-end
metabarcoding data, when we want to delegate the processing of data to external tools requiring per sample data files such as [DADA2](https://benjjneb.github.io/dada2/).

### Output files

Unlike most {{% obitools4 %}} commands, {{< obi obitagpcr >}} always produces
**paired output**. Therefore the `--out` option must be used to indicate where to save the results, as example using `--out result.fastq` is producing two files:
`result_R1.fastq` and `result_R2.fastq`.

### The NGSFilter sample description file

The `--tag-list` option takes a {{% csv %}} file that
describes all PCR reactions in the library. The exact structure of the file is shared with
{{< obi obimultiplex >}}; see the {{< obi obimultiplex >}} page for a complete
description of the format, `@param` configuration options, and tag-matching
algorithms.

{{< code "wolf_diet_ngsfilter.csv" csv true >}}

The file has two sections: optional `@param` lines that configure matching
behaviour (primer mismatches, indels, tag-matching algorithm), and a sample
table with at minimum five columns: `experiment`, `sample`, `sample_tag`,
`forward_primer`, `reverse_primer`.

Use `obipcrtag --template` to print an annotated example of the format.

### Annotations added by `obitagpcr`

Each successfully demultiplexed sequence is annotated with the following
attributes:

- **Sample identification**

  - `experiment`: `"wolf_diet"`

    Experiment name as defined in the NGSFilter file.

  - `sample`: `"29a_F260619"`

    Sample (PCR) name as defined in the NGSFilter file.

- **Amplicon orientation**

  - `obimultiplex_direction`: `"forward"`/`"reverse"`

    Because sequencing is not oriented, some read pairs have the forward read starting with the forward primer, while some others have the forward read starting with the reverse primer. The `obimultiplex_direction` annotation documents these two cases:


    - `"forward"` value means that the forward primer was found at the beginning of the forward read, 
    - `"reverse"` value means the reverse primer was found at the beginning of the forward read. 
    
    Adding the `--reorientate` flag to the command, exchanges and reverse-complements both reads of pairs annotated as `"reverse"`. Therefore, the reads in the **R1** file all match the forward primer at their beginning, while the sequences in the **R2** file all end with the reverse primer.

- **Primer matching**

  - `obimultiplex_forward_match`: `"ttagataccccactatgc"`

    Forward primer sequence as observed in the read.

  - `obimultiplex_forward_error`: `0`

    Number of mismatches between the forward primer and the read.

  - `obimultiplex_reverse_match`: `"tagaacaggctcctctag"`

    Reverse primer sequence as observed in the read.

  - `obimultiplex_reverse_error`: `0`

    Number of mismatches between the reverse primer and the read.

- **Tag identification**

  - `obimultiplex_forward_tag`: `"gcctcct"`

    Barcode sequence observed at the forward end of the read.

  - `obimultiplex_reverse_tag`: `"gcctcct"`

    Barcode sequence observed at the reverse end of the read.

When paired-end assembly succeeds via overlap alignment, additional attributes
from the {{< obi obipairing >}} step (`ali_length`, `score_norm`, `identity`,
`mode`) are also present in the output, unless suppressed with `--without-stat` (see {{< obi obimultiplex >}} for a complete description of the added annotations).

## Synopsis

```bash
obitagpcr --forward-reads|-F <FILENAME_F> --reverse-reads|-R <FILENAME_R>
          [--allowed-mismatches|-e <int>] [--batch-mem <string>]
          [--batch-size <int>] [--batch-size-max <int>] [--compress|-Z]
          [--debug] [--delta|-D <int>] [--ecopcr] [--embl] [--exact-mode]
          [--fast-absolute] [--fasta] [--fasta-output] [--fastq]
          [--fastq-output] [--gap-penalty|-G <float64>] [--genbank]
          [--help|-h|-?] [--input-OBI-header] [--input-json-header]
          [--json-output] [--keep-errors] [--max-cpu <int>]
          [--min-identity|-X <float64>] [--min-overlap <int>] [--no-order]
          [--no-progressbar] [--out|-o <FILENAME>] [--output-OBI-header|-O]
          [--output-json-header] [--penalty-scale <float64>] [--pprof]
          [--pprof-goroutine <int>] [--pprof-mutex <int>] [--reorientate]
          [--silent-warning] [--skip-empty] [--solexa]
          [--tag-list|-s <string>] [--template] [--u-to-t]
          [--unidentified|-u <string>] [--version] [--with-indels]
          [--without-stat|-S] [<args>]
```

## Options

#### {{< obi obitagpcr >}} specific options

- {{< cmd-options/demultiplexing/forward-reads >}}
- {{< cmd-options/demultiplexing/reverse-reads >}}
- {{< cmd-options/demultiplexing/allowed-mismatches >}}
- {{< cmd-options/demultiplexing/delta >}}
- {{< cmd-options/demultiplexing/exact-mode >}}
- {{< cmd-options/demultiplexing/fast-absolute >}}
- {{< cmd-options/demultiplexing/gap-penalty >}}
- {{< cmd-options/demultiplexing/keep-errors >}}
- {{< cmd-options/demultiplexing/min-identity >}}
- {{< cmd-options/demultiplexing/min-overlap >}}
- {{< cmd-options/demultiplexing/penalty-scale >}}
- {{< cmd-options/demultiplexing/reorientate >}}
- {{< cmd-options/demultiplexing/tag-list >}}
- {{< cmd-options/demultiplexing/template >}}
- {{< cmd-options/demultiplexing/unidentified >}}
- {{< cmd-options/demultiplexing/with-indels >}}
- {{< cmd-options/demultiplexing/without-stat >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

The examples below use the wolf diet 12S metabarcoding dataset from the
[Illumina OBITools4 cookbook](../../../cookbook/illumina) (4 paired-end reads shown; full 20-read files:
[wolf_F.fastq](wolf_F.fastq) and [wolf_R.fastq](wolf_R.fastq)).

### Basic demultiplexing of a paired-end library

Assemble paired reads and assign them to samples using the primer–barcode
combinations defined in [`wolf_diet_ngsfilter.csv`](wolf_diet_ngsfilter.csv). The `--out` flag creates
two files: `out_basic_R1.fastq` and `out_basic_R2.fastq`.

{{< code "wolf_F_4seq.fastq" fastq true >}}

{{< code "wolf_R_4seq.fastq" fastq true >}}

```bash
obitagpcr \
  --forward-reads wolf_F_4seq.fastq \
  --reverse-reads wolf_R_4seq.fastq \
  --tag-list wolf_diet_ngsfilter.csv \
  --out out_basic.fastq
```

The R1 output, with demultiplexing annotations added to each sequence header:

{{< code "out_basic_4seq_R1.fastq" fastq true >}}

The R2 output (`out_basic_4seq_R2.fastq`) contains the corresponding reverse
reads carrying identical annotations.

{{< code "out_basic_4seq_R2.fastq" fastq true >}}

### Reorientate reads for consistent strand direction

As explained above, Illumina sequencing is not an orientated process, so reads arrive in mixed orientations (`obimultiplex_direction`: `"forward"` or `"reverse"`). The `--reorientate` flag reverse-complements reads matched in the reverse direction
so that all output sequences run from forward primer to reverse primer:

```bash
obitagpcr \
  --forward-reads wolf_F_4seq.fastq \
  --reverse-reads wolf_R_4seq.fastq \
  --tag-list wolf_diet_ngsfilter.csv \
  --reorientate \
  --out out_reorientate.fastq
```

Preview the first two sequences of the result:

```bash
head -n 8 out_reorientate_R1.fastq
```

```
@HELIUM_000100422_612GNAAXX:7:119:14871:19157#0/1 {"experiment":"wolf_diet","obimultiplex_direction":"forward","obimultiplex_forward_error":0,"obimultiplex_forward_match":"ttagataccccactatgc","obimultiplex_forward_tag":"gcctcct","obimultiplex_reverse_error":0,"obimultiplex_reverse_match":"tagaacaggctcctctag","obimultiplex_reverse_tag":"gcctcct","sample":"29a_F260619"}
ccgcctcctttagataccccactatgcttagccctaaacacaagtaattattataacaaaatcattcgccagagtactaccggcaatagctcaaaactcaaagaactt
+
CCCCCCCCCCCCCCCCCCCCCCBCCCCB@BCCCCCCCCCCCCCB;CCCACCCCCCCAACA29,?<5899+A=A###################################
@HELIUM_000100422_612GNAAXX:7:108:5640:3823#0/1 {"experiment":"wolf_diet","obimultiplex_direction":"forward","obimultiplex_forward_error":0,"obimultiplex_forward_match":"ttagataccccactatgc","obimultiplex_forward_tag":"gcctcct","obimultiplex_reverse_error":0,"obimultiplex_reverse_match":"tagaacaggctcctctag","obimultiplex_reverse_tag":"gcctcct","sample":"29a_F260619"}
ccgcctcctttagataccccactatgcttagccctaaacacaagtaattaatataacaaaattgttcgccagagtactaccggcaatagcttaaaactcaaaggactt
+
CCCCCCCBCCCCCCCCCCCCCCCCCCCCCCBCCCCCBCCCCCCC<CCCCACC;C?CCCC@A;=,B;93:;CC=C;==??#############################
```

The fourth reads, which was matched in `reverse`, have been exchanged and reverse-complemented. As a result, the read that was originally in the "R2" file is now in the "R1" file, and vice versa.:

```bash
head -n 16 out_reorientate_R1.fastq | tail -n 4
```

```
coissac@MacBook-Pro-de-Eric obitagpcr % head -n 16 out_reorientate_R1.fastq | tail -n 4

@HELIUM_000100422_612GNAAXX:7:22:8540:14708#0/2 {"experiment":"wolf_diet","obimultiplex_direction":"reverse","obimultiplex_forward_error":0,"obimultiplex_forward_match":"ttagataccccactatgc","obimultiplex_forward_tag":"gcctcct","obimultiplex_reverse_error":0,"obimultiplex_reverse_match":"tagaacaggctcctctag","obimultiplex_reverse_tag":"gcctcct","sample":"29a_F260619"}
ccgcctcctttagataccccactatgcttagccctaaacacaagtaattaatataacaaaattattcgccagagtactaccggcaatagcttcacactcaaagaactt
+
CCCDCCCCCCCCCDCCCCCCCCCDCCC@CCACCCCCCCCCCCCDCCCCCCCCCDCCCCCBBBBCC=/AAA===>=C<CCC?B9AA;3??7CC@C6CCC8ACCC+AB8A
```

Download the full output: 
- [out_reorientate_4seq_R1.fastq](out_reorientate_4seq_R1.fastq)
- [out_reorientate_4seq_R2.fastq](out_reorientate_4seq_R2.fastq)

### Capture unassigned reads for quality control

Reads that fail barcode matching are silently discarded by default. Use
`--unidentified` to redirect them to a separate file for inspection. Unassigned
reads are annotated with an `obimultiplex_error` attribute indicating the
rejection reason.

In this dataset all reads are successfully assigned, so the unassigned file is
empty:

```bash
obitagpcr \
  --forward-reads wolf_F_4seq.fastq \
  --reverse-reads wolf_R_4seq.fastq \
  --tag-list wolf_diet_ngsfilter.csv \
  --reorientate \
  --unidentified out_unassigned.fastq \
  --out out_identified.fastq
```

```bash
# Count unassigned reads (0 in this dataset)
obicount out_unassigned_R1.fastq
```
```
entities,n
variants,0
reads,0
symbols,0
```

For more on diagnosing rejection causes see the {{< obi obimultiplex >}} page.

### Allow indels in primer and tag matching

By default only substitutions are accepted as differences. For sequencers that
produce indel errors (e.g. Oxford Nanopore), add `--with-indels` to enable full
edit-distance matching of primers. This can also be activated per-primer via
`@param,indels,true` in the NGSFilter file.

```bash
obitagpcr \
  --forward-reads wolf_F_4seq.fastq \
  --reverse-reads wolf_R_4seq.fastq \
  --tag-list wolf_diet_ngsfilter.csv \
  --allowed-mismatches 3 \
  --with-indels \
  --reorientate \
  --out out_indels.fastq
```

The output format is identical to the basic example above. Download a
full-size result (20 reads): [out_indels_R1.fastq](out_indels_R1.fastq)

### Split output by sample with `obidistribute`

Because {{< obi obitagpcr >}} always writes **paired files** (`_R1` and `_R2`),
it cannot be piped directly into {{< obi obidistribute >}}. The two steps must
be run sequentially: first demultiplex with `--out`, then distribute each file
separately.

```bash
obitagpcr \
  --forward-reads wolf_F.fastq \
  --reverse-reads wolf_R.fastq \
  --tag-list wolf_diet_ngsfilter.csv \
  --reorientate \
  --out demux.fastq

obidistribute \
  --classifier sample \
  --pattern "sample_%s_R1.fastq" \
  demux_R1.fastq

obidistribute \
  --classifier sample \
  --pattern "sample_%s_R2.fastq" \
  demux_R2.fastq
```

This produces one R1/R2 pair per sample:
- `sample_13a_F730603_R1.fastq` / `sample_13a_F730603_R2.fastq`
- `sample_15a_F730814_R1.fastq` / `sample_15a_F730814_R2.fastq`
- `sample_26a_F040644_R1.fastq` / `sample_26a_F040644_R2.fastq`
- `sample_29a_F260619_R1.fastq` / `sample_29a_F260619_R2.fastq`
