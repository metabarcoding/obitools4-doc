---
archetype: "command"
title: "obitaxonomy: Manage taxonomy"
date: 2025-01-23
command: "_index."
url: "/obitools/obitaxonomy"
---

## `obitaxonomy` : Manage and search in the taxonomy database

### Description 



### Synopsis

```bash
obitaxonomy [--alternative-names|-a] [--batch-size <int>] [--compressed|-Z]
            [--debug] [--download-ncbi] [--dump|-D <TAXID>] [--fixed|-F]
            [--force-one-cpu] [--help|-h|-?] [--max-cpu <int>]
            [--no-progressbar] [--out|-o <FILENAME>] [--parents|-p <TAXID>]
            [--pprof] [--pprof-goroutine <int>] [--pprof-mutex <int>]
            [--rank <RANK>] [--rank-list|-l] [--raw-taxid]
            [--restrict-to-taxon|-r <string>]... [--solexa]
            [--sons|-s <TAXID>] [--taxonomy|-t <string>] [--version]
            [--with-path] [--with-query|-P] [--without-parent]
            [--without-rank|-R] [--without-scientific-name|-S] [<args>]
```

### Options

#### {{< obi _index. >}} specific options:

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/common >}}

### Examples

```bash
obitaxonomy --help
```
