---
archetype: "command"
title: "obicomplement"
date: 2026-04-16
command: "obicomplement"
category: basics
url: "/obitools/obicomplement"
weight: 20
---

# `obicomplement`: reverse complement of sequences

## Description

{{< obi obicomplement >}} computes the reverse complement of every sequence in
its input. For each sequence, the nucleotides are reversed and each base is
replaced by its Watson–Crick complement (A↔T, C↔G), yielding the strand that
would pair with the original sequence read in the opposite direction. Ambiguous
IUPAC characters are handled correctly and preserved in the output.

When quality scores are present ({{% fastq %}} input), they are reversed in
lock-step with the sequence so that each quality value remains associated with
its corresponding base after transformation. This makes {{< obi obicomplement >}}
safe to use in any pipeline that carries per-base quality information.

This operation is commonly needed when sequences were read on the wrong strand,
when a primer is designed on the reverse strand, or when preparing data for
strand-aware downstream tools such as {{< obi obipairing >}} or {{< obi obigrep >}}.

{{< mermaid class="workflow" >}}
graph TD
  A@{ shape: doc, label: "sequences.fasta" }
  C[obicomplement]
  D@{ shape: doc, label: "out_default.fasta" }
  A --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}

The file [sequences.fasta](sequences.fasta) contains five sample {{% fasta %}}
sequences:

{{< code "sequences.fasta" fasta true >}}

To compute the reverse complement of all five sequences:

```bash
obicomplement sequences.fasta > out_default.fasta
```

{{< code "out_default.fasta" fasta true >}}

Each sequence header description is wrapped in a JSON annotation block, and the
sequence itself is written in lowercase with all bases reverse-complemented.

## Synopsis

```bash
obicomplement [--batch-mem <string>] [--batch-size <int>]
              [--batch-size-max <int>] [--compress|-Z] [--csv] [--debug]
              [--ecopcr] [--embl] [--fail-on-taxonomy] [--fasta]
              [--fasta-output] [--fastq] [--fastq-output] [--genbank]
              [--help|-h|-?] [--input-OBI-header] [--input-json-header]
              [--json-output] [--max-cpu <int>] [--no-order]
              [--no-progressbar] [--out|-o <FILENAME>]
              [--output-OBI-header|-O] [--output-json-header]
              [--paired-with <FILENAME>] [--pprof] [--pprof-goroutine <int>]
              [--pprof-mutex <int>] [--raw-taxid] [--silent-warning]
              [--skip-empty] [--solexa] [--taxonomy|-t <string>] [--u-to-t]
              [--update-taxid] [--version] [--with-leaves] [<args>]
```

## Options

#### {{< obi obicomplement >}} specific options

- {{< cmd-options/paired-with >}}

- {{< cmd-option name="skip-empty" >}}
  Sequences of length zero are removed from the output. Useful as a safety
  guard after upstream processing steps that may produce empty sequences.
  {{< /cmd-option >}}

- {{< cmd-option name="u-to-t" >}}
  Convert Uracil (U) to Thymine (T) before computing the reverse complement.
  Ensures that RNA sequences are explicitly treated as DNA throughout the
  pipeline.
  {{< /cmd-option >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

- {{< cmd-option name="fail-on-taxonomy" >}}
  Exit with an error if a taxid found in the data is not a currently valid
  node in the loaded taxonomy.
  {{< /cmd-option >}}

- {{< cmd-option name="update-taxid" >}}
  Automatically replace taxids that have been declared merged into a newer
  node by the taxonomy database.
  {{< /cmd-option >}}

- {{< cmd-option name="raw-taxid" >}}
  Print taxids in output files without appending the taxon name and rank.
  {{< /cmd-option >}}

- {{< cmd-option name="with-leaves" >}}
  When the taxonomy is extracted from a sequence file, attach sequences as
  leaves of their taxid node.
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

### Reverse complement paired-end reads

For paired-end data, [R1.fastq](R1.fastq) and [R2.fastq](R2.fastq) contain the
forward and reverse reads, respectively. {{< obi obicomplement >}} processes both
files simultaneously and writes the reverse-complemented results to separate
`_R1` and `_R2` output files:

{{< code "R1.fastq" fastq true >}}

{{< code "R2.fastq" fastq true >}}

```bash
obicomplement --paired-with R2.fastq \
    --out out_paired.fastq \
    R1.fastq
```

{{< code "out_paired_R1.fastq" fastq true >}}
{{< code "out_paired_R2.fastq" fastq true >}}

### Reverse complement RNA sequences

{{< obi obicomplement >}} handles Uracil (U) natively: each U is complemented
to Adenine (A) just like Thymine would be, so {{% fasta %}} files containing
RNA sequences can be processed directly without any extra flag. The output is a standard DNA file. The file
[rna_sequences.fasta](rna_sequences.fasta) contains three RNA sequences with U
bases:

{{< code "rna_sequences.fasta" fasta true >}}

```bash
obicomplement rna_sequences.fasta > out_rna_rc.fasta
```

{{< code "out_rna_rc.fasta" fasta true >}}

```bash
obicomplement --help
```
