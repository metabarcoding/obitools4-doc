---
archetype: "command"
title: "obicsv"
date: 2026-04-13
command: "obicsv"
category: basics
url: "/obitools/obicsv"
weight: 50
---

# `obicsv`: converts sequence files to CSV format

## Description

{{< obi obicsv >}} converts biological sequence datasets into {{% csv %}} (comma-separated values) format. Each row in the output represents one sequence, and the columns are chosen explicitly by the user: the sequence identifier, the nucleotide sequence itself, per-base quality scores, taxonomic annotation, abundance count, sequence definition, and any annotation attributes stored in the sequence headers. This makes {{< obi obicsv >}} particularly useful when a biologist wants to analyse sequence metadata in a spreadsheet application, load annotations into R or Python, or export data for database ingestion. Rather than parsing OBITools JSON-annotated {{% fasta %}} or {{% fastq %}} headers manually, {{< obi obicsv >}} extracts the desired fields into a clean tabular format.

No column is included unless the corresponding flag is given. Flags such as `--ids`, `--sequence`, `--quality`, `--count`, `--taxon`, and `--keep` select individual columns; the `--auto` flag inspects the first batch of sequences and automatically selects all annotation attributes found there, saving the effort of enumerating column names manually. Values absent from a given sequence are represented by `NA` in the output.

{{< mermaid class="workflow" >}}
graph TD
  A@{ shape: doc, label: "sequences.fasta" }
  C[obicsv]
  D@{ shape: doc, label: "out_ids_sample.csv" }
  A --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}

Consider the annotated {{% fasta %}} file [sequences.fasta](sequences.fasta), in which each record carries attributes such as `sample`, `location`, `experiment`, `count`, and optionally `taxid`:

{{< code "sequences.fasta" fasta true >}}

The simplest use of {{< obi obicsv >}} is to extract the sequence identifier alongside a single annotation attribute. Here `--ids` adds the identifier column and `--keep sample` adds the `sample` attribute:

```bash
obicsv --ids --keep sample sequences.fasta > out_ids_sample.csv
```

{{< code "out_ids_sample.csv" csv true >}}

When the list of annotation attributes is not known in advance, `--auto` inspects the first batch of sequences and includes every attribute it finds. Attributes absent from a given sequence receive `NA`:

```bash
obicsv --auto sequences.fasta > out_auto.csv
```

{{< code "out_auto.csv" csv true >}}


Note that `seq004`, `seq005`, and `seq006` lack a `taxid` annotation; their value in the `taxid` column is `NA`. This is expected whenever annotation is incomplete — {{< obi obicsv >}} never omits rows for missing attributes.

## Synopsis

```bash
obicsv [--auto] [--batch-mem <string>] [--batch-size <int>]
       [--batch-size-max <int>] [--compress|-Z] [--count] [--csv] [--debug]
       [--definition|-d] [--ecopcr] [--embl] [--fail-on-taxonomy] [--fasta]
       [--fastq] [--genbank] [--help|-h|-?] [--ids|-i] [--input-OBI-header]
       [--input-json-header] [--keep|-k <KEY>]... [--max-cpu <int>]
       [--na-value <NAVALUE>] [--no-order] [--no-progressbar] [--obipairing]
       [--out|-o <FILENAME>] [--pprof] [--pprof-goroutine <int>]
       [--pprof-mutex <int>] [--quality|-q] [--raw-taxid] [--sequence|-s]
       [--silent-warning] [--solexa] [--taxon] [--taxonomy|-t <string>]
       [--u-to-t] [--update-taxid] [--version] [--with-leaves] [<args>]
```

## Options

#### {{< obi obicsv >}} specific options

- {{< cmd-option name="ids" short="i" >}}
  Print the sequence identifier as the first column of the output.
  {{< /cmd-option >}}

- {{< cmd-option name="sequence" short="s" >}}
  Print the nucleotide (or amino acid) sequence in the output.
  {{< /cmd-option >}}

- {{< cmd-option name="quality" short="q" >}}
  Print the per-base quality scores in the output.
  {{< /cmd-option >}}

- {{< cmd-option name="definition" short="d" >}}
  Print the sequence definition (title line text after the identifier) in the output.
  {{< /cmd-option >}}

- {{< cmd-option name="count" >}}
  Print the `count` annotation attribute in the output.
  {{< /cmd-option >}}

- {{< cmd-option name="taxon" >}}
  Print the `taxid` attribute as a dedicated column in the output. Note: only the numeric taxid is output — no scientific name column is produced. Sequences without a `taxid` annotation show `NA`. 
  {{< /cmd-option >}}

- {{< cmd-option name="obipairing" >}}
  Print the eight attributes added by the [`obipairing`](../obipairing) command: `mode`, `seq_a_single`, `seq_b_single`, `ali_dir`, `score`, `score_norm`, `seq_ab_match`, `pairing_mismatches`. This is only meaningful for sequences that have been processed by [`obipairing`](../obipairing). All other values are `NA`.
  {{< /cmd-option >}}

- {{< cmd-option name="keep" short="k" param="KEY" >}}
  Include the annotation attribute named `KEY` as an output column. Repeat the flag to include multiple attributes. If an attribute is absent from a sequence, its value appears as `NA`.
  {{< /cmd-option >}}

- {{< cmd-option name="auto" >}}
  Inspect the first batch of sequences and automatically select all annotation attributes found there as output columns. Attributes that appear only in later batches will not be included in the header and their values will be treated as missing. 
  {{< /cmd-option >}}

- {{< cmd-option name="na-value" param="NAVALUE" >}}
  Intended to customise the placeholder string for missing values in the output. Default: `NA`.
  {{< /cmd-option >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

- {{< cmd-option name="fail-on-taxonomy" >}}
  Cause [`obicsv`](../obicsv) to fail with an error if a `taxid` encountered is not currently valid in the taxonomy database. 
  {{< /cmd-option >}}

- {{< cmd-option name="raw-taxid" >}}
  Print taxids in the output without supplementary information (taxon name and rank).
  {{< /cmd-option >}}

- {{< cmd-option name="update-taxid" >}}
  Automatically update taxids declared as merged to a newer one.
  {{< /cmd-option >}}

- {{< cmd-option name="with-leaves" >}}
  When taxonomy is extracted from a sequence file, add sequences as leaves of their taxid annotation.
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

**Export sequence content and quality from a {{% fastq %}} file:**

The file [reads.fastq](reads.fastq) contains four {{% fastq %}} records with free-text definitions and per-base quality scores. Exporting identifiers, definitions, sequences, and quality strings together gives a complete per-read table, useful for quality control or inspection in a spreadsheet:

{{< code "reads.fastq" fastq true >}}

```bash
obicsv --ids --sequence --quality --definition reads.fastq | csvlook
```

```
| id     | definition              | sequence             | qualities            |
| ------ | ----------------------- | -------------------- | -------------------- |
| seq001 | Bacteria amplicon read  | atgcatgcatgcatgcatgc | IIIIIIIIIIIIIIIIIIII |
| seq002 | Archaea amplicon read   | gctagctagctagctagcta | IIIIIIIIIIIIIIIIIIII |
| seq003 | Eukaryota amplicon read | tttttttttttttttttttt | IIIIIIIIIIIIIIIIIIII |
| seq004 | unknown origin read     | aaaaatttttcccccggggg | IIIIIIIIIIIIIIIIIIII |
```

**Export abundance counts and taxonomic annotations alongside selected attributes:**

After taxonomic assignment, sequences carry a `taxid` annotation and may carry `count` values from clustering or demultiplexing. The `--count` flag exports the abundance count, `--taxon` exports the numeric taxid, and `--keep` adds further annotation attributes. Sequences lacking a `taxid` produce `NA` in that column:

```bash
obicsv --count --taxon --keep location --keep experiment sequences.fasta | csvlook
```

```
| count | taxid | location  | experiment |
| ----- | ----- | --------- | ---------- |
|    42 |     2 | Paris     | run1       |
|    15 |  2157 | Lyon      | run1       |
|     7 |  2759 | Paris     | run2       |
|     3 |    NA | Grenoble  | run2       |
|    20 |    NA | Lyon      | run3       |
|     1 |    NA | Bordeaux  | run3       |
```

**Export identifiers and taxid, illustrating missing-value handling:**

When only some sequences carry a `taxid` annotation, the remaining rows show `NA`. The `--na-value` flag is intended to customise this placeholder:

```bash
obicsv --ids --keep taxid --na-value MISSING sequences.fasta | csvlook
```

```
| id     | taxid   |
| ------ | ------- |
| seq001 | 2       |
| seq002 | 2157    |
| seq003 | 2759    |
| seq004 | MISSING |
| seq005 | MISSING |
| seq006 | MISSING |
```

```bash
obicsv --help
```
