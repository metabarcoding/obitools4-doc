---
archetype: "command"
title: "obitaxonomy"
date: 2026-04-25
command: "obitaxonomy"
category: taxonomy
url: "/obitools/obitaxonomy"
weight: 50
---

# `obitaxonomy`: manage and query a taxonomy database

## Description

{{< obi obitaxonomy >}} is the OBITools4 utility for loading, inspecting, and querying a
taxonomy database. It covers every aspect of taxonomy management needed in a metabarcoding
pipeline: downloading a fresh copy of the NCBI taxonomy, exploring the hierarchy, filtering to
a clade of interest, looking up taxon names, and exporting subtrees in CSV or Newick format.

{{< mermaid class="workflow" >}}
graph LR
  T@{ shape: cyl, label: "ncbitaxo.tgz" }
  S@{ shape: doc, label: "sequences.fasta" }
  C[obitaxonomy]
  D@{ shape: doc, label: "taxonomy.csv" }
  T --> C
  S -. --extract-taxonomy .-> C
  C --> D:::data
  classDef obitools fill:#99d57c
{{< /mermaid >}}

The command operates in one of several modes depending on the options provided:

| Mode | Trigger | Description |
|---|---|---|
| **Name query** | positional arguments | Search taxon names by regex (or literal with `--fixed`). Default mode. |
| **Subtree dump** | `--dump <TAXID>` | Output all taxa in the subtree rooted at the given taxid, as CSV or Newick. |
| **Lineage** | `--parents <TAXID>` | Print the full ancestral path from a taxid to the taxonomy root. |
| **Rank list** | `--rank-list` | List all taxonomic ranks present in the taxonomy. |
| **Extract** | `--extract-taxonomy` | Build a local taxonomy from the taxid annotations in a sequence file. |
| **Download** | `--download-ncbi` | Fetch the latest NCBI taxonomy dump from the NCBI FTP server. |

### Output format

By default {{< obi obitaxonomy >}} writes a CSV table to standard output. Each row represents
one taxon with the following default columns:

| Column | Description |
|---|---|
| `taxid` | Taxon identifier, written as `taxon:ID [name]@rank` (e.g. `taxon:9615 [Canis lupus familiaris]@subspecies`). Plain integer with `--raw-taxid`. |
| `parent` | Parent taxon, also written as `taxon:ID [name]@rank`. Plain integer with `--raw-taxid`. |
| `taxonomic_rank` | Taxonomic rank of the taxon (e.g. `species`, `genus`, `family`). |
| `scientific_name` | Scientific name of the taxon. Omit with `--without-scientific-name`. |

Additional columns:

| Column | Option | Notes |
|---|---|---|
| `query` | `--with-query` | Inserted as the **first** column; contains the search query that matched the taxon. |
| `path` | `--with-path` | Full lineage from the taxon to the root, formatted as `ID@name@rank\|...`. |

### Example: single-taxon lookup

```bash
obitaxonomy -t ncbitaxo.tgz --fixed "Canis lupus familiaris" \
  | csvlook
```

```
| taxid                                          | parent                           | taxonomic_rank | scientific_name        |
| ---------------------------------------------- | -------------------------------- | -------------- | ---------------------- |
| taxon:9615 [Canis lupus familiaris]@subspecies | taxon:9612 [Canis lupus]@species | subspecies     | Canis lupus familiaris |
```

### Example: lineage of domestic dog

```bash
obitaxonomy -t ncbitaxo.tgz --parents 9615
```

```
| taxid                                           | parent                                          | taxonomic_rank | scientific_name        |
| ----------------------------------------------- | ----------------------------------------------- | -------------- | ---------------------- |
| taxon:9615 [Canis lupus familiaris]@subspecies  | taxon:9612 [Canis lupus]@species                | subspecies     | Canis lupus familiaris |
| taxon:9612 [Canis lupus]@species                | taxon:9611 [Canis]@genus                        | species        | Canis lupus            |
| taxon:9611 [Canis]@genus                        | taxon:9608 [Canidae]@family                     | genus          | Canis                  |
| taxon:9608 [Canidae]@family                     | taxon:379584 [Caniformia]@suborder              | family         | Canidae                |
| taxon:379584 [Caniformia]@suborder              | taxon:33554 [Carnivora]@order                   | suborder       | Caniformia             |
| taxon:33554 [Carnivora]@order                   | taxon:314145 [Laurasiatheria]@superorder        | order          | Carnivora              |
| taxon:314145 [Laurasiatheria]@superorder        | taxon:1437010 [Boreoeutheria]@clade             | superorder     | Laurasiatheria         |
| taxon:1437010 [Boreoeutheria]@clade             | taxon:9347 [Eutheria]@clade                     | clade          | Boreoeutheria          |
| taxon:9347 [Eutheria]@clade                     | taxon:32525 [Theria]@clade                      | clade          | Eutheria               |
| taxon:32525 [Theria]@clade                      | taxon:40674 [Mammalia]@class                    | clade          | Theria                 |
| taxon:40674 [Mammalia]@class                    | taxon:32524 [Amniota]@clade                     | class          | Mammalia               |
| taxon:32524 [Amniota]@clade                     | taxon:32523 [Tetrapoda]@clade                   | clade          | Amniota                |
| taxon:32523 [Tetrapoda]@clade                   | taxon:1338369 [Dipnotetrapodomorpha]@clade      | clade          | Tetrapoda              |
| taxon:1338369 [Dipnotetrapodomorpha]@clade      | taxon:8287 [Sarcopterygii]@superclass           | clade          | Dipnotetrapodomorpha   |
| taxon:8287 [Sarcopterygii]@superclass           | taxon:117571 [Euteleostomi]@clade               | superclass     | Sarcopterygii          |
| taxon:117571 [Euteleostomi]@clade               | taxon:117570 [Teleostomi]@clade                 | clade          | Euteleostomi           |
| taxon:117570 [Teleostomi]@clade                 | taxon:7776 [Gnathostomata]@clade                | clade          | Teleostomi             |
| taxon:7776 [Gnathostomata]@clade                | taxon:7742 [Vertebrata]@clade                   | clade          | Gnathostomata          |
| taxon:7742 [Vertebrata]@clade                   | taxon:89593 [Craniata]@subphylum                | clade          | Vertebrata             |
| taxon:89593 [Craniata]@subphylum                | taxon:7711 [Chordata]@phylum                    | subphylum      | Craniata               |
| taxon:7711 [Chordata]@phylum                    | taxon:33511 [Deuterostomia]@clade               | phylum         | Chordata               |
| taxon:33511 [Deuterostomia]@clade               | taxon:33213 [Bilateria]@clade                   | clade          | Deuterostomia          |
| taxon:33213 [Bilateria]@clade                   | taxon:6072 [Eumetazoa]@clade                    | clade          | Bilateria              |
| taxon:6072 [Eumetazoa]@clade                    | taxon:33208 [Metazoa]@kingdom                   | clade          | Eumetazoa              |
| taxon:33208 [Metazoa]@kingdom                   | taxon:33154 [Opisthokonta]@clade                | kingdom        | Metazoa                |
| taxon:33154 [Opisthokonta]@clade                | taxon:2759 [Eukaryota]@domain                   | clade          | Opisthokonta           |
| taxon:2759 [Eukaryota]@domain                   | taxon:131567 [cellular organisms]@cellular root | domain         | Eukaryota              |
| taxon:131567 [cellular organisms]@cellular root | taxon:1 [root]@no rank                          | cellular root  | cellular organisms     |
| taxon:1 [root]@no rank                          | taxon:1 [root]@no rank                          | no rank        | root                   |
```

## Synopsis

```bash
obitaxonomy [--alternative-names|-a] [--batch-mem <string>]
            [--batch-size <int>] [--batch-size-max <int>] [--debug]
            [--download-ncbi] [--dump|-D <TAXID>] [--extract-taxonomy]
            [--fail-on-taxonomy] [--fixed|-F] [--help|-h|-?]
            [--max-cpu <int>] [--newick-output] [--no-progressbar]
            [--out|-o <FILENAME>] [--parents|-p <TAXID>] [--pprof]
            [--pprof-goroutine <int>] [--pprof-mutex <int>] [--rank <RANK>]
            [--rank-list|-l] [--raw-taxid]
            [--restrict-to-taxon|-r <string>]... [--silent-warning]
            [--solexa] [--sons|-s <TAXID>] [--taxonomy|-t <string>]
            [--update-taxid] [--version] [--with-leaves] [--with-path]
            [--with-query|-P] [--without-parent] [--without-rank|-R]
            [--without-root] [--without-scientific-name|-S] [<args>]
```

## Options

### *obitaxonomy* specific options

#### Data acquisition

- {{< cmd-options/obitaxonomy/download-ncbi >}}
- {{< cmd-options/obitaxonomy/extract-taxonomy >}}
- {{< cmd-option name="with-leaves" >}}
  When used with `--extract-taxonomy`, adds the input sequences themselves as leaf nodes under
  their respective taxids in the extracted taxonomy. (default: false)
  {{< /cmd-option >}}

#### Taxonomy inspection

- {{< cmd-options/obitaxonomy/dump >}}
- {{< cmd-option name="newick-output" >}}
  When used with `--dump`, writes the taxonomy subtree as a Newick-format tree string instead
  of the default CSV output. (default: false)
  {{< /cmd-option >}}
- {{< cmd-option name="without-root" >}}
  When used with `--newick-output`, excludes the non-branching path from the specified clade root up to
  the overall taxonomy root (taxid 1). Useful for keeping the output focused on the clade of
  interest. (default: false)
  {{< /cmd-option >}}
- {{< cmd-options/obitaxonomy/parents >}}
- {{< cmd-options/obitaxonomy/sons >}}
- {{< cmd-options/obitaxonomy/rank-list >}}

#### Name queries and filtering

- {{< cmd-options/obitaxonomy/fixed >}}
- {{< cmd-options/obitaxonomy/alternative-names >}}
- {{< cmd-options/obitaxonomy/restrict-to-taxon >}}
- {{< cmd-options/obitaxonomy/rank >}}

#### Output column control

- {{< cmd-options/obitaxonomy/with-query >}}
- {{< cmd-options/obitaxonomy/with-path >}}
- {{< cmd-options/obitaxonomy/without-scientific-name >}}
- {{< cmd-options/obitaxonomy/without-rank >}}
- {{< cmd-options/obitaxonomy/without-parent >}}
- {{< cmd-options/obitaxonomy/raw-taxid >}}

### Taxonomy options

- {{< cmd-options/taxonomy/taxonomy >}}
- {{< cmd-option name="update-taxid" >}}
  Automatically replaces taxids that have been declared as merged into a newer taxid in the
  taxonomy. A warning is emitted for each updated taxid. (default: false)
  {{< /cmd-option >}}
- {{< cmd-option name="fail-on-taxonomy" >}}
  Exits with a fatal error if any taxid encountered during processing is not a currently valid
  entry in the taxonomy. Combine with `--update-taxid` to first auto-update deprecated taxids
  before applying this check. (default: false)
  {{< /cmd-option >}}

{{< option-sets/common >}}

## Examples

### Download the NCBI taxonomy

Fetch the current NCBI taxonomy dump and save it locally:

```bash
obitaxonomy --download-ncbi
```

The output file is named `ncbitaxo_YYYYMMDD.tgz` (today's date) by default. You can decide for the filename using the `--out` option. 

```bash
obitaxonomy --download-ncbi \
            --out ncbitaxo.tgz
```

### List available taxonomic ranks

Print all taxonomic ranks present in the loaded taxonomy:

```bash
obitaxonomy -t ncbitaxo.tgz \
            --rank-list \
 | csvlook
```

```
| rank             |
| ---------------- |
| strain           |
| kingdom          |
| subcohort        |
| realm            |
| subvariety       |
| genus            |
| subfamily        |
| phylum           |
| clade            |
| infraorder       |
| superorder       |
| species subgroup |
| pathogroup       |
| species          |
| family           |
| subclass         |
| no rank          |
| biotype          |
| species group    |
| forma            |
| parvorder        |
| acellular root   |
| cellular root    |
| tribe            |
| class            |
| isolate          |
| genotype         |
| section          |
| domain           |
| subspecies       |
| subphylum        |
| superfamily      |
| subgenus         |
| cohort           |
| superphylum      |
| subsection       |
| order            |
| varietas         |
| forma specialis  |
| superclass       |
| serotype         |
| subtribe         |
| series           |
| morph            |
| serogroup        |
| suborder         |
| infraclass       |
| subkingdom       |
```

The NCBI taxonomy (version used here) contains 49 distinct taxonomic ranks.

### Name query — fixed string

Search for a taxon using an exact (literal) name match:

```bash
obitaxonomy -t ncbitaxo.tgz \
            --fixed \
            "Canis lupus familiaris" \
 | csvlook
```

```
| taxid                                          | parent                           | taxonomic_rank | scientific_name        |
| ---------------------------------------------- | -------------------------------- | -------------- | ---------------------- |
| taxon:9615 [Canis lupus familiaris]@subspecies | taxon:9612 [Canis lupus]@species | subspecies     | Canis lupus familiaris |
```

### Name query — regular expression pattern with alternative names

By default, without the `--fixed` option, the query term is considered a regular expression pattern. To search for all taxa with 'wolf' in their name, including synonyms and common names, use the `--alternative-names` option. Adding the `--with-query` option displays the query as the first column.

```bash
obitaxonomy -t ncbitaxo.tgz \
            --alternative-names \
            --with-query \
            "wolf"  \
 | csvlook
```

```
| query | taxid                                                              | parent                                               | taxonomic_rank | scientific_name                    |
| ----- | ------------------------------------------------------------------ | ---------------------------------------------------- | -------------- | ---------------------------------- |
| wolf  | taxon:3374999 [Klebsiella phage vB_KpnM_Wolf_ER13]@species         | taxon:12333 [unclassified bacterial viruses]@no rank | species        | Klebsiella phage vB_KpnM_Wolf_ER13 |
| wolf  | taxon:2913901 [Meteora]@genus                                      | taxon:2683617 [Eukaryota incertae sedis]@no rank     | genus          | Meteora                            |
| wolf  | taxon:2942894 [Microwolfvirus]@genus                               | taxon:2731619 [Caudoviricetes]@class                 | genus          | Microwolfvirus                     |
| wolf  | taxon:1034136 [Microwolfvirus JHC117]@species                      | taxon:2942894 [Microwolfvirus]@genus                 | species        | Microwolfvirus JHC117              |
| wolf  | taxon:2956194 [Microwolfvirus zetzy]@species                       | taxon:2942894 [Microwolfvirus]@genus                 | species        | Microwolfvirus zetzy               |
| ...   | ...                                                                | ...                                                  | ...            | ...                                |
```

This query returns 736 rows including all taxa whose scientific name or any alternative name contains the word "wolf".

### Dump a clade — species only

Output all species in the order Carnivora (taxid 33554):

```bash
obitaxonomy -t ncbitaxo.tgz \
            --dump 33554 \
            --rank species \
  | csvlook
```

```
| taxid                                             | parent                                          | taxonomic_rank | scientific_name              |
| ------------------------------------------------- | ----------------------------------------------- | -------------- | ---------------------------- |
| taxon:2828883 [Ursus kanivetz]@species            | taxon:9639 [Ursus]@genus                        | species        | Ursus kanivetz               |
| taxon:1825730 [Arctotherium sp.]@species          | taxon:2640560 [unclassified Arctotherium]@no rank | species      | Arctotherium sp.             |
| taxon:816549 [Carnivora sp. BOLD:AAF4913]@species | taxon:727684 [unclassified Carnivora]@no rank   | species        | Carnivora sp. BOLD:AAF4913   |
| taxon:9644 [Ursus arctos]@species                 | taxon:9639 [Ursus]@genus                        | species        | Ursus arctos                 |
| ...                                               | ...                                             | ...            | ...                          |
```

This returns 418 species. Without `--rank species`, the full Carnivora subtree (all ranks) is returned. If the `--without-root` option is not selected, the output will also include the taxonomic path from Carnivora up to the root (taxid 1).


### Extract taxonomy from a sequence file

Build a local taxonomy from the taxid annotations embedded in a sequence file,
including the sequence entries themselves as leaf nodes:

```bash
obitaxonomy -t ncbitaxo.tgz \
            --extract-taxonomy \
            --with-leaves \
            db_v05_r117.fasta.gz \
            > taxo_db_v05_r117.csv
```

Below the first ten lines of the [taxo_db_v05_r117.csv](taxo_db_v05_r117.csv)

```bash
csvlook taxo_db_v05_r117.csv \
  | head 
```
```
| taxid                                                                      | parent                                                             | taxonomic_rank | scientific_name                                    |
| -------------------------------------------------------------------------- | ------------------------------------------------------------------ | -------------- | -------------------------------------------------- |
| taxon:1 [root]@no rank                                                     | taxon:1 [root]@no rank                                             | no rank        | root                                               |
| taxon:131567 [cellular organisms]@cellular root                            | taxon:1 [root]@no rank                                             | cellular root  | cellular organisms                                 |
| taxon:2759 [Eukaryota]@domain                                              | taxon:131567 [cellular organisms]@cellular root                    | domain         | Eukaryota                                          |
| taxon:33154 [Opisthokonta]@clade                                           | taxon:2759 [Eukaryota]@domain                                      | clade          | Opisthokonta                                       |
| taxon:33208 [Metazoa]@kingdom                                              | taxon:33154 [Opisthokonta]@clade                                   | kingdom        | Metazoa                                            |
| taxon:6072 [Eumetazoa]@clade                                               | taxon:33208 [Metazoa]@kingdom                                      | clade          | Eumetazoa                                          |
| taxon:6073 [Cnidaria]@phylum                                               | taxon:6072 [Eumetazoa]@clade                                       | phylum         | Cnidaria                                           |
| taxon:6142 [Scyphozoa]@class                                               | taxon:6073 [Cnidaria]@phylum                                       | class          | Scyphozoa                                          |
```

This returns 13 815 taxonomy nodes 
- the 9 605 unique taxids referenced in the file, 
- their ancestors up to the root, 
- plus the sequences themselves added as leaves.


If you only want simple taxid without any supplementary information, you can add the `--raw-taxid` option.

```bash
obitaxonomy -t ncbitaxo.tgz \
            --extract-taxonomy \
            --raw-taxid \
            db_v05_r117.fasta.gz \
            > taxo_db_v05_r117_raw.csv
```
```bash
csvlook taxo_db_v05_r117_raw.csv \
  | head 
```
```
|     taxid |    parent | taxonomic_rank | scientific_name                                    |
| --------- | --------- | -------------- | -------------------------------------------------- |
|         1 |         1 | no rank        | root                                               |
|   131,567 |         1 | cellular root  | cellular organisms                                 |
|     2,759 |   131,567 | domain         | Eukaryota                                          |
|    33,154 |     2,759 | clade          | Opisthokonta                                       |
|    33,208 |    33,154 | kingdom        | Metazoa                                            |
|     6,072 |    33,208 | clade          | Eumetazoa                                          |
|     6,073 |     6,072 | phylum         | Cnidaria                                           |
|     6,142 |     6,073 | class          | Scyphozoa                                          |
```

### Producing a taxonomic tree corresponding to a sequence file

```bash
obitaxonomy -t ncbitaxo.tgz \
            --extract-taxonomy \
            --newick-output \
            --without-root \
            out_ecotag.fasta \
            > out_ecotag.nwk
```

produces the following [Newick](https://en.wikipedia.org/wiki/Newick_format) file

{{< code "out_ecotag.nwk" newick true >}}

That can be displayed as the following tree:

{{< phylocanvas file="out_ecotag.nwk" >}}

### Filter by clade and rank — with full lineage path

List all genera within the family Bovidae (taxid 9895), showing the full taxonomic path but
hiding the `parent` column:

```bash
obitaxonomy -t ncbitaxo.tgz \
            --restrict-to-taxon 9895 \
            --rank genus \
            --with-path \
            --without-parent \
  | csvlook
```

```
| taxid                               | taxonomic_rank | scientific_name | path                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ----------------------------------- | -------------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| taxon:3026943 [Cephalophorus]@genus | genus          | Cephalophorus   | 1@root@no rank|131567@cellular organisms@cellular root|2759@Eukaryota@domain|33154@Opisthokonta@clade|33208@Metazoa@kingdom|6072@Eumetazoa@clade|33213@Bilateria@clade|33511@Deuterostomia@clade|7711@Chordata@phylum|89593@Craniata@subphylum|7742@Vertebrata@clade|7776@Gnathostomata@clade|117570@Teleostomi@clade|117571@Euteleostomi@clade|8287@Sarcopterygii@superclass|1338369@Dipnotetrapodomorpha@clade|32523@Tetrapoda@clade|32524@Amniota@clade|40674@Mammalia@class|32525@Theria@clade|9347@Eutheria@clade|1437010@Boreoeutheria@clade|314145@Laurasiatheria@superorder|91561@Artiodactyla@order|9845@Ruminantia@suborder|35500@Pecora@infraorder|9895@Bovidae@family|9952@Cephalophinae@subfamily|3026943@Cephalophorus@genus |
| taxon:59514 [Addax]@genus           | genus          | Addax           | 1@root@no rank|131567@cellular organisms@cellular root|2759@Eukaryota@domain|33154@Opisthokonta@clade|33208@Metazoa@kingdom|6072@Eumetazoa@clade|33213@Bilateria@clade|33511@Deuterostomia@clade|7711@Chordata@phylum|89593@Craniata@subphylum|7742@Vertebrata@clade|7776@Gnathostomata@clade|117570@Teleostomi@clade|117571@Euteleostomi@clade|8287@Sarcopterygii@superclass|1338369@Dipnotetrapodomorpha@clade|32523@Tetrapoda@clade|32524@Amniota@clade|40674@Mammalia@class|32525@Theria@clade|9347@Eutheria@clade|1437010@Boreoeutheria@clade|314145@Laurasiatheria@superorder|91561@Artiodactyla@order|9845@Ruminantia@suborder|35500@Pecora@infraorder|9895@Bovidae@family|9959@Hippotraginae@subfamily|59514@Addax@genus           |
| taxon:9957 [Oryx]@genus             | genus          | Oryx            | 1@root@no rank|131567@cellular organisms@cellular root|2759@Eukaryota@domain|33154@Opisthokonta@clade|33208@Metazoa@kingdom|6072@Eumetazoa@clade|33213@Bilateria@clade|33511@Deuterostomia@clade|7711@Chordata@phylum|89593@Craniata@subphylum|7742@Vertebrata@clade|7776@Gnathostomata@clade|117570@Teleostomi@clade|117571@Euteleostomi@clade|8287@Sarcopterygii@superclass|1338369@Dipnotetrapodomorpha@clade|32523@Tetrapoda@clade|32524@Amniota@clade|40674@Mammalia@class|32525@Theria@clade|9347@Eutheria@clade|1437010@Boreoeutheria@clade|314145@Laurasiatheria@superorder|91561@Artiodactyla@order|9845@Ruminantia@suborder|35500@Pecora@infraorder|9895@Bovidae@family|9959@Hippotraginae@subfamily|9957@Oryx@genus             |
| taxon:9954 [Cephalophus]@genus      | genus          | Cephalophus     | 1@root@no rank|131567@cellular organisms@cellular root|2759@Eukaryota@domain|33154@Opisthokonta@clade|33208@Metazoa@kingdom|6072@Eumetazoa@clade|33213@Bilateria@clade|33511@Deuterostomia@clade|7711@Chordata@phylum|89593@Craniata@subphylum|7742@Vertebrata@clade|7776@Gnathostomata@clade|117570@Teleostomi@clade|117571@Euteleostomi@clade|8287@Sarcopterygii@superclass|1338369@Dipnotetrapodomorpha@clade|32523@Tetrapoda@clade|32524@Amniota@clade|40674@Mammalia@class|32525@Theria@clade|9347@Eutheria@clade|1437010@Boreoeutheria@clade|314145@Laurasiatheria@superorder|91561@Artiodactyla@order|9845@Ruminantia@suborder|35500@Pecora@infraorder|9895@Bovidae@family|9952@Cephalophinae@subfamily|9954@Cephalophus@genus      |
| taxon:119561 [Sylvicapra]@genus     | genus          | Sylvicapra      | 1@root@no rank|131567@cellular organisms@cellular root|2759@Eukaryota@domain|33154@Opisthokonta@clade|33208@Metazoa@kingdom|6072@Eumetazoa@clade|33213@Bilateria@clade|33511@Deuterostomia@clade|7711@Chordata@phylum|89593@Craniata@subphylum|7742@Vertebrata@clade|7776@Gnathostomata@clade|117570@Teleostomi@clade|117571@Euteleostomi@clade|8287@Sarcopterygii@superclass|1338369@Dipnotetrapodomorpha@clade|32523@Tetrapoda@clade|32524@Amniota@clade|40674@Mammalia@class|32525@Theria@clade|9347@Eutheria@clade|1437010@Boreoeutheria@clade|314145@Laurasiatheria@superorder|91561@Artiodactyla@order|9845@Ruminantia@suborder|35500@Pecora@infraorder|9895@Bovidae@family|9952@Cephalophinae@subfamily|119561@Sylvicapra@genus     |
| taxon:3033999 [Cephalophula]@genus  | genus          | Cephalophula    | 1@root@no rank|131567@cellular organisms@cellular root|2759@Eukaryota@domain|33154@Opisthokonta@clade|33208@Metazoa@kingdom|6072@Eumetazoa@clade|33213@Bilateria@clade|33511@Deuterostomia@clade|7711@Chordata@phylum|89593@Craniata@subphylum|7742@Vertebrata@clade|7776@Gnathostomata@clade|117570@Teleostomi@clade|117571@Euteleostomi@clade|8287@Sarcopterygii@superclass|1338369@Dipnotetrapodomorpha@clade|32523@Tetrapoda@clade|32524@Amniota@clade|40674@Mammalia@class|32525@Theria@clade|9347@Eutheria@clade|1437010@Boreoeutheria@clade|314145@Laurasiatheria@superorder|91561@Artiodactyla@order|9845@Ruminantia@suborder|35500@Pecora@infraorder|9895@Bovidae@family|9952@Cephalophinae@subfamily|3033999@Cephalophula@genus  |
| taxon:1922214 [Bootherium]@genus    | genus          | Bootherium      | 1@root@no rank|131567@cellular organisms@cellular root|2759@Eukaryota@domain|33154@Opisthokonta@clade|33208@Metazoa@kingdom|6072@Eumetazoa@clade|33213@Bilateria@clade|33511@Deuterostomia@clade|7711@Chordata@phylum|89593@Craniata@subphylum|7742@Vertebrata@clade|7776@Gnathostomata@clade|117570@Teleostomi@clade|117571@Euteleostomi@clade|8287@Sarcopterygii@superclass|1338369@Dipnotetrapodomorpha@clade|32523@Tetrapoda@clade|32524@Amniota@clade|40674@Mammalia@class|32525@Theria@clade|9347@Eutheria@clade|1437010@Boreoeutheria@clade|314145@Laurasiatheria@superorder|91561@Artiodactyla@order|9845@Ruminantia@suborder|35500@Pecora@infraorder|9895@Bovidae@family|9963@Caprinae@subfamily|1922214@Bootherium@genus         |
| taxon:59516 [Alcelaphus]@genus      | genus          | Alcelaphus      | 1@root@no rank|131567@cellular organisms@cellular root|2759@Eukaryota@domain|33154@Opisthokonta@clade|33208@Metazoa@kingdom|6072@Eumetazoa@clade|33213@Bilateria@clade|33511@Deuterostomia@clade|7711@Chordata@phylum|89593@Craniata@subphylum|7742@Vertebrata@clade|7776@Gnathostomata@clade|117570@Teleostomi@clade|117571@Euteleostomi@clade|8287@Sarcopterygii@superclass|1338369@Dipnotetrapodomorpha@clade|32523@Tetrapoda@clade|32524@Amniota@clade|40674@Mammalia@class|32525@Theria@clade|9347@Eutheria@clade|1437010@Boreoeutheria@clade|314145@Laurasiatheria@superorder|91561@Artiodactyla@order|9845@Ruminantia@suborder|35500@Pecora@infraorder|9895@Bovidae@family|37170@Alcelaphinae@subfamily|59516@Alcelaphus@genus      |
| taxon:34874 [Saiga]@genus           | genus          | Saiga           | 1@root@no rank|131567@cellular organisms@cellular root|2759@Eukaryota@domain|33154@Opisthokonta@clade|33208@Metazoa@kingdom|6072@Eumetazoa@clade|33213@Bilateria@clade|33511@Deuterostomia@clade|7711@Chordata@phylum|89593@Craniata@subphylum|7742@Vertebrata@clade|7776@Gnathostomata@clade|117570@Teleostomi@clade|117571@Euteleostomi@clade|8287@Sarcopterygii@superclass|1338369@Dipnotetrapodomorpha@clade|32523@Tetrapoda@clade|32524@Amniota@clade|40674@Mammalia@class|32525@Theria@clade|9347@Eutheria@clade|1437010@Boreoeutheria@clade|314145@Laurasiatheria@superorder|91561@Artiodactyla@order|9845@Ruminantia@suborder|35500@Pecora@infraorder|9895@Bovidae@family|9948@Antilopinae@subfamily|34874@Saiga@genus             |
...
```

The `path` column contains the full lineage from root to the taxon, with each node encoded as
`ID@name@rank` and nodes separated by `|`. This query returns 57 genera.


This returns 1 153 plain integer taxids — the full Primate subtree plus the path to the
taxonomy root. The `--raw-taxid` flag makes both `taxid` and `parent` plain integers instead of the default `taxon:ID [name]@rank` strings.


### obitaxonomy help

```bash
obitaxonomy --help
```
