---
title: "The JSON format"
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

To facilitate the exchange of data between different systems, and allow an easy parsing of the data with all the programming languages, {{% obitools %}} propose to export the sequence data in the [JSON](https://en.wikipedia.org/wiki/JSON) format. JSON output is requested by adding the `--json-output` option to the command line.

For the following two sequences examples:

{{< code json_example.fasta fasta true>}}

the command :

```bash
obiconvert --json-output json_example.fasta > json_example.json
```

will produce the following JSON output:

{{< code json_example.json json true>}}

With a {{% fastq %}} file:

{{< code json_example.fasta fastq true>}}

the equivalent command :

```bash
obiconvert --json-output json_example.fastq > json_example_qual.json
```

will produce the following JSON output:

{{< code json_example_qual.json json true>}}
