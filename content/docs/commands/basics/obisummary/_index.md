---
archetype: "command"
title: "obisummary"
date: 2026-04-07
command: "obisummary"
category: basics
url: "/obitools/obisummary"
weight: 120
---

# `obisummary`: resume main information from a sequence file

## Description

{{< obi obisummary >}} provides a rapid statistical overview of a biological sequence
dataset. Rather than transforming sequences, it reads them and outputs a single
structured record describing global and annotation types. When sample information 
is present, it also outputs per-sample statistics.

The output record is organised into three sections. The **`count`** section reports
the total number of reads (accounting for the `count` attribute of each sequence),
the number of distinct sequence variants, and the cumulative sequence length. The
**`annotations`** section enumerates every annotation key found in the dataset,
classifying each as scalar, map, or vector. The **`samples`** section appears only
when merged-sample data is present and lists per-sample reads, variants, and
singletons.

{{< obi obisummary >}} is typically run after {{< obi obiuniq >}} or {{< obi obiclean >}}
to validate the state of a dataset. The default output format is {{% json %}};
use `--yaml-output` for {{% yaml %}} output.

{{< mermaid class="workflow" >}}
graph TD
  A@{ shape: doc, label: "simple.fasta" }
  C[obisummary]
  D@{ shape: doc, label: "cleaned.json" }
  A --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}

The file [simple.fasta](simple.fasta) contains five {{% fasta %}} sequences with
abundance annotations:

{{< code "simple.fasta" fasta true >}}

Running {{< obi obisummary >}} on this file produces a {{% json %}} record:

```bash
obisummary simple.fasta
```
```
{
  "annotations": {
    "keys": {
      "scalar": {
        "count": 5
      }
    },
    "map_attributes": 0,
    "scalar_attributes": 1,
    "vector_attributes": 0
  },
  "count": {
    "reads": 21,
    "total_length": 100,
    "variants": 5
  }
}
```

The `count.variants` field (5) is the number of distinct sequences; `count.reads`
(21) is the sum of all `count` attributes; `count.total_length` (100) is the total
nucleotide count. The `annotations` section confirms that `count` is the only scalar
annotation present.

To obtain the same information in {{% yaml %}} format, add `--yaml-output`:

```bash
obisummary --yaml-output simple.fasta
```
```
annotations:
    keys:
        scalar:
            count: 5
    map_attributes: 0
    scalar_attributes: 1
    vector_attributes: 0
count:
    reads: 21
    total_length: 100
    variants: 5
```

## Synopsis

```bash
obisummary [--batch-mem <string>] [--batch-size <int>]
           [--batch-size-max <int>] [--csv] [--debug] [--ecopcr] [--embl]
           [--fasta] [--fastq] [--genbank] [--help|-h|-?]
           [--input-OBI-header] [--input-json-header] [--json-output]
           [--map <string>]... [--max-cpu <int>] [--no-order] [--pprof]
           [--pprof-goroutine <int>] [--pprof-mutex <int>] [--silent-warning]
           [--solexa] [--u-to-t] [--version] [--yaml-output] [<args>]
```

## Options

#### {{< obi obisummary >}} specific options

- {{< cmd-option name="json-output" >}}
  Print the result as a {{% json %}} record. This is the default behaviour; this flag
  makes the choice explicit.
  {{< /cmd-option >}}

- {{< cmd-option name="yaml-output" >}}
  Print the result as a {{% yaml %}} record instead of the default {{% json %}} format.
  {{< /cmd-option >}}

- {{< cmd-option name="map" param="string" >}}
  Name of a map attribute to include in the summary detail. This option may be
  repeated to request multiple map attributes.
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/common >}}

## Examples


The file [sequences.fasta](sequences.fasta) contains five {{% fasta %}} sequences,
two of which are singletons (`count` equal to 1). The following pipeline uses
{{< obi obigrep >}} to discard singletons before summarising the remaining reads:

{{< code "sequences.fasta" fasta true >}}

```bash
obigrep -p 'annotations.count > 1' sequences.fasta \
  | obisummary --yaml-output  \
  > out_pipeline.yaml
```

{{< code "out_pipeline.yaml" yaml true >}}

### Aggregate read counts per map attribute with `--map`

The `--map` option names a map attribute and instructs {{< obi obisummary >}} to
accumulate, for each key of that attribute, the total number of reads across all
sequences. The option may be repeated to request several attributes at once.

The file [merged.fasta](merged.fasta) contains four {{% fasta %}} sequences produced
after dereplication. Each carries a `merged_sample` map added by {{< obi obiuniq >}}, 
a `obiclean_weight` map (per-sample read counts as written by {{< obi obiclean >}}) and 
a `marker` map identifying which PCR target was amplified:

{{< code "merged.fasta" fasta true >}}

```bash
obisummary --map obiclean_weight \
           --map marker \
           --yaml-output  \
    merged.fasta > out_map.yaml
```

{{< code "out_map.yaml" yaml true >}}

The new `map_summaries` section provides experiment-wide totals: sample **s1**
contributed 7 reads, **s2** contributed 11; marker **16S** accounts for 13 reads
and **COI** for 5. Note that `samples.sample_stats` is derived automatically from
`obiclean_weight` whenever that attribute is present and gives the same per-sample
read totals together with variant and singleton counts.

### Summarise a real metabarcoding dataset (wolf tutorial)

The file [`wolf.taxo.ann.fasta.gz`](wolf.taxo.ann.fasta.gz) is the final
output of the {{% obitools4 %}} wolf tutorial. It contains 26 sequence variants
produced by the full pipeline — paired-end assembly, demultiplexing, dereplication,
chimera filtering, and taxonomic assignment with `obitag`. Running
{{< obi obisummary >}} on this file gives an immediate overview of the whole
experiment:

```bash
obisummary --yaml-output \
    wolf.taxo.ann.fasta.gz > out_wolf.yaml
```

{{< code "out_wolf.yaml" yaml true >}}

The summary reveals 26 variants representing 31 337 reads spread across 4 samples,
8 scalar attributes (abundance, taxonomy, and `obitag` scores) and 3 map attributes
(`merged_sample`, `obiclean_status`, `obiclean_weight`).

```bash
obisummary --help
```
