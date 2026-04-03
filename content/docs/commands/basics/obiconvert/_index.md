---
archetype: "command"
title: "obiconvert"
date: 2026-04-02
command: "obiconvert"
category: basics
url: "/obitools/obiconvert"
weight: 30
---

# `obiconvert`: convert sequence files between formats


## Description

{{< obi obiconvert >}} is a versatile tool for converting biological sequence data
between multiple standard bioinformatics formats. It enables biologists to process
large datasets by reading from one format and writing to another. The tool
automatically detects input formats and selects output formats based on
data presence — {{% fastq %}} when quality scores exist, {{% fasta %}} otherwise. To
force a specific output format regardless of input content, use the explicit output
flags `--fasta-output`, `--fastq-output`, or `--json-output`.

{{< mermaid class="workflow" >}}
graph TD
  A@{ shape: doc, label: "input.fastq" }
  C[obiconvert]
  D@{ shape: doc, label: "output.fasta" }
  A --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}

Consider the following {{% fastq %}} input file:

{{< code "input.fastq" fastq true >}}

Running {{< obi obiconvert >}} with `--fasta-output` converts the {{% fastq %}} file
to {{% fasta %}} format, discarding the quality scores:

```bash
obiconvert --fastq --fasta-output input.fastq -o output.fasta
```

{{< code "output.fasta" fasta true >}}

{{< obi obiconvert >}} can also convert sequences to [JSON](https://en.wikipedia.org/wiki/JSON) format, which preserves all annotations in a structured, machine-readable form. Consider the following {{% fasta %}}
input:

{{< code "input.fasta" fasta true >}}

```bash
obiconvert --fasta --json-output input.fasta -o output.json
```

{{< code "output.json" txt true >}}

When working with paired-end sequencing data, the `--paired-with` option links two
files so that read pairing is preserved across the conversion. The output is
automatically split into two files suffixed `_R1` and `_R2`:

{{< code "forward.fastq" fastq true >}}

{{< code "reverse.fastq" fastq true >}}

```bash
obiconvert --fastq --fasta-output forward.fastq \
           --paired-with reverse.fastq \
           -o sequences.fasta
```

{{< code "sequences_R1.fasta" fasta true >}}

{{< code "sequences_R2.fasta" fasta true >}}

## Synopsis

```bash
obiconvert [--batch-mem <string>] [--batch-size <int>]
           [--batch-size-max <int>] [--compress|-Z] [--csv] [--debug] [--ecopcr]
           [--embl] [--fail-on-taxonomy] [--fasta] [--fasta-output] [--fastq]
           [--fastq-output] [--genbank] [--help|-h|-?]
           [--input-OBI-header] [--input-json-header] [--json-output]
           [--max-cpu <int>] [--no-order] [--no-progressbar]
           [--out|-o <FILENAME>] [--output-OBI-header|-O]
           [--output-json-header] [--paired-with <FILENAME>] [--pprof]
           [--pprof-goroutine <int>] [--pprof-mutex <int>] [--raw-taxid]
           [--silent-warning] [--skip-empty] [--solexa]
           [--taxonomy|-t <string>] [--u-to-t] [--update-taxid] [--version]
           [--with-leaves] [<args>]
```

## Options

#### {{< obi obiconvert >}} specific options

- {{< cmd-options/paired-with >}}

{{< option-sets/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

When working with rRNA metabarcoding data, sequences are often stored with uracil (U)
instead of thymine (T). The file [input_rna.fasta](input_rna.fasta) contains three such
{{% fasta %}} sequences. The `--u-to-t` flag converts them to standard DNA for alignment
tools that do not accept RNA notation.

{{< code "input_rna.fasta" fasta true >}}

```bash
obiconvert --fasta --fasta-output --u-to-t input_rna.fasta -o output_dna.fasta
```

{{< code "output_dna.fasta" fasta true >}}

OBITools stores sequence annotations as [JSON](https://en.wikipedia.org/wiki/JSON) objects in the sequence header. Some downstream tools expect headers formatted according to the [JSON](https://en.wikipedia.org/wiki/JSON) standard. The file [input.fastq](input.fastq) illustrates a typical {{% fastq %}} file with annotation fields. Using `--output-json-header` ensures the headers are written in strict [JSON](https://en.wikipedia.org/wiki/JSON)
format, regardless of the original header style.

{{< code "input.fastq" fastq true >}}

```bash
obiconvert --fastq --output-json-header input.fastq -o output_jsonheader.fastq
```

{{< code "output_jsonheader.fastq" fastq true >}}

The OBITools native header format encodes annotations as key=value pairs rather than
[JSON](https://en.wikipedia.org/wiki/JSON). The file [input.fasta](input.fasta) uses [JSON](https://en.wikipedia.org/wiki/JSON) annotations. Converting with
`--output-OBI-header` produces a {{% fasta %}} file whose headers follow the OBI
format, which is required by some older OBITools-based pipelines.

{{< code "input.fasta" fasta true >}}

```bash
obiconvert --fasta --output-OBI-header input.fasta -o output_obi.fasta
```

{{< code "output_obi.fasta" fasta true >}}

```bash
obiconvert --help
```
