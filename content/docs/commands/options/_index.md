+++
title = 'Shared command options'
date = 2024-10-04T17:16:03+02:00
draft = true
weight = 10
+++

# Customise {{% obitools %}} execution

{{% obitools %}} are a set of UNIX commands that can be used from a UNIX shell. They can be used interactively from a terminal, or as part of a shell script to automate a data analysis pipeline. Each {{% obitools %}} command implements an algorithm to process the data. For example, the {{< obi obicount >}} command implements an algorithm to count the number of sequences in a sequence file.

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
## Several ways to specify the same option

Some options can be specified in more than one way. For example, the `help` option can be specified with the long `--help` option or with one of the short `-h` or `-?` options. The table below shows the different ways of specifying the `help` option, separated by the `|` symbol: `--help|-h|-?`.

## Specifying an option through environment variables

Options such as `--max-cpu`, which specifies the maximum number of CPU cores used by {{% obitools %}}, can be specified when running the command

```sh
obicount --max-cpu=4 my_sequence.fasta
```

or by declaring an environment variable. For this example, the environment variable corresponding to the `--max-cpu` option is `OBIMAXCPU`. When using [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) or [zsh](https://en.wikipedia.org/wiki/Z_shell) shells, the environment variable can be set using the `export` command:

```sh
export OBIMAXCPU=4
```

Once the environment variable is set, any {{% obitools %}} command run in the same shell session will use the value of four CPU cores, in this case without the need to specify the `--max-cpu` option.

Some {{% obitools %}} options are shared by several commands. These options are listed in the following table.


{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}
