---
archetype: "command"
title: "obitaxonomy"
date: 2025-02-10
command: "_index."
category: taxonomy
url: "/obitools/obitaxonomy"
---

# `obitaxonomy`: manage and request a taxonomy database

## Description 



## Synopsis

```bash
obitaxonomy [--alternative-names|-a] [--batch-size <int>] [--debug]
            [--download-ncbi] [--dump|-D <TAXID>] [--extract-taxonomy]
            [--fixed|-F] [--force-one-cpu] [--help|-h|-?] [--max-cpu <int>]
            [--no-progressbar] [--out|-o <FILENAME>] [--parents|-p <TAXID>]
            [--pprof] [--pprof-goroutine <int>] [--pprof-mutex <int>]
            [--rank <RANK>] [--rank-list|-l] [--raw-taxid]
            [--restrict-to-taxon|-r <string>]... [--solexa]
            [--sons|-s <TAXID>] [--taxonomy|-t <string>] [--version]
            [--with-path] [--with-query|-P] [--without-parent]
            [--without-rank|-R] [--without-scientific-name|-S] [<args>]
```

## Options

#### {{< obi obitaxonomy >}} specific options

- {{< cmd-options/obitaxonomy/alternative-names >}}
- {{< cmd-options/obitaxonomy/download-ncbi >}}
- {{< cmd-options/obitaxonomy/dump >}}
- {{< cmd-options/obitaxonomy/extract-taxonomy >}}
- {{< cmd-options/obitaxonomy/fixed >}}
- {{< cmd-options/obitaxonomy/parents >}}
- {{< cmd-options/obitaxonomy/rank >}}
- {{< cmd-options/obitaxonomy/rank-list >}}
- {{< cmd-options/obitaxonomy/restrict-to-taxon >}}
- {{< cmd-options/obitaxonomy/sons >}}
- {{< cmd-options/obitaxonomy/with-path >}}
- {{< cmd-options/obitaxonomy/with-query >}}
- {{< cmd-options/obitaxonomy/without-parent >}}
- {{< cmd-options/obitaxonomy/without-rank >}}
- {{< cmd-options/obitaxonomy/without-scientific-name >}}

#### Taxonomic options
- {{< cmd-options/taxonomy/taxonomy >}}

{{< option-sets/common >}}

## Examples

```bash
obitaxonomy --help
```
