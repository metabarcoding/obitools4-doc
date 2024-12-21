---
archetype: command
title: "Obipairing: Align the forward and reverse paired reads"
command: obipairing
category: alignments
url: "/obitools/obipairing"
---

## `obipairing`: Align the forward and reverse paired reads

### Description 

When DNA metabarcoding sequences are generated as paired reads on the Illumina platform, {{< obi obipairing >}} aims to align both forward and reverse reads to generate full length amplicon sequences.

#### Input data

The {{< obi obipairing >}} command requires two input files:

- One file contains the forward reads.
- The second file contains the reverse reads.

Both files must have the same number of sequences, and the sequences must be in the same order. This means that the first sequence of the forward reads file must correspond to the first sequence of the reverse reads file. {{< obi obipairing >}} will assume this order and only align sequences that occur in the same rank.

Consider the following example, where the forward reads file is `forward.fastq` and the reverse reads file is `reverse.fastq` and both consist of 4 sequences:

- [`forward.fastq`]({{< static "examples/obipairing/forward.fastq" >}}):
  
```
@LH00534:26:2237MWLT1:2:1101:3663:1096 1:N:0:AAGATACT+ATGTAAGT
TCCAGGGCAATCCTGAGCCAAATCTTCTTTTTGAGAAAAAGAAATATATAAAATATTTCTTATTTCAGATAAGAAATAATATTTTTTCTTATCTAATATTAAAGATAGGTGCAGAGACTCAATGGTGGATTGCAGATCGGAAGAGCACACG
+
IIIII9IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII9IIIIIIIII9IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII9IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
@LH00534:26:2237MWLT1:2:1101:4643:1096 1:N:0:AAGATACT+ATGTAAGT
ATAACGCTCCCCTTGAGTCTCTGCACCTATCCTTTTTGATTCTAGTTTTTATAGAGAAACACATTTTCTCCAGATTCAGATTTGGCTCAGGATTGCCCGAGCGTTATAGATCGGAAGAGCACACGTCTGAACTCCAGTCACCAGATACTAT
+
IIIII-I9III-9IIII9IIIIII9IIIIIIIIIIIIIIIIIII-99-III-IIII9IIII99-9I99I999I-9I-IIIIII-9I9I9I9IIIIIII99I9I99II9-III99III9IIIII9IIIII9IIIIIIIII9I-IIII9IIII
@LH00534:26:2237MWLT1:2:1101:5327:1096 1:N:0:AAGATACT+ATGTAAGT
GCTTGTGACCCATTGAGTCTCTGCACCTATCCTTTTCCTTTGTATTCTAGTTCGAGAACCCCCTTGTTTTCTCAAAACACGGATTTGGCTCAGGATTGCCCTTGGATGGTAGATCGGAAGAGCACACGTCTGAACTCCAGTCACAAGATAC
+
IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
@LH00534:26:2237MWLT1:2:1101:5512:1096 1:N:0:AAGATACT+ATGTAAGT
CAACCCAGGGGCAATCCTGAGCCAAATCCGTGTTTTGAGAAAACAAGGGGGTTCTCGAACTAGAATACAAAGGAAAAGGATAGGTGCAGAGACTCAATGGCTTGGTTGAGATCGGAAGAGCACACGTCTGAACTCCAGTCACAAGATACTA
+
IIIII--III9II9IIIIII-IIII9IIIIIIIIIIIIIIIII-I9IIIIIIII9IIIIIII9II9IIIII99II-IIIIII-9II9IIII-9I-II9III9I9II99I9I-9-I999-I99III99I9I-III9IIIIIIIIII9IIIII
```

- [`reverse.fastq`]({{< static "examples/obipairing/reverse.fastq" >}}):
  
```
@LH00534:26:2237MWLT1:2:1101:3663:1096 2:N:0:AAGATACT+ATGTAAGT
GCAATCCACCATTGAGTCTCTGCACCTATCTTTAATATTAGATAAGAAAAAATATTATTTCTTATCTGAAATAAGAAATATTTTATATATTTCTTTTTCTCAAAAAGAAGATTTGGCTCAGGATTGCCCTGGAAGATCGGAAGAGCGTCGT
+
99IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII9III9I-IIIIIIIIIIIIIIIIIIIIIIIIII-IIIIIIIIIIIIIIIIIIIIIIIIII9III9IIIIIIIIIIIIIIIIIIIIIIII9IIIII9IIIIIIII9II
@LH00534:26:2237MWLT1:2:1101:4643:1096 2:N:0:AAGATACT+ATGTAAGT
ATAACGCTCGGGCAATCCTGAGCCAAATCTTAATCTGGAGAAAATGTGTTTCTCTATAAAAACTAGAATCAAAAAGGATAGGTGCAGAGACTCAATGGGAGCGTTATAGATCGGAAGAGCGTCGTGTAGGGAAAAAGCGTATGTAAATGTT
+
-I99I-IIIIII9I9IIII9-III9I-II9IIIIIIIII9IIII9II-IIIIIIIIIIIIIIIII-II-II9III9IIIIIIIIIIII9IIIIIIIIIIIIII9-9IIII9IIIIIII-I9IIIII-9-9I9I9-99-9999-I-I--9--
@LH00534:26:2237MWLT1:2:1101:5327:1096 2:N:0:AAGATACT+ATGTAAGT
ACCATCCAAGGGCAATCCTGAGCCAAATCCGTGTTTTGAGAAAACAAGGGGGTTCTCGAACTAGAATACAAAGGAAAAGGATAGGTGCAGAGACTCAATGGGTCACAAGCAGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTATGTAAGT
+
IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII9III9-II-III
@LH00534:26:2237MWLT1:2:1101:5512:1096 2:N:0:AAGATACT+ATGTAAGT
CAACCAAGCCATTGAGTCTCTGCACCTATCCTTTTCCTTTGTATTCTCGTTCGAGAACCCCCTTGTTTTCTCAAAACACGGATTTGGCTCAGGATTGCCCCTTGGTTGAGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTATGTAAGTGT
+
I9IIIIIIIIIIIIIIIIIIIIIIIIIIIII9IIIIIIIIIIIIIII-IIIIIIIIIIIII9II9II9IIIIII9IIIIIII9I9IIIIIIIIIIIIIII-IIIIIIIIIIIIIIIIIIIIIIIIIII9IIIIII-IIIIII99III--9I
```

The sequence first sequence of the `forward.fastq` file having the id `LH00534:26:2237MWLT1:2:1101:3663:1096` will be paired with the first sequence of the `reverse.fastq` file having the same id `LH00534:26:2237MWLT1:2:1101:3663:1096`, not because they have the same identifier but because they are both the first sequence of their respective files.

#### The simplest {{< obi obipairing >}} command


The minimal {{< obi obipairing >}} command to align the `forward.fastq` and `reverse.fastq` files is:

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

it will produce a file named [`paired.fastq`]({{< static "examples/obipairing/paired.fastq" >}}) with the following content:

```
@LH00534:26:2237MWLT1:2:1101:3663:1096 {"ali_dir":"right","ali_length":133,"definition":"1:N:0:AAGATACT+ATGTAAGT","mode":"alignment","paring_fast_count":130,"paring_fast_overlap":133,"paring_fast_score":1,"score":1860,"score_norm":1,"seq_a_single":18,"seq_ab_match":133,"seq_b_single":18}
acgacgctcttccgatcttccagggcaatcctgagccaaatcttctttttgagaaaaagaaatatataaaatatttcttatttcagataagaaataatattttttcttatctaatattaaagataggtgcagagactcaatggtggattgcagatcggaagagcacacg
+
II9IIIIIIII9IIIII9qqqqqaqqqqqqqqqqqqqqqqqqaqqqaqqqqqqqqqqqqqqqqqqqqqqaqqqUqqqqqaqqqqqqqqqqqqqqqqqqqqUqaqqqaqqqqqqqqqqqqqqqqqqqqqqqaqqqqqqqqqqqqqqqqqqaaIIIIIIIIIIIIIIIIII
@LH00534:26:2237MWLT1:2:1101:4643:1096 {"ali_dir":"right","ali_length":107,"definition":"1:N:0:AAGATACT+ATGTAAGT","mode":"alignment","pairing_mismatches":{"(C:12)->(A:40)":121},"paring_fast_count":96,"paring_fast_overlap":107,"paring_fast_score":0.923,"score":1409,"score_norm":0.981,"seq_a_single":44,"seq_ab_match":105,"seq_b_single":44}
aacatttacatacgctttttccctacacgacgctcttccgatctataacgctcccattgagtctctgcacctatcctttttgattctagtttttatagagaaacacattttctccagattaagatttggctcaggattgcccgagcgttatagatcggaagagcacacgtctgaactccagtcaccagatactat
+
--9--I-I-9999-99-9I9I9-9-IIIII9I-IIIIIII9IIIqaUaqUqaqqqJaqqqqaaqqqqqaqqqqqqaqqqaqqUqqUqqUaaUqqqUqqqqaqqUqaQUaqaQqaaaqUaqJaqqUqaUaqEaaqaqaqaqqqaaqEqQQqU9-III99III9IIIII9IIIII9IIIIIIIII9I-IIII9IIII
@LH00534:26:2237MWLT1:2:1101:5327:1096 {"ali_dir":"right","ali_length":110,"definition":"1:N:0:AAGATACT+ATGTAAGT","mode":"alignment","paring_fast_count":107,"paring_fast_overlap":110,"paring_fast_score":1,"score":1540,"score_norm":1,"seq_a_single":41,"seq_ab_match":110,"seq_b_single":41}
acttacatacactctttccctacacgacgctcttccgatctgcttgtgacccattgagtctctgcacctatccttttcctttgtattctagttcgagaacccccttgttttctcaaaacacggatttggctcaggattgcccttggatggtagatcggaagagcacacgtctgaactccagtcacaagatac
+
III-II-9III9IIIIIIIIIIIIIIIIIIIIIIIIIIIIIqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
@LH00534:26:2237MWLT1:2:1101:5512:1096 {"ali_dir":"right","ali_length":108,"definition":"1:N:0:AAGATACT+ATGTAAGT","mode":"alignment","pairing_mismatches":{"(C:12)->(A:40)":49,"(T:40)->(G:12)":104},"paring_fast_count":97,"paring_fast_overlap":108,"paring_fast_score":0.924,"score":1430,"score_norm":0.981,"seq_a_single":43,"seq_ab_match":106,"seq_b_single":43}
acacttacatacactctttccctacacgacgctcttccgatctcaaccaaggggcaatcctgagccaaatccgtgttttgagaaaacaagggggttctcgaactagaatacaaaggaaaaggataggtgcagagactcaatggcttggttgagatcggaagagcacacgtctgaactccagtcacaagatacta
+
I9--III99IIIIII-IIIIII9IIIIIIIIIIIIIIIIIIIIqqqqqJUUqqaqqaqqqqqqUqqaqQqqqqqqqaqqqqqqaqqEqaaqqqqqqqaqqqqqJqaqqaqqqqqaaqqUaqqqqqUaqqaqqqqUaqUqqaqqqaqaqqQaI9I-9-I999-I99III99I9I-III9IIIIIIIIII9IIIII
```

#### The alignment process

{{< obi obipairing >}} will align the reads following a two-step procedure to increase computation speed. The first step aligns the reads using a [FASTA derived algorithm](https://en.wikipedia.org/wiki/FASTA). Based on results of the first step, a second alignment step is on the overlapping region only using an exact dynamic programming algorithm.

##### The FASTA like first step alignment

That alignment allows for identifying the overlapping region of the reads, its position and its extent. Based on this results the best alignment procedure is selected for the second step, and the parts of the reads to be aligned are determined.

#### The annotation added to the FASTQ header for each read

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

### Synopsis

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

### Options

#### {{< obi obipairing >}} mandatory options

- {{< cmd-option name="forward-reads" short="F" param="FILENAME" >}}
  The name of the file containing the forward reads.
  {{< /cmd-option >}}

- {{< cmd-option name="reverse-reads" short="R" param="FILENAME" >}}
  The name of the file containing the reverse reads.
  {{< /cmd-option >}}


#### Other {{< obi obipairing >}} specific options:

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
  Gap penality expressed as the multiply factor applied to the mismatch score between two nucleotides with a quality of 40 (default 2). (default: 2.000000)
  {{< /cmd-option >}}

- {{< cmd-option name="min-identity" short="X" param="FLOAT64" >}}
  Minimum identity between ovelaped regions of the reads to consider the aligment (default: 0.900000).
  {{< /cmd-option >}}

- {{< cmd-option name="min-overlap" param="INTEGER" >}}
  Minimum overlap between both the reads to consider the aligment (default: 20).
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

### Examples

```bash
obipairing --help
```
