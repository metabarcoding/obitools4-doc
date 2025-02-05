---
title: "NCBI taxdump"
weight: 1
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# The *NCBI taxonomy dump*

The NCBI provides a taxonomy that is used as a reference taxonomy for all molecular data published by [NCBI](https://ncbi.nlm.nih.gov), [EBI](https://www.ebi.ac.uk/ena) and [DDBJ](https://www.ddbj.nig.ac.jp/). This taxonomy is available via a [web interface](https://www.ncbi.nlm.nih.gov/taxonomy/), but can also be downloaded from the [NCBI FTP server](https://ftp.ncbi.nlm.nih.gov).

The NCBI taxonomy can be used by {{% obitools4 %}} by downloading the [taxdump](https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz) from the [NCBI FTP server](https://ftp.ncbi.nlm.nih.gov). The file is a gzipped tarball archive containing the following files required by {{% obitools4 %}}:

* [`nodes.dmp`]({{< ref "#nodes.dmp" >}}) : a tab-separated file containing the taxonomic hierarchy
* [`names.dmp`]({{< ref "#names.dmp" >}}) : a tab-separated file containing the scientific names of the organisms
* [`merged.dmp`]({{< ref "#merged.dmp" >}}) : a tab-separated file containing the information about reassignment of taxids
* [`delnodes.dmp`]({{< ref "#delnodes.dmp" >}}) : a tab-separated file containing the information about old taxids today deleted from the taxonomy.

## Downloading the NCBI taxonomy dump

The {{< obi obitaxonomy >}} command provides the `--download-ncbi` option, which downloads a copy of the NCBI taxonomy dump tarball from the [NCBI FTP server](https://ftp.ncbi.nlm.nih.gov). By default, the file is downloaded to the current directory with the name `ncbitaxo_YYYYMMDD.tgz`, where *YYYY* is the year, *MM* the month and *DD* the current date.
The filename used to save the tarball can be specified with the `--out` option, as in the following example:

```bash
obitaxonomy --download-ncbi --out ncbitaxo.tgz
```

> [!NOTE]
> {{% obitools4 %}} do not require extracting the downloaded file. The name of the compressed file can be passed directly to any {{% obitools4 %}} command using the `--taxonomy` option.

## Structure of the NCBI taxonomy directory

When the archive is unpacked using the following bash commands:

```bash
mkdir ncbitaxo 
cd ncbitaxo 
tar -zxvf ../ncbitaxo.tgz
cd ..
```

The `ncbitaxo` directory contains all the files provided by NCBI. The `readme.txt` file describes the content of each file provided.
Only the files used by {{% obitools4 %}} are described below.

### The `nodes.dmp` file {#nodes.dmp}

The `nodes.dmp` file is a tab-separated file, here is the description of the first columns used by {{% obitools4 %}}:

| Field | Description |
|-------|---------------|
| `tax_id` | A unique taxonomic identifier composed only of digits (0-9) lower case (a-z) and upper case (A-Z) characters |
| `parent tax_id` | The taxid of the parent taxon of the current taxon |
<!-- | `scientific_name` | The name used by the *OBITools* as the scientific name of the taxon | -->
| `rank` | The taxonomic rank of the taxon (*e.g.* species, genus, family, etc.) |

Here are the first lines of this file:

```
1       |       1       |       no rank |               |       8       |       0       |       1       |       0       |       0       |       0       |     0|       0       |               |
2       |       131567  |       superkingdom    |               |       0       |       0       |       11      |       0       |       0       |       0     |0       |       0       |               |
6       |       335928  |       genus   |               |       0       |       1       |       11      |       1       |       0       |       1       |     0|       0       |               |
7       |       6       |       species |       AC      |       0       |       1       |       11      |       1       |       0       |       1       |     1|       0       |               |
9       |       32199   |       species |       BA      |       0       |       1       |       11      |       1       |       0       |       1       |     1|       0       |               |
10      |       1706371 |       genus   |               |       0       |       1       |       11      |       1       |       0       |       1       |     0|       0       |               |
11      |       1707    |       species |       CG      |       0       |       1       |       11      |       1       |       0       |       1       |     1|       0       |       effective current name; |
13      |       203488  |       genus   |               |       0       |       1       |       11      |       1       |       0       |       1       |     0|       0       |               |
14      |       13      |       species |       DT      |       0       |       1       |       11      |       1       |       0       |       1       |     1|       0       |               |
16      |       32011   |       genus   |               |       0       |       1       |       11      |       1       |       0       |       1       |     0|       0       |               |
```

### The `names.dmp` file {#names.dmp}

The `names.dmp` file is a tab-separated file with the following columns:

| Field | Description |
|-------|---------------|
| `tax_id` | The node identifier associated with this name |
| `name_txt` | The name itself |
| `unique name` | The unique variant of this name if name not unique |
| `name class` | (synonym, common name, ...) |

Here are the first lines of this file:

```
1       |       all     |               |       synonym |
1       |       root    |               |       scientific name |
2       |       Bacteria        |       Bacteria <bacteria>     |       scientific name |
2       |       bacteria        |               |       blast name      |
2       |       eubacteria      |               |       genbank common name     |
2       |       Monera  |       Monera <bacteria>       |       in-part |
2       |       Procaryotae     |       Procaryotae <bacteria>  |       in-part |
2       |       Prokaryotae     |       Prokaryotae <bacteria>  |       in-part |
2       |       Prokaryota      |       Prokaryota <bacteria>   |       in-part |
2       |       prokaryote      |       prokaryote <bacteria>   |       in-part |
```

### The `merged.dmp` file {#merged.dmp}

The `merged.dmp` file is a tab-separated file with the following columns:

| Field | Description |
|-------|---------------|
| `old_tax_id` | The node identifier which has been merged |
| `new_tax_id` | The node identifier which is result of merging |

Here are the first lines of this file:

```
12      |       74109   |
30      |       29      |
36      |       184914  |
37      |       42      |
46      |       39      |
67      |       32033   |
76      |       155892  |
77      |       74311   |
79      |       74313   |
80      |       155892  |
```

### The `delnodes.dmp` file {#delnodes.dmp}

The `delnodes.dmp` file is a tab-separated file with the following columns:

| Field | Description |
|-------|---------------|
| `tax_id` | The deleted node ID |

Here are the first lines of this file:

```
3025011 |
3025010 |
3025009 |
3025008 |
3025007 |
3025006 |
3025005 |
3025004 |
3025003 |
3025002 |
```