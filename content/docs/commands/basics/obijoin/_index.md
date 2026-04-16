---
archetype: "command"
title: "obijoin"
date: 2026-04-07
command: "obijoin"
category: basics
url: "/obitools/obijoin"
weight: 90
---

# `obijoin`: merge annotations contained in a file to another file

## Description

{{< obi obijoin >}} enriches a primary sequence dataset with annotations from a secondary
file by matching records on shared attribute values. For each sequence in the primary
input, it finds all records in the secondary file that share the same value for one or
more specified keys, then copies their annotation attributes onto the primary sequence.
The operation is a **left outer join**: every primary sequence is preserved in the output;
those without a matching partner keep their original annotations unchanged.

A common use case is adding sample metadata — collection site, experimental condition,
or sequencing run — to a set of amplicon reads. The secondary file can be in any format
that {{% obitools4 %}} accepts, including {{% fasta %}}, {{% fastq %}}, or {{% csv %}}
(including plain CSV spreadsheets); the format is auto-detected automatically.

The workflow for the basic case — matching on a `sample` attribute — looks like this:

{{< mermaid class="workflow" >}}
graph TD
  A@{ shape: doc, label: "input.fasta" }
  B@{ shape: doc, label: "metadata.csv" }
  C[obijoin]
  D@{ shape: doc, label: "out_basic.fasta" }
  A --> C
  B --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}

The file [input.fasta](input.fasta) contains six sequences, each annotated with a `sample`
identifier (S1–S4) and a `barcode`:

{{< code "input.fasta" fasta true >}}

The file [metadata.csv](metadata.csv) is a plain CSV spreadsheet mapping each sample
identifier to a geographic location and an experiment name:

{{< code "metadata.csv" csv true >}}

To merge the CSV metadata into the sequence dataset, matching records where the primary's
`sample` attribute equals the secondary's `sample` column, run:

```bash
obijoin --join-with metadata.csv --by sample input.fasta > out_basic.fasta
```

{{< code "out_basic.fasta" fasta true >}}

Sequences `seq001`, `seq002`, `seq004`, and `seq005` (belonging to samples S1 or S2)
received the `location` and `experiment` attributes from the CSV. Sequences `seq003` and
`seq006` (samples S3 and S4, absent from the CSV) were emitted unchanged with no extra
annotations added.

## Synopsis

```bash
obijoin --join-with|-j <string> [--batch-mem <string>] [--batch-size <int>]
        [--batch-size-max <int>] [--by|-b <string>]... [--compress|-Z]
        [--csv] [--debug] [--ecopcr] [--embl] [--fail-on-taxonomy] [--fasta]
        [--fasta-output] [--fastq] [--fastq-output] [--genbank]
        [--help|-h|-?] [--input-OBI-header] [--input-json-header]
        [--json-output] [--max-cpu <int>] [--no-order] [--no-progressbar]
        [--out|-o <FILENAME>] [--output-OBI-header|-O] [--output-json-header]
        [--pprof] [--pprof-goroutine <int>] [--pprof-mutex <int>]
        [--raw-taxid] [--silent-warning] [--skip-empty] [--solexa]
        [--taxonomy|-t <string>] [--u-to-t] [--update-id|-i]
        [--update-quality|-q] [--update-sequence|-s] [--update-taxid]
        [--version] [--with-leaves] [<args>]
```

## Options

#### {{< obi obijoin >}} specific options

- {{< cmd-option name="join-with" short="j" param="FILENAME" >}}
  Path to the secondary file whose records are joined onto the primary sequences.
  **Required.** The file can be in any format accepted by {{% obitools4 %}} (including
  {{% fasta %}}, {{% fastq %}}, {{% csv %}}, EMBL, GenBank, ecoPCR); the format is
  auto-detected.
  {{< /cmd-option >}}

- {{< cmd-option name="by" short="b" param="string" >}}
  Declares a join key as an attribute name or a `primary_attr=secondary_attr` mapping (see the first example below).
  Repeat the flag to require multiple keys to match simultaneously (all must match for a
  pair to be considered a hit). When the '--by' option is omitted, the matching will be made by default with the sequence identifier (`id`).
  {{< /cmd-option >}}

- {{< cmd-option name="update-id" short="i" >}}
  Replace the identifier of each primary sequence with the identifier from its matched
  partner record. Default: `false`.
  {{< /cmd-option >}}

- {{< cmd-option name="update-sequence" short="s" >}}
  Replace the nucleotide of each primary sequence with the
  sequence from its matched partner. Default: `false`.
  {{< /cmd-option >}}

- {{< cmd-option name="update-quality" short="q" >}}
  Replace the per-base quality scores of each primary sequence with the quality scores
  from its matched partner. Relevant only when both datasets carry quality information
  ({{% fastq %}}). Default: `false`.
  {{< /cmd-option >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

- {{< cmd-option name="fail-on-taxonomy" >}}
  Cause [obijoin](../obijoin) to fail with an error if a taxid encountered during
  processing is not currently valid in the taxonomy database. Default: `false`.
  {{< /cmd-option >}}

- {{< cmd-option name="raw-taxid" >}}
  Print taxids in output files without supplementary information (taxon name and rank).
  Default: `false`.
  {{< /cmd-option >}}

- {{< cmd-option name="update-taxid" >}}
  Automatically update taxids that are declared as merged to a newer one in the taxonomy
  database. Default: `false`.
  {{< /cmd-option >}}

- {{< cmd-option name="with-leaves" >}}
  When taxonomy is extracted from a sequence file, add sequences as leaves of their
  taxid annotation in the taxonomy tree. Default: `false`.
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

**Join on a cross-attribute key:**

Sometimes the primary dataset and the secondary annotation file use different column
names for the same identifier. The `primary_attr=secondary_attr` syntax of `--by` maps
the primary attribute to the secondary one. Here the primary sequences have a `sample`
attribute while the annotation CSV uses `well`:

{{< code "input.fasta" fasta true >}}
{{< code "well_metadata.csv" csv true >}}

```bash
obijoin --join-with well_metadata.csv \
        --by sample=well \
        input.fasta > out_crosskey.fasta
```

{{< code "out_crosskey.fasta" fasta true >}}

The `well` column value from the CSV is copied onto each matched sequence together with
`location` and `experiment`. Sequences with no match (S3, S4) are emitted unchanged.

---

**Join on two keys simultaneously, then update sequence identifiers:**

The file [references.fasta](references.fasta) contains two reference sequences each
annotated with both `sample` and `barcode`. Using `--by sample --by barcode` requires
**both** attributes to match before a join is made. Adding `--update-id` replaces the
primary sequence's identifier with the reference identifier, which is useful when
sequence IDs need to track which reference was matched.

{{< code "input.fasta" fasta true >}}
{{< code "references.fasta" fasta true >}}

```bash
obijoin --join-with references.fasta \
        --by sample --by barcode \
        --update-id \
        input.fasta > out_multikey.fasta
```

{{< code "out_multikey.fasta" fasta true >}}

Sequences `seq001` and `seq004` now carry the identifier `ref001`; `seq002` and `seq005`
carry `ref002`. The two unmatched sequences (`seq003`, `seq006`) keep their original IDs.

---

**Replace sequences and quality scores with corrected values from a FASTQ file:**

After error-correction or quality trimming, the corrected reads may be stored in a
separate file. {{< obi obijoin >}} can re-annotate the original reads with the corrected
sequence and quality data using `--update-sequence` and `--update-quality`. Sequences
absent from the corrected file (here `seq003`) are kept unchanged.

The file [input.fastq](input.fastq) is the original dataset:

{{< code "input.fastq" fastq true >}}

The file [corrected.fastq](corrected.fastq) provides updated sequences and qualities for
`seq001` and `seq002`:

{{< code "corrected.fastq" fastq true >}}

```bash
obijoin --join-with corrected.fastq \
        --update-sequence --update-quality \
        input.fastq > out_updated.fastq
```

{{< code "out_updated.fastq" fastq true >}}

---

**Use an OBITools CSV file as primary input and write compressed output:**

When the primary sequences are stored in OBITools {{% csv %}} format (e.g., from a
previous `obicsv` export), use `--csv` to force CSV reading. The secondary annotation
file is always auto-detected. Here [primary.csv](primary.csv) is the primary input:

{{< code "primary.csv" csv true >}}
{{< code "metadata.csv" csv true >}}

```bash
obijoin --join-with metadata.csv --by sample \
        --csv --fasta-output --compress \
        --no-progressbar \
        primary.csv > out_compressed.fasta.gz
```

produced a gziped fasta file : [`out_compressed.fasta.gz`](out_compressed.fasta.gz)
that can be decompressed to produce the following fasta

```bash
gunzip out_compressed.fasta.gz
```
{{< code "out_compressed.fasta" csv true >}}

---

```bash
obijoin --help
```
