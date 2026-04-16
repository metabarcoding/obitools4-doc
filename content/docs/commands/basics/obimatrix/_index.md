---
archetype: "command"
title: "obimatrix"
date: 2026-04-14
command: "obimatrix"
category: basics
url: "/obitools/obimatrix"
weight: 100
---

# `obimatrix`: build a sample × sequence count matrix from annotated sequences

## Description

After a metabarcoding sequencing experiment has been processed through the
{{% obitools4 %}} pipeline:

- paired read alignment: {{< obi obipairing >}}
- PCR demultiplexing: {{< obi obimultiplex >}} 
- sequence dereplication: {{< obi obiuniq >}}

each unique sequence (OTU) carries a `merged_sample` attribute: a dictionary mapping every
sample name to the number of reads that matched that sequence in that sample.
The main aim of {{< obi obimatrix >}} is to read these annotations and assembles them 
into a single **sample × sequence count matrix** (also called an OTU table), 
written in {{% csv %}} format to standard output. By default {{< obi obimatrix >}} works
with the `merged_sample` attribute, but it can apply the same process to any map attribute.


The file [dereplicated.fasta](dereplicated.fasta) below shows what such an annotated
{{% fasta %}} file looks like. Each sequence header carries both the `merged_sample`
map (used to fill the matrix) and additional attributes such as `count`, `taxid`,
and `definition` that can optionally appear as extra annotation columns.

{{< code "dereplicated.fasta" fasta true >}}

{{< mermaid class="workflow" >}}
graph TD
  A@{ shape: doc, label: "dereplicated.fasta" }
  C[obimatrix]
  D([stdout])
  A --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}

By default {{< obi obimatrix >}} the matrix is oriented so that the rows correspond to
samples and the columns to sequences. This is the layout expected by many ecological analysis tools
such as the R packages `vegan` and `phyloseq`. Running {{< obi obimatrix >}} on the
file above produces:

```bash
obimatrix dereplicated.fasta | csvlook
```
```
| id       | seq001 | seq002 | seq003 | seq004 |
| -------- | ------ | ------ | ------ | ------ |
| sample_A |     10 |      0 |      7 |      3 |
| sample_B |      5 |     20 |      0 |      3 |
| sample_C |      0 |      8 |     15 |      3 |
```

The `--map` option selects which sequence attribute to use as the source dictionary
(default: `merged_sample`). This makes it straightforward to pivot on any other
per-sequence map attribute. For example, using the `by_locality` attribute present in
the demo file gives a locality × sequence table instead:

```bash
obimatrix --map by_locality dereplicated.fasta | csvlook
```
```
| id        | seq001 | seq002 | seq003 | seq004 |
| --------- | ------ | ------ | ------ | ------ |
| loc_north |     12 |      0 |     10 |      5 |
| loc_south |      3 |     28 |     12 |      4 |
```

Setting `--transpose` rparameter reverses the orientation, meaning that each row becomes a sequence rather than a sample. In this mode, extra per-sequence annotation columns become available: `--count` appends the total abundance across all samples, `--definition` appends the free-text title, `--taxon` the NCBI taxid, `--sequence` the nucleotide sequence,
and `--quality` the Phred quality string. The option `--keep|k <key>` appends a column corresponding to the key attribute. By default the sequence IDs are not displayed, add the option `--ids`.
These supplementary annotation columns are silently dropped in the default mode because the standard orientation cannot preserve them.

```bash
obimatrix --ids \
          --transpose \
          --count dereplicated.fasta \
    | csvlook
```
```
| id     | count | sample_A | sample_B | sample_C |
| ------ | ----- | -------- | -------- | -------- |
| seq001 |    15 |       10 |        5 |        0 |
| seq002 |    28 |        0 |       20 |        8 |
| seq003 |    22 |        7 |        0 |       15 |
| seq004 |     9 |        3 |        3 |        3 |
```

A third output format, selected with `--three-columns`, produces a long (tidy) table
with one row per (sequence, sample) pair and exactly three columns: sequence ID, sample
name, and count. This format is convenient for import into R's `tidyverse` or
Python's `pandas`.

```bash
obimatrix --three-columns dereplicated.fasta \
   | csvlook
```
```
| id     | sample   | count |
| ------ | -------- | ----- |
| seq004 | sample_A |     3 |
| seq004 | sample_B |     3 |
| seq004 | sample_C |     3 |
| seq001 | sample_A |    10 |
| seq001 | sample_B |     5 |
| seq001 | sample_C |     0 |
| seq002 | sample_A |     0 |
| seq002 | sample_B |    20 |
| seq002 | sample_C |     8 |
| seq003 | sample_C |    15 |
| seq003 | sample_A |     7 |
| seq003 | sample_B |     0 |
```
## Synopsis

```bash
obimatrix [--allow-empty] [--auto] [--batch-mem <string>]
          [--batch-size <int>] [--batch-size-max <int>] [--count] [--csv]
          [--debug] [--definition|-d] [--ecopcr] [--embl] [--fasta] [--fastq]
          [--genbank] [--help|-h|-?] [--ids|-i] [--input-OBI-header]
          [--input-json-header] [--keep|-k <KEY>]... [--map <string>]
          [--map-na-value <string>] [--max-cpu <int>] [--na-value <NAVALUE>]
          [--no-order] [--obipairing] [--pprof] [--pprof-goroutine <int>]
          [--pprof-mutex <int>] [--quality|-q] [--sample-name <string>]
          [--sequence|-s] [--silent-warning] [--solexa] [--taxon]
          [--three-columns] [--transpose] [--u-to-t] [--value-name <string>]
          [--version] [<args>]
```

## Options

#### {{< obi obimatrix >}} specific options

**Matrix construction**

- {{< cmd-option name="map" param="ATTR" >}}
  Name of the sequence attribute used as the sample→count map. The attribute must be a
  dictionary whose keys are sample identifiers and values are integer read counts. In a
  standard {{% obitools4 %}} workflow this attribute is named `merged_sample` and is
  created by `obiuniq`. (default: `merged_sample`)
  {{< /cmd-option >}}

- {{< cmd-option name="map-na-value" param="VALUE" >}}
  String written in matrix cells when a sample has no count for a given sequence.
  (default: `0`)
  {{< /cmd-option >}}

- {{< cmd-option name="allow-empty" >}}
  By default, sequences whose map attribute is absent cause a fatal error. Setting this
  flag prevents the error and includes such sequences in the output, filling all sample
  cells with the `--map-na-value` string.
  {{< /cmd-option >}}

- {{< cmd-option name="auto" >}}
  Inspect the first batch of input sequences and automatically derive the list of
  sequence attributes to include as extra fixed columns. Only has a visible effect in
  `--transpose=false` mode.
  {{< /cmd-option >}}

- {{< cmd-option name="keep" short="k" param="KEY" >}}
  Append the sequence attribute named KEY as an extra fixed column in the output. This
  is equivalent to the dedicated column flags (`--definition`, `--count`, etc.) but for
  arbitrary user-defined attribute names. The flag can be repeated. Only has a visible
  effect in `--transpose=false` mode. This flag does **not** restrict which sample
  columns appear in the matrix.
  {{< /cmd-option >}}

**Output format**

- {{< cmd-option name="transpose" >}}
  Transpose the matrix so that rows correspond to samples and columns to sequences.
  Set `--transpose=false` for the sequence-per-row orientation. In transposed mode,
  all extra attribute columns (`--ids`, `--sequence`, `--quality`, `--count`,
  `--definition`, `--taxon`, `--obipairing`, `--keep`, `--auto`) are silently
  discarded. (default: `true`)
  {{< /cmd-option >}}

- {{< cmd-option name="three-columns" >}}
  Write a long-format (tidy) {{% csv %}} table instead of a wide matrix. Each row
  encodes one (sequence_id, sample, value) triple. Column names are set by
  `--sample-name` and `--value-name`.
  {{< /cmd-option >}}

- {{< cmd-option name="sample-name" param="NAME" >}}
  Name of the column holding sample identifiers in three-column output. (default: `sample`)
  {{< /cmd-option >}}

- {{< cmd-option name="value-name" param="NAME" >}}
  Name of the column holding count values in three-column output. (default: `count`)
  {{< /cmd-option >}}

**Extra annotation columns** *(visible only in `--transpose=false` mode)*

- {{< cmd-option name="ids" short="i" >}}
  Append a column containing the sequence identifier.
  {{< /cmd-option >}}

- {{< cmd-option name="sequence" short="s" >}}
  Append a column containing the nucleotide sequence.
  {{< /cmd-option >}}

- {{< cmd-option name="quality" short="q" >}}
  Append a column named `qualities` containing the Phred quality string.
  {{< /cmd-option >}}

- {{< cmd-option name="definition" short="d" >}}
  Append a column containing the sequence definition (free-text title).
  {{< /cmd-option >}}

- {{< cmd-option name="count" >}}
  Append a column containing the total read count of the sequence across all samples.
  {{< /cmd-option >}}

- {{< cmd-option name="taxon" >}}
  Append a column named `taxon` containing the NCBI taxid of each sequence.
  {{< /cmd-option >}}

- {{< cmd-option name="obipairing" >}}
  Append the eight attributes generated by `obipairing` (`mode`, `seq_a_single`,
  `seq_b_single`, `ali_dir`, `score`, `score_norm`, `seq_ab_match`,
  `pairing_mismatches`). Attributes absent from a sequence are written as `NA`.
  {{< /cmd-option >}}

**CSV input**

- {{< cmd-option name="na-value" param="NAVALUE" >}}
  String used to identify missing values when reading a {{% csv %}} input file.
  (default: `NA`)
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/common >}}

## Examples

```bash
obimatrix --help
```
