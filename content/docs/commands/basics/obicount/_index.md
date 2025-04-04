---
archetype: "command"
category: "basics"
title: "obicount"
date: 2025-02-10
command: "obicount"
url: "/obitools/obicount"
weight: 40
---


# `obicount`: counting sequence records

## Description

Count the sequence records in a sequence file. It returns three pieces of information. The first is the number of sequence records. Each sequence record is associated with a `count` attribute (equal to 1 if absent), this number corresponds to the number of times that sequence has been observed in the non-dereplicated data set. In the following example, the first sequence record has no `count` attribute and therefore counts for 1, when the second sequence record has a `count` attribute equal to 2.

{{< code "two_sequences.fasta" fasta false>}}

Thus, the second value returned is the sum of the count values for all sequences, 3 for the presented example file. The last value is the number of nucleotides stored in the file, the sum of the sequence lengths, without accounting for the `count` tag.


{{< mermaid class="workflow" >}}
graph TD
  A@{ shape: doc, label: "my_sequences.fastq" }
  C[obicount]
  D@{ shape: doc, label: "counts.csv" }
  A --> C:::obitools
  C --> D
  classDef obitools fill:#99d57c
{{< /mermaid >}}



## Synopsis

```bash
obicount [--batch-size <int>] [--debug] [--ecopcr] [--embl] [--fasta]
         [--fastq] [--force-one-cpu] [--genbank] [--help|-h|-?]
         [--input-OBI-header] [--input-json-header] [--max-cpu <int>]
         [--no-order] [--pprof] [--pprof-goroutine <int>]
         [--pprof-mutex <int>] [--reads|-r] [--solexa] [--symbols|-s]
         [--variants|-v] [--version] [<args>]
```



## Options

#### {{< obi obicount >}} specific options

- {{< cmd-option name="variants" short="v" >}}
  when present, output the only the number of sequence records in the file.
  {{< /cmd-option >}}

- {{< cmd-option name="reads" short="r" >}}
  when present, output only the sum of sequence counts in the file.
  {{< /cmd-option >}}

- {{< cmd-option name="symbols" short="s" >}}
  when present, output only the number of nucleotides in the file.
  {{< /cmd-option >}}

 It is possible to combine two of the above options. 

{{< option-sets/input >}}

{{< option-sets/common >}}

## Examples

By default, the {{< obi obicount >}} command will output the number of sequence records (variants), sum of counts (reads), and number of nucleotides (symbols) in the sequence file.

```bash
obicount my_sequence_file.fasta
```

```
INFO[0000] Number of workers set 16
INFO[0000] Found 1 files to process
INFO[0000] xxx.fastq.gz mime type: text/fastq

entities,n
variants,43221
reads,43221
symbols,4391530
```

The output is in CSV format and can be transformed into Markdown for a prettier output using the [`csvtomd`](https://github.com/brentp/csvtomd) command.

```bash
obicount my_sequence_file.fasta | csvtomd
```

```
entities  |  n
----------|---------
variants  |  43221
reads     |  43221
symbols   |  4391530
```

The conversion can also be done with the `csvlook` command from the [csvkit](https://csvkit.readthedocs.io/) package.

```bash
obicount my_sequence_file.fasta | csvlook
```

```
| entities |         n |
| -------- | --------- |
| variants |    43 221 |
| reads    |    43 221 |
| symbols  | 4 391 530 |
```

When using the `--variants`, `--reads` or `--symbols` option, the output only contains the number(s) corresponding to the specified option(s).

```bash
obicount -v --reads my_sequence_file.fasta | csvlook
```

```
| entities |      n |
| -------- | ------ |
| variants | 43 221 |
| reads    | 43 221 |
```

As for all the OBITools commands, a GZIP compressed input file can be used.

```bash
obicount my_sequence_file.fasta.gz | csvlook
```

```
| entities |         n |
| -------- | --------- |
| variants |    43 221 |
| reads    |    43 221 |
| symbols  | 4 391 530 |
```

