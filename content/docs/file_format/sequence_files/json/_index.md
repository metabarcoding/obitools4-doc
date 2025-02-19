---
title: "JSON format"
weight: 100
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
url: "/formats/json"
---

# The *JSON* sequence file format

To facilitate the exchange of data between different systems, and to allow easy parsing of the data with all programming languages, {{% obitools %}} offers to export sequence data in [JSON](https://en.wikipedia.org/wiki/JSON) format. JSON output is requested by adding the `--json-output` option to the command line.

## Converting FASTA to JSON format

Here it is an example of two sequences in {{% fasta %}} format:

{{< code json_example.fasta fasta true>}}

that you can convert in JSON with the {{< obi obiconvert >}} command:

```bash
obiconvert --json-output json_example.fasta > json_example.json
```

which produces the following JSON output:

{{< code json_example.json json true>}}

## Converting FASTQ to JSON format

To convert a {{% fastq %}} file as the following example:

{{< code json_example.fasta fastq true>}}

use the equivalent command:

```bash
obiconvert --json-output json_example.fastq > json_example_qual.json
```

which produces the following JSON output:

{{< code json_example_qual.json json true>}}