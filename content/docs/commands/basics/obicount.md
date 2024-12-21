---
title: "Obicount: Counting sequence records"
category: "basics"
command: "obicount"
url: "/obitools/obicount"
---

## `obicount`: Counting sequence records

### Description

Count the sequence records in a sequence file. It returns three pieces of information. The first is the number of sequence variants (the actual number of sequence records in the file). Each sequence record is associated with a *count* attribute (equal to 1 if absent), this number corresponds to the number of times that sequence has been observed in the data set. Thus, the second value returned is the sum of the count values for all sequences. The last value is the number of nucleotides stored in the file, the sum of the sequence lengths.

### Synopsis

```bash
obicount [--batch-size <int>] [--debug] [--ecopcr] [--embl] [--fasta]
         [--fastq] [--force-one-cpu] [--genbank] [--help|-h|-?]
         [--input-OBI-header] [--input-json-header] [--max-cpu <int>]
         [--no-order] [--pprof] [--pprof-goroutine <int>]
         [--pprof-mutex <int>] [--reads|-r] [--solexa] [--symbols|-s]
         [--variants|-v] [--version] [<args>]
```

### Options

#### {{< obi obicount >}} specific options:

- {{< cmd-option name="variants" short="v" >}}
  When present, output the number of variants (sequence records) in the sequence file.
  {{< /cmd-option >}}

- {{< cmd-option name="reads" short="r" >}}
  When present, output the number of reads (the sum of sequence counts) in the sequence file.
  {{< /cmd-option >}}

- {{< cmd-option name="symbols" short="s" >}}
  When present, output the number of symbols (nucleotides) in the sequence file.
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/common >}}

### Examples

By default the {{< obi obicount >}} command will output the number of variants, reads and symbols in the sequence file.

```bash
obicount my_sequence_file.fasta
```

```
INFO[0000] Number of workers set 16
INFO[0000] Found 1 files to process
INFO[0000] xxx.fastq.gz mime type: text/fastq

entites,n
variants,43221
reads,43221
symbols,4391530
```

The output is in CSV format and can avantageously transformed to Markdown for a prettier output using the [`csvtomd`](https://github.com/brentp/csvtomd) command.

```bash
obicount my_sequence_file.fasta | csvtomd
```

```
INFO[0000] Number of workers set 16
INFO[0000] Found 1 files to process
INFO[0000] xxx.fastq.gz mime type: text/fastq

entites   |  n
----------|---------
variants  |  43221
reads     |  43221
symbols   |  4391530
```

the conversion can also be done with the `csvlook` command from the [csvkit](https://csvkit.readthedocs.io/) package.

```bash
obicount my_sequence_file.fasta | csvlook
```

```
INFO[0000] Number of workers set 16
INFO[0000] Found 1 files to process
INFO[0000] xxx.fastq.gz mime type: text/fastq

| entites  |         n |
| -------- | --------- |
| variants |    43 221 |
| reads    |    43 221 |
| symbols  | 4 391 530 |
```

When using the `--variants`, `--reads` or `--symbols` option, the output only contains the number corresponding to the options specified.

```bash
obicount -v --reads my_sequence_file.fasta | csvlook
```

```
INFO[0000] Number of workers set 16
INFO[0000] Found 1 files to process
INFO[0000] xxx.fastq.gz mime type: text/fastq

| entites  |      n |
| -------- | ------ |
| variants | 43 221 |
| reads    | 43 221 |
```

As for all the OBITools commands, the input file can be compressed with gzip.

```bash
obicount my_sequence_file.fasta.gz | csvlook
```

```
INFO[0000] Number of workers set 16
INFO[0000] Found 1 files to process
INFO[0000] xxx.fastq.gz mime type: text/fastq

| entites  |         n |
| -------- | --------- |
| variants |    43 221 |
| reads    |    43 221 |
| symbols  | 4 391 530 |
```
