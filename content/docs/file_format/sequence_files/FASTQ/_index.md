---
title: "FASTQ file format"
weight: 30
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
bibFile: bibliography/bibliography.json 
url: "/formats/fastq"
---

# The *FASTQ* sequence file format

The [FASTQ](https://en.wikipedia.org/wiki/FASTQ_format) sequence file format is widely used for storing biological sequences and their corresponding quality scores. It was originally developed at the [Wellcome Trust Sanger Institute](https://www.sanger.ac.uk/) to bundle a {{% fasta %}} sequence together with its quality data {{< cite "Cock2010-wl" >}}. The format has become the *de facto* standard for storing the output of high-throughput sequencing instruments.

In *FASTQ* format, each sequence entry consists of four lines:
1. A sequence identifier line beginning with an **@** character
2. The raw sequence letters following the [`iupac`]({{< ref "/docs/patterns/dnagrep/#iupac-codes-for-ambiguous-bases" >}}) code
3. A separator line beginning with a **+** character (optionally followed by the same sequence identifier)
4. The quality scores encoded in ASCII format

```
@my_sequence this is my pretty sequence
ACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGT
+
CCCCCCC<CcCccbe[`F`accXV<TA\RYU\\ee_e[XZ
```

The first word after the '@' symbol in the identifier line is the sequence identifier. The rest of the line is a description of the sequence. 

The qualities line gives information about the quality scores assigned to each base by the sequencing machine during the sequencing process. It indicates the probability that the base read is incorrectly sequenced.

{{< katex display=true >}}
P(error) = 10^{-\frac{Q}{10}}
{{< /katex >}}

Sequencers typically provide quality scores in the range of {{< katex >}}0{{< /katex >}} to {{< katex >}}40{{< /katex >}}, which corresponds to a probability of error {{< katex >}}P(Error){{< /katex >}} in the range of {{< katex >}}10^{0} = 1{{< /katex >}} to {{< katex >}}10^{-4}{{< /katex >}}. The higher the score, the lower the probability of error.

<!-- 

quality <- ggplot() + geom_function(fun = function(x) 10^(-x/10)) + xlim(0,40) + xlab("Quality") + ylab(expression(P(Error) == 10^{-Q/10})) + theme_minimal() + scale_y_log10()
ggsave("qality.png",quality) 
-->

{{< figure src="quality.png" 
    alt="Quality scores to error probability relationship"
    caption="Figure showing the relationship between FASTQ quality scores and error probability" 
    width="600px" >}}

In *FASTQ* format, the sequence of quality score is encoded as an ASCII string where each score is mapped to an ASCII character. The quality score {{< katex >}}0{{< /katex >}} is encoded as the character `!`. The quality score {{< katex >}}40{{< /katex >}} is encoded as the character `I` (uppercase `i`).

The {{% obitools %}} extend this format by adding structured data to the identifier line. In the previous version of the {{% obitools %}}, the structured data was stored after the sequence identifier in a `key=value;` format, as shown below. The sequence definition was stored as free text after the last `key=value;` pair.

{{< code "two_sequences_obi2.fastq" fastq true >}}

With {{% obitools4 %}} a new format has been introduced to store structured data in the identifier line. The *key*/*value* annotation pairs are now formatted as a [JSON](https://en.wikipedia.org/wiki/JSON) map object. The definition is stored as an additional *key*/*value* pair using the *key* `definition'.

{{< code "two_sequences_obi4.fastq" fastq true >}}

The {{< obi obiconvert >}} command, like all other {{% obitools4 %}} commands, has two options `--output-json-header` and `--output-OBI-header` to choose between the new [JSON](https://en.wikipedia.org/wiki/JSON) format and the old {{% obitools %}} format. The `--output-OBI-header` option can be abbreviated to `-O`. By default, the new [JSON](https://en.wikipedia.org/wiki/JSON) {{% obitools4 %}} format is used, so only the `-O` option is really useful if the old format is required for compatibility with other software.

Converting from the new [JSON](https://en.wikipedia.org/wiki/JSON) format to the old {{% obitools %}} format:

```bash
obiconvert -O two_sequences_obi4.fastq
```
{{< code "two_sequences_obi2.fastq" fastq false >}} 

Converting from the old {{% obitools %}} format to the new [JSON](https://en.wikipedia.org/wiki/JSON) format:

```bash
obiconvert two_sequences_obi2.fastq
```
{{< code "two_sequences_obi4.fastq" fastq false >}} 

The actual format of the header is automatically detected when {{% obitools4 %}} commands read a FASTQ file.

## References

{{< bibliography cited >}}