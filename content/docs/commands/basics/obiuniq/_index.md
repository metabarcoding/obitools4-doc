---
archetype: "command"
title: "obiuniq"
date: 2026-04-07
command: "obiuniq"
category: basics
url: "/obitools/obiuniq"
weight: 130
---

# `obiuniq`: dereplicate sequence data sets

## Description

{{< obi obiuniq >}} groups identical sequences together and replaces each group with a
single representative (a process commonly known as dereplication), 
recording the total number of original occurrences as an abundance count. 
Dereplication is a standard first step in amplicon sequencing workflows. A typical {{% fastq %}} file from an NGS run contains many copies of the same amplicon sequence. Reducing these to unique entries with counts dramatically reduces the computational burden on downstream tools.

By default, two sequences are considered identical if and only if their nucleotide strings
are exactly the same. {{< obi obiuniq >}} scans through all input sequences, grouping the duplicates and writing one record per group in {{% fasta %}} format. The output record randomly inherits the identifier of one of the sequences in the group and carries a 'count' attribute recording how many input sequences it represents. Only information shared by all members of the sequence group is transferred to the representative sequence. Therefore, quality information is discarded from 
{{% fastq %}} files because two identical sequences never have the same sequencing qualities.

{{< mermaid class="workflow" >}}
graph TD
  A@{ shape: doc, label: "reads.fastq" }
  C[obiuniq]
  D@{ shape: doc, label: "out_basic.fasta" }
  A --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}

The file [reads.fastq](reads.fastq) contains eight amplicon reads from two samples.
Several reads share the same nucleotide sequence, representing genuine replication in the
sequencing library.

{{< code "reads.fastq" fastq true >}}

Running {{< obi obiuniq >}} collapses all duplicates into unique representatives:

```bash
obiuniq reads.fastq > out_basic.fasta
```

{{< code "out_basic.fasta" fasta true >}}

The eight input reads are reduced to four unique sequences. The `count` attribute records how
many reads were merged into each representative. For example, `seq001` (ATCGATCG…) appeared four times
across both samples and now carries `"count":4`. As, the sequence `seq001` occurs in samples **S1** and **S2**,
the `sample` information is not shared among all the sequences identical to `seq001`'; this information is discarded in the {{< obi obiuniq >}} result. Note that {{< obi obiuniq >}} always
produces {{% fasta %}} output, even from {{% fastq %}} input, because quality scores
cannot be meaningfully combined across merged reads.


When the same sequence occurs in multiple experimental samples and per-sample abundance matters, grouping by sequence alone can be too aggressive. The `--category-attribute` option (short: `-c`) adds metadata fields to the grouping criterion. This option can be used as many times as needed. Now, sequences are only merged if they are nucleotide-identical and share the same value for every listed attribute. In the example below, we categorise by sample. Thus, the previous group containing `seq001` (*ATCGATCG...*) is now split into two, one for each sample **S1** and **S2**.

```bash
obiuniq -c sample reads.fastq > out_per_sample.fasta
```

{{< code "out_per_sample.fasta" fasta true >}}

Another solution is to track sample contributions across merged groups using the `--merge` option.

This option reverts to the four sequence variants observed in the first example. However, the `merged_sample` attribute shows where each representative sample originated from by recording how many reads from each sample were merged into each group.

```bash
obiuniq --merge sample reads.fastq > out_merge.fasta
```

{{< code "out_merge.fasta" fasta true >}}

Whether you choose the `-c` or the `-m` option depends on how you will process your data later on.
If you plan to process your data using methods that process sequences sample by sample, 
it is better to use the `-m` option and to process the result file using the {{< obi obidistribute >}} command.

```bash 
obiuniq -c sample reads.fastq \
  | obidistribute -p sample_%s.fasta -c sample 
```

This pipeline produces two files [`sample_s1.fasta`](sample_s1.fasta) and [`sample_s2.fasta`](sample_s2.fasta)

{{< code "sample_s1.fasta" fasta true >}}
{{< code "sample_s2.fasta" fasta true >}}

However, with this approach, the explicit information that seq001 and seq006 are identical and shared by two samples is lost.

The {{% obitools4 %}} algorithms process all samples' data at once to identify OTUs shared among samples. This is why, in a pipeline based on {{% obitools4 %}}, the {{< obi obiuniq >}} `-m` option is usually preferred over the `-c` option. 

## Synopsis

```bash
obiuniq [--batch-mem <string>] [--batch-size <int>] [--batch-size-max <int>]
        [--category-attribute|-c <CATEGORY>]... [--chunk-count <int>]
        [--compress|-Z] [--csv] [--debug] [--ecopcr] [--embl]
        [--fail-on-taxonomy] [--fasta] [--fasta-output] [--fastq]
        [--fastq-output] [--genbank] [--help|-h|-?] [--in-memory]
        [--input-OBI-header] [--input-json-header] [--json-output]
        [--max-cpu <int>] [--merge|-m <KEY>]... [--na-value <NA_NAME>]
        [--no-order] [--no-progressbar] [--no-singleton]
        [--out|-o <FILENAME>] [--output-OBI-header|-O] [--output-json-header]
        [--pprof] [--pprof-goroutine <int>] [--pprof-mutex <int>]
        [--raw-taxid] [--silent-warning] [--skip-empty] [--solexa]
        [--taxonomy|-t <string>] [--u-to-t] [--update-taxid] [--version]
        [--with-leaves] [<args>]
```

## Options

#### {{< obi obiuniq >}} specific options

- {{< cmd-option name="category-attribute" short="c" param="CATEGORY" >}}
  Adds one metadata attribute to the grouping criterion. Two sequences are placed in the
  same group only when they are nucleotide-identical **and** share the same value for every
  attribute listed with `-c`. Can be repeated to combine multiple attributes (e.g.
  `-c sample -c primer`). Records missing a listed attribute receive the value set by
  `--na-value`.
  {{< /cmd-option >}}

- {{< cmd-option name="chunk-count" param="int" >}}
  Controls how many internal partitions the dataset is split into during processing
  (default: `100`). A higher value reduces per-partition memory usage at the cost of more
  temporary files; a lower value reduces I/O at the cost of higher peak memory.
  {{< /cmd-option >}}

- {{< cmd-option name="in-memory" >}}
  Stores intermediate data chunks in RAM rather than in temporary disk files. Speeds up
  processing for datasets that fit comfortably in available memory; omit this flag for
  large datasets that exceed available RAM.
  {{< /cmd-option >}}

- {{< cmd-option name="merge" short="m" param="KEY" >}}
  Creates an output attribute named `merged_KEY` that maps each observed value of the
  `KEY` attribute to the count of input sequences carrying that value within the group.
  Can be repeated to track multiple attributes. Useful for tracking which sample or
  category contributions were collapsed into each group.
  {{< /cmd-option >}}

- {{< cmd-option name="na-value" param="NA_NAME" >}}
  Value assigned to a category attribute when a sequence record does not carry that
  attribute (default: `"NA"`). All sequences lacking the attribute are grouped together
  under this placeholder.
  {{< /cmd-option >}}

- {{< cmd-option name="no-singleton" >}}
  Discards all output records whose abundance count is exactly one — i.e., sequences that
  occur only once across the entire input. Removing singletons is a standard heuristic
  for excluding a large part of the PCR artifacts, and sequencing errors from further analysis.
  {{< /cmd-option >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

- {{< cmd-option name="fail-on-taxonomy" >}}
  Cause [`obiuniq`](../obiuniq) to exit with an error if a taxid in the data is not a
  currently valid taxon in the loaded taxonomy.
  {{< /cmd-option >}}

- {{< cmd-option name="raw-taxid" >}}
  Print taxids in output without supplementary information (taxon name and rank).
  {{< /cmd-option >}}

- {{< cmd-option name="update-taxid" >}}
  Automatically replace merged taxids with the most recent valid taxid.
  {{< /cmd-option >}}

- {{< cmd-option name="with-leaves" >}}
  When taxonomy is extracted from a sequence file, add sequences as leaves of their
  taxid annotation.
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

**Dealing with missing data**

With the `-c` and `-m` option, {{< obi obiuniq >}} relies on values stored in attributes that can be not valuated for some sequences. In that case, a placerhold value (**NA** by default) is substuted to the missing information.

{{< code "reads_missing.fastq" fastq true >}}

```bash
obiuniq --merge sample \
        reads_missing.fastq \
    > out_missing.fasta
```
{{< code "out_missing.fasta" fasta true >}}

The `--na-value` option allows for choosing this placerhold value.

```bash
obiuniq --merge sample \
        --na-value UNKWNON \
        reads_missing.fastq \
    > out_unknown.fasta
```
{{< code "out_unknown.fasta" fasta true >}}

**Dereplicate across two files with no assumed ordering, grouping by sample and primer:**

The files [sample1.fastq](sample1.fastq) and [sample2.fastq](sample2.fastq) contain reads
from two independent sequencing files covering two primers. Using `--no-order` signals that
the files have no implicit read-pairing relationship. Grouping by both `sample` and `primer`
keeps distinct amplicon types separate, producing one representative per unique
(sequence, sample, primer) combination.

{{< code "sample1.fastq" fastq true >}}

{{< code "sample2.fastq" fastq true >}}

```bash
obiuniq --no-order \
        -c sample \
        -c primer \
        sample1.fastq sample2.fastq \
    > out_multifile.fastq
```

{{< code "out_multifile.fastq" fasta true >}}

**Use in-memory chunking for faster processing of small datasets:**

For datasets that fit comfortably in RAM, `--in-memory` avoids temporary disk I/O and
speeds up dereplication. The `--chunk-count` parameter controls how many internal partitions
are used (here increased to `200` for finer granularity). The `--compress` flag writes the
output as a gzip-compressed file.

```bash
obiuniq --in-memory \
        --chunk-count 200 \
        --compress \
        --out out_inmemory.fasta.gz \
        reads.fastq
```

** printing the command help **

```bash
obiuniq --help
```
