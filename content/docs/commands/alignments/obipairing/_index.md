---
archetype: command
title: "obipairing"
date: 2025-02-10
command: obipairing
category: alignments
url: "/obitools/obipairing"
bookCollapseSection: true
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

Consider the following example, where the forward reads file is [`forward.fastq`](forward.fastq) and the reverse reads file is [`reverse.fastq`](reverse.fastq) and both consist of 4 sequences:


{{< code "forward.fastq" fastq true >}}
  
{{< code "reverse.fastq" fastq true >}}

The first sequence of the [`forward.fastq`](forward.fastq) file having the id `LH00534:26:2237MWLT1:2:1101:3663:1096` will be paired with the first sequence of the [`reverse.fastq`](reverse.fastq) file having the same id `LH00534:26:2237MWLT1:2:1101:3663:1096`, not because they have the same identifier but because they are both the first sequence of their respective files.

### The simplest {{< obi obipairing >}} command

The minimal {{< obi obipairing >}} command to align the [`forward.fastq`](forward.fastq) and [`reverse.fastq`](reverse.fastq) files is:

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

it will produce a file named [`paired.fastq`](paired.fastq) with the following content:

{{< code "paired.fastq" fastq true >}}


### The alignment process

{{< obi obipairing >}} will align the reads following a two-step procedure to increase computation speed.

#### A fast alignment to determine quickly the overlap

The first step aligns the reads using a [FASTA-derived algorithm](fasta-like).
Based on results of the first step, a second alignment step is on the overlapping region only using an exact dynamic programming algorithm taking into account sequence quality scores present in the {{% fastq %}} files. It is possible to disable this first alignment step at the cost of an increase in the computation time by using the `--exact-mode` option.

The first fast alignment step adds three tags are added to the FASTQ header for each read to report the results of this first step alignment.

- `paring_fast_count` : Number of kmer shared on the main diagonal of the [fasta dot plot]({{< relref "fasta-like#dotplot" >}}).
- `paring_fast_overlap` : Length of the overlap as detected by this algorithm in nucleotides.
- `paring_fast_score` : The pairing fast score is the number of shared 4mer on the main diagonal of the [fasta dot plot]({{< relref "fasta-like#dotplot" >}}) (`paring_fast_count`) by the number of 4mer involved in the overlapping region of the reads ({{< katex >}}paring\_fast\_overlap - 3{{< /katex >}})
  {{< katex display=true >}}
  paring\_fast\_score = \frac{paring\_fast\_count}{paring\_fast\_overlap - 3}
  {{< /katex >}}

- The `--fasta-exact` option allows changing the [best alignment selection]({{< relref "fasta-like#fasta-scores" >}}) from the one with the highest `paring_fast_score` (the default behavior) to the one with the highest `paring_fast_count`.

- The `--exact-mode` option tells {{< obi obipairing >}} to bypass this first alignment step and proceed directly to the exact alignment, at the cost of a largest computation time.

#### The exact alignment of the overlapping regions

Once the overlap has been quickly identified using the [FASTA-derived algorithm] (fasta-like), the overlapping region as detected in this first step is extended by {{< katex >}}\delta{{< /katex >}} nucleotides at each end ({{< katex >}}\delta = 5{{< /katex >}} by default and can be defined with the `--delta` option) to be exactly aligned using a [semi-global alignment algorithm](exact-alignment) taking into account the sequence quality scores present in the {{% fastq %}} files. There are two versions of this algorithm, [the *left-align* and the *right-align* version](exact-alignment/#left-and-right-alignment). Which one is used, left or right, depends on the length of the amplicon. Amplicons longer than the read length will be aligned with the left version. The shorter ones are aligned with the right version.

When the `--exact-mode` option is used, full length reads are aligned twice, once with the left version and once with the right version. The alignment with the highest score is used. This consequently increases the computation time.

The exact alignment step adds the following tags to the FASTQ header for each read to report the quality of the alignment.

- `ali_dir`: indicates the mode of the used exact alignment *left* or *right*.
- `ali_length`: The length of the aligned overlapping region (including gaps).
- `seq_a_single`: The length of the unaligned region on the forward read.
- `seq_ab_match`: The number of matches in the aligned overlapping region.
- `seq_b_single`: The length of the unaligned region on the reverse read.
- `score`: The row score of the alignment (the sum of the [elementary scores for each aligned position]({{< relref "exact-alignment#scoring-system">}})).
- `score_norm`: `seq_ab_match` divided by `ali_length`.
- `pairing_mismatches`: A description of the mismatches between the reads (this tag is not added if the `--without-stat` is set). It is expressed as a JSON map with keys describing the mismatch and values corresponding to the position of the mismatch in the reconstructed full length amplicon.
  ```json
  {"(C:12)->(A:40)":49,"(T:40)->(G:12)":104}
  ```
  This example describes the two mismatches found in the overlapping region:
    - A *C* with a quality score of 12 on the forward read is aligned to an *A* with a quality score of 40 on the reverse read at position 49.
    - A *T* with a quality score of 40 on the forward read aligns to a *G* with a quality score of 12 on the reverse read at position 104.

### Building the consensus sequence

If the overlap length is below a threshold (20 by default, and can be set using the `--min-overlap` option), or the `score_norm` is below an identity threshold (0.9 by default, and can be set using the `--min-identity` option), no consensus is computed for the read pair. Both sequences are only pasted together with a set of `.` separating the forward read and the reverse complementary sequence of the reverse read. In this case, the sequence is tagged with a `mode` attribute set to `join`.

If the overlap is long enough and the identity is sufficient, a consensus sequence is built to maximize the global sequencing quality of the reconstructed amplicon. The non-aligned regions are reported as they are. The overlapping regions are transcribed as follows:
- For each match, the base observed on both reads is conserved, and the quality score is increased to reflect the congruence of the two reads. 
  {{< katex display=true >}}Q_{consensus} = Q_F + Q_R{{< /katex >}}
- If there is a mismatch, the base with the highest quality score is retained and its quality score is decreased to reflect the discrepancy between the two reads (with {{< katex >}}Q_{max} = max(Q_F, Q_R){{< /katex >}} and {{< katex >}}Q_{min} = min(Q_F, Q_R){{< /katex >}}).
  {{< katex display=true >}}Q_{consensus} = \log_{10} \left(10^{-\frac{Q_max}{10}} \cdot \frac{1 - 10^{-\frac{Q_min}{10}}}{4} \right){{< /katex >}}
- In case of an insertion or a deletion, the gap will be affected with a quality of 0 and the mismatch rules will be applied. This means that insertions and deletions are always considered as insertions in the consensus sequence.
  
A `mode` attribute set to `alignment` will be added to the consensus sequence annotations.


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

- {{< cmd-option name="gap-penalty" short="G" param="FLOAT64" >}}
  Gap penalty expressed as the multiply factor applied to the mismatch score between two nucleotides with a quality of 40 (default 2). (default: 2.000000)
  {{< /cmd-option >}}

- {{< cmd-option name="min-identity" short="X" param="FLOAT64" >}}
  Minimum identity between overlapped regions of the reads to consider the alignment (default: 0.900000).
  {{< /cmd-option >}}

- {{< cmd-option name="min-overlap" param="INTEGER" >}}
  Minimum overlap between both the reads to consider the alignment (default: 20).
  {{< /cmd-option >}}

- {{< cmd-option name="penalty-scale" param="FLOAT64" >}}
  Scale factor applied to the mismatch score and the gap penalty (default 1).
  {{< /cmd-option >}}

- {{< cmd-option name="without-stat" short="S" >}}
  Remove alignment statistics from the produced consensus sequences (default: false).
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

### Basic example

Considering two small fastq files containing each one, four sequences and named `forward.fastq` and `reverse.fastq`. The following command will align them and produce a file named `paired.fastq` containing the full length amplicon sequences:

```bash
obipairing -F forward.fastq -R reverse.fastq > paired.fastq
```

A bar plot presenting the frequencies of the aligned and joint pairs of reads can be built by combining the output of the {{< obi obicsv >}} command with the `uplot` command:

```bash
obicsv -k mode paired.fastq | uplot -H count
```
```
                              mode
             ┌                                        ┐ 
   alignment ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 2.0   
        join ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 2.0   
             └                                        ┘ 
```

It is possible to use the {{< obi obidistribute >}} tool to separate the reads according to their `mode` attribute valued to `join` or `alignment`:

```bash
obidistribute -p "paired_%s.fastq" -c mode paired.fastq
```

This command will produce two files named `paired_join.fastq` and `paired_alignment.fastq` containing the sequences with `mode` set to `join` or `alignment` respectively.

By observing the content of the `paired_join.fastq` file, we can see that the first pair of reads was not aligned because of the `score_norm` tag smaller than the default identity threshold of 0.9, while the second pair of reads was aligned because of the length of the overlap (`ali_length` tag) is smaller than the default minimum overlap of 20.

{{< code "paired_join.fastq" "fastq" true >}}

By observing the content of the `paired_alignment.fastq` file, we can see (`mode` tag) that the first pair of reads was aligned using the *right* version of the exact alignment algorithm, while the second pair of reads was aligned using the *left* version.

{{< code "paired_alignment.fastq" "fastq" true >}}

### Pairing the reads in exact mode

```bash
obipairing -F forward.fastq -R reverse.fastq \
           --exact-mode > paired_exact.fastq
```
{{< code "paired_exact.fastq" "fastq" true >}}

On that trivial data set, both results, `paired.fastq` and `paired_exact.fastq`, are identical in terms of consensus sequence.
But annotations are different. By using the diff UNIX command, it's possible to compare the two files:

```bash
diff -u paired.fastq paired_exact.fastq
```
```diff
--- paired.fastq        2025-02-23 16:50:12
+++ paired_exact.fastq  2025-02-23 17:24:37
@@ -2,15 +2,15 @@
 tgttccacgggcaatcctgagccaaatctttcattttgaaaaaatgagagatataatgtatctcttatttattataagaaataaaatatttcttatctaatattaaagttaggtgcagagactcaatgggtggaactagatcggatgtgca..........agcaaaaaagaacaagtaacaagggaaaaccagagaaaaatcaataaaaaagaaaaaaagagagatataaagtatcaataaaataaaaaaagaaaaaaaataataaaaaactaataaaaaagaaaggtgcagagaaaaaaagggaggaaaa
 +
 11>A>@3@A11>ACFFEG110BFB00BAFGHE2DFGG201110/B11111/D1D2222D2FDFDFGDGHHBGG2F222110D11@1D1FGHFHGFF@GE1F2FG22112B220F1@111/0>BF11B210B>//11B1<1BB<///<1122!!!!!!!!!!11--111111?111@11110?1112/@@11122@011FBB2121//B1111CEEHGFB11F2B2B2B2DFB12@212122B21/>/1D1GF>>EA1GGDD2D1///22B222GD/E11GGFAB1B0A313B3B0A111BB1111311>>11
-@M01334:147:000000000-LBRVD:1:1101:15946:1586 {"ali_dir":"right","ali_length":138,"definition":"1:N:0:CTCACCAA+CTAGGCAA","mode":"alignment","pairing_mismatches":{"(T:16)->(A:33)":14,"(T:33)->(A:17)":118,"(T:37)->(A:16)":125,"(T:38)->(A:16)":32,"(T:39)->(A:17)":44},"paring_fast_count":114,"paring_fast_overlap":138,"paring_fast_score":0.844,"score":5446,"score_norm":0.957,"seq_a_single":13,"seq_ab_match":132,"seq_b_single":13}
+@M01334:147:000000000-LBRVD:1:1101:15946:1586 {"ali_dir":"right","ali_length":138,"definition":"1:N:0:CTCACCAA+CTAGGCAA","mode":"alignment","pairing_mismatches":{"(T:16)->(A:33)":14,"(T:33)->(A:17)":118,"(T:37)->(A:16)":125,"(T:38)->(A:16)":32,"(T:39)->(A:17)":44},"score":5446,"score_norm":0.957,"seq_a_single":13,"seq_ab_match":132,"seq_b_single":13}
 gctcatccgaactacctaaccccattgagtctctgcacctatctttaatattagataagaaatattttatttcttataataaataagagatattttatatctctcattttttcaaaatgaaagatttggctcaggattgcccacgtaacggagatcggaagagc
 +
 111/////2B112CMMOUO?MNObVHfcAVVHVWVVTQSWRXXIYYYXUSWiXaWeWWUWVSTTTWXgeUWWXXXWWgXWYYWVYWdUgSTTTXYYUVdTVWVXVgUWXXXVeYXfTCUXWW`QGUWfA@WSR?PRRWVARAc?UVMMOO?///BF////<000
-@M01334:147:000000000-LBRVD:1:1101:15399:1590 {"ali_length":4,"definition":"1:N:0:CTCACCAA+CTAGGCAA","mode":"join","score":126,"score_norm":1,"seq_ab_match":4}
+@M01334:147:000000000-LBRVD:1:1101:15399:1590 {"ali_length":137,"definition":"1:N:0:CTCACCAA+CTAGGCAA","mode":"join","score":3033,"score_norm":0.796,"seq_ab_match":109}
 tgttccacccattgagtctctgcacctatctttaatattagataagaaatattttacttcttataataaataagagttattttatatctctcattttttcaaaatgaaagatttggctcaggattgcccgtggaactagatcggaagagca..........agcaaaaaagaaaaagtaaaacaaaatgagaaaaagcaactaaatttaatattagataagaaatataatactacataaaataaataagagatattttatatctctaaatttttcaaaaggaaagatttggctcaggatagcccgaggaaaa
 +
 11>A>@3B>>1CF111BBFAG3A3AAF1FFGHHF3FBGH221F211110D1DGHH2BBGBFF2F22D221D211111A2DDGG2F2FFFEGD1FFHHHGFD221B111110BFGD11F@1001BF0@@1/EA//1>F1B1FD/////00<1!!!!!!!!!!11//111110B122B12000B222B222B01111111@122B22122ED2B12F@D2GF2FAD2D2222D222212D2GF2HGD1GFADAD1D1222D1D111221B0011101GFDD12FFD1B000A1011B11B1111111311>>11
-@M01334:147:000000000-LBRVD:1:1101:13773:1687 {"ali_dir":"left","ali_length":54,"definition":"1:N:0:CTCACCAA+CTAGGCAA","mode":"alignment","pairing_mismatches":{"(C:39)->(A:16)":102,"(C:39)->(A:17)":121,"(T:39)->(A:14)":101},"paring_fast_count":42,"paring_fast_overlap":54,"paring_fast_score":0.824,"score":2888,"score_norm":0.944,"seq_a_single":97,"seq_ab_match":51,"seq_b_single":97}
+@M01334:147:000000000-LBRVD:1:1101:13773:1687 {"ali_dir":"left","ali_length":54,"definition":"1:N:0:CTCACCAA+CTAGGCAA","mode":"alignment","pairing_mismatches":{"(C:39)->(A:16)":102,"(C:39)->(A:17)":121,"(T:39)->(A:14)":101},"score":2888,"score_norm":0.944,"seq_a_single":97,"seq_ab_match":51,"seq_b_single":97}
 ctcggatcaccattgagtctctgcacctatctttaatattagataagaaaaaatattatttcttatctgaaataagaaatattttatatatttctttttctcaaaatgaaagatttggctcaggattgccctgatccgagggatagcaccattgagtctctgcacctatccttttcttttgtattctagttcgagaacccccttgttttctcaaaacacggatttggctcaggatagccctgctatca
 +
 3AAAAAADFFFFGGGGFGGGGGHHHHHHFHHHHHHHHGHHHHGHGGHFFHHHCGFHHHHHHHHHHHHHGHHGGFHFFHHHGHHHHBHHHGHHHHHHHXVVJIommmegikl]bVWgVDRXIlbkkVfPSWVWccVVT^ebggjkkCVeWcd1@CF>0/11@11B011F0/0000/00111@@D1111GA01AFGCEEE///0//BAFD0000HGGFAB011B00CBAB11FA1B11>1111@31>111
```

 You can confirm that only the description line of the sequences has been changed. They are the only ones that start with a `+` or a `-` character at the first column. The lines that start with `-` are the ones from the `paired.fastq` file. The lines that start with `+` are the ones from the `unpaired.fastq` file. Lines that start with ` ` are identical in both files.

 For the two aligned sequences, the tags describing the fast alignment done at first are absent in the `paired_exact.fastq` file, because the [FASTA-derived algorithm](fasta-like) is not run when the `--exact-mode` option is used.

The second joined sequence pair with the `--exact-mode` as now a very long overlap of 137 bases, opposed to 4 bases in the previous command, but the `score_norm` value is only 0.796, which is much lower than the threshold of 0.9, leading to rejecting the alignment.