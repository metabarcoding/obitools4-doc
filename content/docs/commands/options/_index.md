---
title: 'Shared command options'
date: 2024-10-04T17:16:03+02:00
draft: true
weight: 10
---

# Customising the execution of {{% obitools %}}

{{% obitools %}} are a set of UNIX commands that can be used from a UNIX shell. They can be used interactively from a terminal, or as part of a shell script to automate a data analysis pipeline. Each {{% obitools %}} command implements an algorithm to process the data. For example, the {{< obi obicount >}} command implements an algorithm to count the number of sequences in a sequence file.

{{< code "two_sequences.fasta" fasta true >}}

```bash
obicount two_sequences.fasta
```
```
entities,n
variants,2
reads,3
symbols,200
```

In addition to its name, an {{% obitools %}} command has a number of options that allow you to customise its behaviour. For example, the {{< obi obicount >}} command has the `--symbols` option, which tells it to count only the total number of nucleotides in the sequence file.

```bash
obicount --symbols two_sequences.fasta
```
```
entities,n
symbols,200
``` 

If you compare the two outputs, you will notice that the first version of the {{< obi obicount >}} command without the `--symbols` option counts the total number of nucleotides, but also the number of sequence variants and the number of reads, while the second version with the `--symbols` option counts only the total number of nucleotides.

## Multiple ways to specify the same option

Unix options are specified on the command line by adding then after the command name. They can take two forms:

- The long option name, which is the name of the option preceded by two hyphens, for example `--help`.
- For some options, such as the `help` option, there is also a short version of the option. This consists of a single character preceded by a single hyphen, for example `-h`.

If multiple forms of the same option exist, they are separated in the documentation by a vertical bar `|`, *e.g.* the option `help` exists in its long form `--help` and in one of its short forms `-h` or `-?`. These different forms are represented as follows `--help|-h|-?`.

## Specifying an option through environment variables

Options such as `--max-cpu`, which specifies the maximum number of CPU cores used by {{% obitools %}}, can be specified when running the command

```bash
obicount --max-cpu=4 my_sequence.fasta
```

or by declaring an environment variable. For this example, the environment variable corresponding to the `--max-cpu` option is `OBIMAXCPU`. When using [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) or [zsh](https://en.wikipedia.org/wiki/Z_shell) shells, the environment variable can be set using the `export` command:

```bash
export OBIMAXCPU=4
```

Once the environment variable is set, any {{% obitools %}} command run in the same shell session will use the value of four CPU cores, in this case without the need to specify the `--max-cpu` option.

Some {{% obitools %}} options are shared by most of the commands. These options are listed in the following table.

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}