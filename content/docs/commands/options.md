+++
title = 'Shared command options'
date = 2024-10-04T17:16:03+02:00
draft = true
weight = 10
+++

Some {{% obitools %}} command options are shared by several commands. These options are listed in the following table.

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

Once the environment variable is set, any {{% obitools %}} run in the same shell session will use the value of four CPU cores, in this case without the need to specify the `--max-cpu` option.


{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}
