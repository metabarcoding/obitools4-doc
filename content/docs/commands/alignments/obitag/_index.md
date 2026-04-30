---
archetype: "command"
title: "obitag"
date: 2026-04-25
command: "obitag"
category: alignments
url: "/obitools/obitag"
weight: 50
---

# `obitag`: realizes taxonomic assignment

## Description

{{< obi obitag >}} assigns a taxonomic annotation to each input sequence by searching a reference database and computing the **Lowest Common Ancestor (LCA)** of the best-matching reference sequences. It is typically run after paired-end merging ({{< obi obipairing >}}), demultiplexing ({{< obi obimultiplex >}}), dereplication ({{< obi obiuniq >}}), and denoising ({{< obi obiclean >}}) steps.

The taxonomic identification is a four steps process. For each query sequence ({{< katex >}}Q{{< /katex >}}), {{< obi obitag >}}:

- pre-screens the reference database using 4-mer contengency table to identify candidate references sequences;
- among the pre-screened sequences, identifies the best hit sequence ({{< katex >}}BH{{< /katex >}}) using **Longest Common Subsequence (LCS)** scoring and records its identity ({{< katex >}}BI{{< /katex >}}) with the query sequence ; 

{{< katex display=true >}}
BI = \text{identity}(Q,BH)
{{< /katex >}}

- identifies in the reference database, the set of sequences {{< katex >}}\mathcal{S}{{< /katex >}} such as

{{< katex display=true >}}
\mathcal{S} = \left\{ S_i \mid \text{identity}(S_i, BH) \geq BI \right\}
{{< /katex >}}

- compute the LCA in the taxonomy, yielding the most precise taxonomic node consistent with all {{< katex >}}\mathcal{S}{{< /katex >}} identified at the previous step.

> [!Note]
> When multiple reference sequences share the same best identity with {{< katex >}}Q{{< /katex >}}, the set of best hits is defined as:
> {{< katex display=true >}}
> \mathcal{BH} = \left\{ BH_j \mid \text{identity}(Q, BH_j) = BI \right\}
> {{< /katex >}}
> and {{< katex >}}\mathcal{S}{{< /katex >}} is then computed as the union over all best hits:
> {{< katex display=true >}}
> \mathcal{S} = \bigcup_{BH_j \,\in\, \mathcal{BH}} \left\{ S_i \mid \text{identity}(S_i, BH_j) \geq BI \right\}
> {{< /katex >}}


{{< mermaid class="workflow" >}}
graph TD
  A@{ shape: doc, label: "wolf_filtered.fasta" }
  C[obitag]
  D@{ shape: doc, label: "wolf_tag.fasta" }
  R@{ shape: doc, label: "db_v05_r117.fasta.gz" }
  T@{ shape: cyl, label: "ncbitaxo.tgz" }
  R --> C
  T --> C
  A --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}

Each output sequence carries the original attributes plus the following {{< obi obitag >}} specific annotations:

| Attribute | Description |
|---|---|
| `taxid` | Assigned taxonomic node, written as `TAXOID:ID [name]@rank` (e.g. for an NCBI taxon :  `taxon:9858 [Capreolus capreolus]@species`). With `--raw-taxid` option set, taxid is written as a plain integer string (e.g. `9858`). |
| `obitag_bestmatch` | Sequence ID of the best-matching reference sequence. |
| `obitag_rank` | Taxonomic rank of the assigned node (e.g., `species`, `genus`, `infraorder`). |
| `obitag_bestid` | Sequence identity (ratio 0–1) of the best-matching reference. |
| `obitag_match_count` | Number of reference sequences used for the LCA computation: {{< katex >}}|\mathcal{S}|{{< /katex >}}. |
| `obitag_similarity_method` | Similarity method used: `"lcs"` for the default alignment-based mode. |

When no confident match is found, the sequence is assigned to the root of the taxonomy (`taxid=1`).

> [!Warning] Quality of the reference database
> Because of the taxonomic inference based on the LCA algorithm, {{< obi obitag >}} is higly sensible to error in the taxonomic reference database. A single wrongly annotated sequence in a clade can in the worst case lead to annotate all the sequences corresponding to this clade as the *root* taxon of the taxonomy.

### Example output

The 8 MOTUs from the wolf diet tutorial, after assignment against the EMBL vertebrate 12S reference database ([db_v05_r117.fasta.gz](db_v05_r117.fasta.gz)) using the ncbi reference taxonomy ([ncbitaxo.tgz](ncbitaxo.tgz)):
 
{{< code "wolf_query.fasta" "text" "download" >}}

```bash
obitag -t ncbitaxo.tgz \
       -R db_v05_r117.fasta.gz \
       wolf_query.fasta \
       > out_ecotag.fasta
```

{{< code "out_ecotag.fasta" "text" "download" >}}

## Synopsis

```
obitag --reference-db|-R <FILENAME> [--batch-mem <string>]
       [--batch-size <int>] [--batch-size-max <int>] [--compress|-Z] [--csv]
       [--debug] [--ecopcr] [--embl] [--fail-on-taxonomy] [--fasta]
       [--fasta-output] [--fastq] [--fastq-output] [--genbank]
       [--geometric|-G] [--help|-h|-?] [--input-OBI-header]
       [--input-json-header] [--json-output] [--max-cpu <int>] [--no-order]
       [--no-progressbar] [--out|-o <FILENAME>] [--output-OBI-header|-O]
       [--output-json-header] [--pprof] [--pprof-goroutine <int>]
       [--pprof-mutex <int>] [--raw-taxid] [--save-db <FILENAME>]
       [--silent-warning] [--skip-empty] [--solexa] [--taxonomy|-t <string>]
       [--u-to-t] [--update-taxid] [--version] [--with-leaves] [<args>]
```

## Options

### {{< obi obitag >}} specific options

- {{< cmd-options/alignments/reference-db >}}
- {{< cmd-options/alignments/save-db >}}
- {{< cmd-options/alignments/geometric >}}
- {{< cmd-option name="with-leaves" >}}
  When the taxonomy is extracted from the reference sequence file itself, add the reference sequences as leaf nodes under their respective taxids in the taxonomy tree. Useful when the reference file is the primary source of taxonomic information (default: false).
  {{< /cmd-option >}}

### Taxonomy options

{{< option-sets/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

### Save and reuse the indexed reference database

Building the internal reference index takes time on large databases. Use `--save-db` option to persist the internal index computed during an annotation run, allowing it to be reused on subsequent runs:

```bash
# First run: assign and save the indexed reference DB
obitag -t ncbitaxo.tgz \
       -R db_v05_r117.fasta.gz \
       --save-db wolf_ref_indexed.fasta \
       wolf_query.fasta \
       > out_basic.fasta

# Subsequent runs: use the pre-built index (significantly faster)
obitag -t ncbitaxo.tgz \
       -R wolf_ref_indexed.fasta \
       wolf_query.fasta \
       > out_basic.fasta
```

### Integrate taxonomy to the reference database

The reference database can be modified to integrate its own taxonomy. This is acheived using the {{< obi obiannotate >}} command.

```bash
obiannotate -t ncbitaxo.tgz \
            -Z \
            --taxonomic-path \
            --update-taxid \
            db_v05_r117.fasta.gz \
            > db_v05_r117_taxo.fasta.gz
```

The modified reference database includes for each reference sequence a new annotation `taxonomic_path` describing the full taxonomic path extracted from the ncbi taxonomy database.

```bash
gzcat db_v05_r117_taxo.fasta.gz | head -2
```
```
>AY189646 {"count":1,"definition":"Homo sapiens clone arCan119 12S ribosomal RNA gene, partial sequence; mitochondrial gene for mitochondrial product.","species_name":"Homo sapiens","taxid":"taxon:9606 [Homo sapiens]@species","taxonomic_path":["taxon:1 [root]@no rank","taxon:131567 [cellular organisms]@cellular root","taxon:2759 [Eukaryota]@domain","taxon:33154 [Opisthokonta]@clade","taxon:33208 [Metazoa]@kingdom","taxon:6072 [Eumetazoa]@clade","taxon:33213 [Bilateria]@clade","taxon:33511 [Deuterostomia]@clade","taxon:7711 [Chordata]@phylum","taxon:89593 [Craniata]@subphylum","taxon:7742 [Vertebrata]@clade","taxon:7776 [Gnathostomata]@clade","taxon:117570 [Teleostomi]@clade","taxon:117571 [Euteleostomi]@clade","taxon:8287 [Sarcopterygii]@superclass","taxon:1338369 [Dipnotetrapodomorpha]@clade","taxon:32523 [Tetrapoda]@clade","taxon:32524 [Amniota]@clade","taxon:40674 [Mammalia]@class","taxon:32525 [Theria]@clade","taxon:9347 [Eutheria]@clade","taxon:1437010 [Boreoeutheria]@clade","taxon:314146 [Euarchontoglires]@superorder","taxon:9443 [Primates]@order","taxon:376913 [Haplorrhini]@suborder","taxon:314293 [Simiiformes]@infraorder","taxon:9526 [Catarrhini]@parvorder","taxon:314295 [Hominoidea]@superfamily","taxon:9604 [Hominidae]@family","taxon:207598 [Homininae]@subfamily","taxon:9605 [Homo]@genus","taxon:9606 [Homo sapiens]@species"]}
ttagccctaaacctcaacagttaaatcaacaaaactgctcgccagaacactacgrgccac
```

The new [db_v05_r117_taxo.fasta.gz](db_v05_r117_taxo.fasta.gz) file can now be used as as taxonomy self contained reference database by {{< obi obitag >}}, without requiring any reference to an external taxonomy file.

```bash
obitag -R db_v05_r117_taxo.fasta.gz \
       wolf_query.fasta \
       > out_basic.fasta
```

### Write plain taxids with automatic deprecated-taxid correction

Use `--raw-taxid` to write compact integer taxids, and `--update-taxid` to silently replace any deprecated taxids found in the reference database:

```bash
obitag -t ncbitaxo.tgz \
       -R db_v05_r117.fasta.gz \
       --update-taxid \
       --raw-taxid \
       wolf_query.fasta \
       > out_raw_taxid.fasta
```

{{< code "out_raw_taxid.fasta" "text" "download" >}}

### Strict taxonomy enforcement

Combine `--update-taxid` and `--fail-on-taxonomy` to first update deprecated taxids, then terminate immediately on any taxid that remains invalid after the update:

```bash
obitag -t ncbitaxo.tgz \
       -R db_v05_r117.fasta.gz \
       --update-taxid \
       --fail-on-taxonomy \
       wolf_query.fasta \
       > out_strict_update.fasta
```

{{< code "out_strict_update.fasta" "text" "download" >}}

> **Note:** Using `--fail-on-taxonomy` alone (without `--update-taxid`) will cause {{< obi obitag >}} to exit with a fatal error when it encounters the deprecated taxids that are common in reference databases built from older taxonomy snapshots.

### Display help

```bash
obitag --help
```
