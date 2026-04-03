---
archetype: "command"
title: "obidemerge"
date: 2026-04-02
command: "obidemerge"
category: basics
url: "/obitools/obidemerge"
weight: 60
---

# `obidemerge`: split merged sequence records back into individual, sample-annotated copies

## Description

In a typical metabarcoding workflow, {{< obi obiuniq >}} collapses identical sequences into a single representative record. However, to avoid losing critical information, such as sample provenance, carried by individual sequences, the `--merge` or `-m` option can be used to retain the occurrence frequency table in the representative record. For instance, when {{< obi obiuniq >}} is used with the `-m sample` option, the new dereplicated record contains a `merged_sample` attribute that stores the number of times each original sample's sequence was observed. While this compact representation is efficient for clustering and denoising, other downstream analyses require the original per-sample view (i.e., one record per sample and per unique sequence).

 {{< obi obidemerge >}} reverses the merging step. For each input sequence with a `merged_*` statistic attribute, one output sequence is produced for each entry in the statistics map. For example, in the case of demerging the `merged_sample` attribute, each output copy has its `sample` attribute set to the sample name and its `count` attribute set to the recorded abundance. The original statistics attribute (`merged_sample`) is removed from all output sequences. Sequences that carry no statistics for the chosen attribute are passed through unchanged.

The attribute name passed to the `-d` option of `obidemerge` is the **logical** attribute name (e.g., `sample`), not the internal storage name. The tool prepends `merged_` internally when looking up the attribute. Therefore, after running `obiuniq --merge sample`, which stores statistics under `merged_sample`, you must call {{< obi obidemerge >}} with `-d sample`.

{{< mermaid class="workflow" >}}
graph TD
  A@{ shape: doc, label: "unique.fasta" }
  C[obidemerge]
  D@{ shape: doc, label: "per_sample_merged.fasta" }
  A --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}

The following file illustrates a typical input: three sequences carry `merged_sample`
statistics recording how many reads were observed per sample, while one sequence (`seq004`)
has no per-sample breakdown and will be passed through unchanged.

{{< code "unique.fasta" fasta true >}}

Running {{< obi obidemerge >}} with `-d sample` expands each entry of the `merged_sample`
attribute into a separate record, setting `sample` and `count` on each copy:

```bash
obidemerge -d sample unique.fasta > per_sample_merged.fasta
```

{{< code "per_sample_merged.fasta" fasta true >}}

`seq001` yielded three copies (one per sample in `merged_sample`), `seq002` yielded two,
`seq003` yielded one, and `seq004` — which had no `merged_sample` attribute — was passed
through unchanged with its original `count` of 6.

## Synopsis

```bash
obidemerge [--demerge|-d <string>] [--out|-o <FILENAME>]
           [--fasta-output] [--fastq-output] [--json-output]
           [--compress|-Z] [--taxonomy|-t <string>]
           [--fasta] [--fastq] [--csv] [--embl] [--genbank] [--ecopcr]
           [--max-cpu <int>] [--batch-size <int>] [--no-progressbar]
           [<args>]
```

## Options

#### {{< obi obidemerge >}} specific options

- {{< cmd-option name="demerge" short="d" param="attribute" >}}
  Name of the sequence attribute that holds the merged statistics to expand.
  Each key in that statistics map becomes a separate output sequence. The tool looks
  for the attribute named `merged_<attribute>` in the sequence annotations — pass the
  logical name without the `merged_` prefix.
  **Default:** `sample`
  {{< /cmd-option >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

### Display help

```bash
obidemerge --help
```
