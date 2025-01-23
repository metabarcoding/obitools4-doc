---
archetype: "command"
title: "Obimatrix: convert a sequence file into a data matrix file"
date: 2025-01-23
command: "obimatrix"
url: "/obitools/obimatrix"
weight: 100
---

## `obimatrix`: convert a sequence file into a data matrix file

### Description 

Convert a mapping tag from a sequence file to a matrix file in CSV format.

### Synopsis

```bash
obimatrix [--batch-size <int>] [--debug] [--ecopcr] [--embl] [--fasta]
          [--fastq] [--force-one-cpu] [--genbank] [--help|-h|-?]
          [--input-OBI-header] [--input-json-header] [--map <string>]
          [--max-cpu <int>] [--na-value <string>] [--no-order] [--pprof]
          [--pprof-goroutine <int>] [--pprof-mutex <int>]
          [--sample-name <string>] [--solexa] [--three-columns] [--transpose]
          [--value-name <string>] [--version] [<args>]
```

### Options

#### {{< obi obimatrix >}} specific options:

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
obimatrix --help
```
