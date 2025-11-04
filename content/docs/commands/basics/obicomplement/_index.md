---
archetype: "command"
title: "obicomplement"
date: 2025-02-10
command: "obicomplement"
category: basics
url: "/obitools/obicomplement"
weight: 20
---

# `obicomplement`: get sequences reverse complement

## Description

`obicomplement` computes the reverse complement of DNA sequences. This command is essential in many bioinformatics workflows, particularly when working with paired-end sequencing data or when you need to align sequences to the opposite strand.

The reverse complement operation consists of two steps:
1. **Reverse**: the sequence is read from the 3' end to the 5' end
2. **Complement**: each nucleotide is replaced by its complementary base (A↔T, C↔G)

For example, the sequence `ATCG` becomes `CGAT` (reverse: `GCTA`, then complement: `CGAT`).

The output is written by default in {{% fasta %}} format if the input sequence file does not include quality scores, otherwise it is written in {{% fastq %}} format. When processing {{% fastq %}} files, the quality scores are also reversed to match the reversed sequence.

{{< mermaid class="workflow" >}}
graph TD
  A@{ shape: doc, label: "sequences.fasta" }
  C[obicomplement]
  D@{ shape: doc, label: "reverse_complement.fasta" }
  A --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}

## Synopsis

```bash
obicomplement [--batch-size <int>] [--compress|-Z] [--csv] [--debug]
              [--ecopcr] [--embl] [--fail-on-taxonomy] [--fasta]
              [--fasta-output] [--fastq] [--fastq-output] [--force-one-cpu]
              [--genbank] [--help|-h|-?] [--input-OBI-header]
              [--input-json-header] [--json-output] [--max-cpu <int>]
              [--no-order] [--no-progressbar] [--out|-o <FILENAME>]
              [--output-OBI-header|-O] [--output-json-header]
              [--paired-with <FILENAME>] [--pprof] [--pprof-goroutine <int>]
              [--pprof-mutex <int>] [--raw-taxid] [--silent-warning]
              [--skip-empty] [--solexa] [--taxonomy|-t <string>] [--u-to-t]
              [--update-taxid] [--version] [--with-leaves] [<args>]
```

## Options

#### {{< obi obicomplement >}} specific options

- {{< cmd-options/paired-with >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

### Basic usage

Consider the following FASTA file:

{{< code "sequences.fasta" fasta true >}}

To compute the reverse complement of all sequences:

```bash
obicomplement sequences.fasta
```

```
>seq1
atcgatcgagctagctacgatcg
>seq2
cgtagctagcgatgcatgcatgc
>seq3
tagctagctagctagctagctagc
```

Each sequence has been reversed and complemented. For instance:
- Original `seq1`: `cgatcgatcgatcgtagctagct`
- Reverse complement: `atcgatcgagctagctacgatcg`

### Working with FASTQ files

When processing {{% fastq %}} files, {{< obi obicomplement >}} automatically reverses the quality scores to match the reversed sequence:

```bash
obicomplement reads.fastq > reads_rc.fastq
```

The output will be in {{% fastq %}} format with quality scores in the correct order.

### Writing output to a file

You can redirect the output to a file using the `-o` option:

```bash
obicomplement sequences.fasta -o reverse_complement.fasta
```

### Compressed output

To generate a compressed output file:

```bash
obicomplement sequences.fasta -o reverse_complement.fasta.gz -Z
```

### Processing paired-end sequencing data

When working with paired-end data, you might need to reverse complement the reverse reads to align them in the same orientation as the forward reads. The `--paired-with` option allows you to process paired files simultaneously:

```bash
obicomplement reverse_reads.fastq --paired-with forward_reads.fastq
```

### Use case: preparing sequences for alignment

A common use case is when you have sequences that need to be aligned to a reference database, but some sequences are in the opposite orientation:

```bash
# Get reverse complement of sequences
obicomplement my_sequences.fasta > my_sequences_rc.fasta

# Concatenate both orientations for comprehensive alignment
cat my_sequences.fasta my_sequences_rc.fasta > my_sequences_both_strands.fasta
```

### Pipeline integration

{{< obi obicomplement >}} is often used in combination with other {{< obitools >}} commands:

```bash
# Extract sequences, compute reverse complement, and filter by length
obigrep -p 'annotations.strand == "minus"' sequences.fasta \
  | obicomplement \
  | obigrep -l 100 > filtered_rc.fasta
```
