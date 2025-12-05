---
archetype: "command"
title: "obimultiplex"
date: 2025-02-10
command: "obimultiplex"
category: demultiplexing
url: "/obitools/obimultiplex"
---

# `obimultiplex`: demultiplex the sequence reads

## Description 

The {{% obi obimultiplex %}} command demultiplexes sequencing reads by identifying sample-specific tags (barcodes) and PCR primers in the sequences. It assigns each sequence to its corresponding sample based on the tag combinations and primer sequences provided in a sample description file.

The demultiplexing process involves:

- Identifying forward and reverse PCR primers in the sequences.
- Detecting sample-specific tags.
- Assigning sequences to samples based on the tag/primer combinations.
- Trimming primers and tags from the sequences.
- Reverse complementing the sequences if needed.
- Adding comprehensive annotations about the identification process.

### The new `obimultiplex` sample description file format

If {{% obi obimultiplex %}} is still able to use the old *ngsfilter* format used by the legacy obitools, it is now preferable to rely on the new format.

The new format is a {{% csv %}} file, which can easily be prepared using an export from your favourite spreadsheet program.

```csv
# primer matching options
@param,primer_mismatches,2
@param,indels,false
# tag matching options
@param,matching,strict
experiment,sample,sample_tag,forward_primer,reverse_primer
wolf_diet,13a_F730603,aattaac,TTAGATACCCCACTATGC,TAGAACAGGCTCCTCTAG
wolf_diet,15a_F730814,gaagtag,TTAGATACCCCACTATGC,TAGAACAGGCTCCTCTAG
```

The {{% csv %}} file is divided into two sections. The first section consists of lines beginning with `@param` in the first cell. These lines specify the parameters used to match the primers and tags to the sequence. The second section provides a description of all the samples (PCRs) included in the sequencing library. This section begins with a line containing the names of the columns used to describe the samples in the subsequent lines. Only the second section is required.

#### Basic format and required columns

Below is an example for the minimal description of the PCRs multiplexed in the
sequencing library. In the new version of {{% obitools4 %}} this file is a {{% csv %}} file.

The first line is mandatory and must contain at least the five column names presented below:
{#five-columns}

- `experiment`: the name of the experiment that allows for grouping of samples;
- `sample`: the sample (PCR) name;
- `sample_tag`: the tag identifying the sample:
  
  Each sample tag must be unique within the library for each pair of primers. They can be 
  provided in upper or lower case. No distinction is made between the two.
  
  + They can be a simple DNA word as here. This means that the same tag is used
    for both forward and reverse primers (eg: `aattaac`).
  + It can be two DNA words separated by a colon. For example, `aagtag:gaagtag`.
    This means that the first tag is used for the forward primer and the second for the
    reverse primers. 
    
    > [!NOTE] The example presented above :`aattaac` is equivalent to `aattaac:aattaac`.

  + In the two-word syntax, if a forward or reverse primer is not tagged, the tag
    is replaced by a hyphen. For example, `aagtag:-` or `-:aagtag`. Consequently, an
    experiments conducted without primer tags must declare a dummy tag: `-:-`.

  > [!CAUTION] For a given primer, all tags must be the same length. However, the tags of a primer pair (i.e. the forward and reverse primers) can be different lengths.

- forward_primer: the forward primer sequence
- reverse_primer: the reverse primer sequence

#### The simplest `obimultiplex` command

{{< code "samples_simple.csv" csv true >}}


{{< code "wolf_4seq.fastq" fastq true >}}

```bash
obimultiplex -s samples_simple.csv \
             wolf_4seq.fastq \
             > wolf_4seq_simple.fastq
``` 

{{< code "wolf_4seq_simple.fastq" fastq true >}}

#### Annotations provided by the `obimultiplex` command

{{% obitools %}} annotates its output to enable quality checks on ongoing tasks. {{% obi obimultiplex %}} is adding the following annotations:

- Sample description
  
  Each read is attached to a sample (PCR) according to the sample description file. This involves adding two pieces of information to the read: the sample ID and the experiment ID (*i.e.* a group of samples).

  - `experiment`: "wolf_diet"
  
    The experiment name imputed to the barcode sequence

  - `sample`: "13a_F730603"
  
    The sample (PCR) name imputed to the barcode sequence

- Amplicon description

  The second task of {{% obi obimultiplex %}} is to extract the amplified barcode sequence from the read. A read sequence can contain the sequence of a single amplicon or several, depending on the sequencing library preparation protocol.  For each read, {{% obi obimultiplex %}} produces one sequence per amplicon as output. This sequence is annotated by a set of tags that describe the properties of the barcode in question. 
  
  - `obimultiplex_amplicon_rank`: "1/1"
    
    {{% obi obimultiplex %}} is able to detect concatemer of several amplicons. This information
    is reported in the `obimultiplex_amplicon_rank` as a ratio here "1/1" meaning the first among one in the read. A value of "2/3" would mean the second amplicon detected among three in the read.

  - `obimultiplex_direction`: "reverse"
  
    The direction in which the amplicon has been detected:

    - **forward** means, the forward primer has been identified, then the reverse complementary sequence of the reverse primer.

    - **reverse** means, the reverse primer has been identified, then the forward complementary sequence of the forward primer. The sequence of the barcode has been reverse complemented to be always reported as a sequence oriented from the forward to the reverse primer.
  
- Primer matching

  The primer matching algorithm can identify primer sequences in the reads despite sequencing errors. The threshold for matching primers can be configured either through command line options or by setting parameters in the sample description file.

  - Forward primer:
  
    - `obimultiplex_forward_primer`: "ttagataccccactatgc"
      
      The true forward primer sequence as provided in the {{% obi obimultiplex %}} sample description file.

    - `obimultiplex_forward_match`: "ttagataccccactatgc"
  
      The primer sequence as detected in the sequence read.

    - `obimultiplex_forward_error`: 0

      The number of differences between the `obimultiplex_forward_primer` and the `obimultiplex_forward_match` is equal to the value of `obimultiplex_forward_error`. {{% obi obimultiplex %}} by default
      allows up to two mismatches. That threshold can be changed using the **--allowed-mismatches** option (or **-e** for the short version option). 

  - Reverse primer:
    - `obimultiplex_reverse_primer`:"tagaacaggctcctctag"

      The true reverse primer sequence as provided in the {{% obi obimultiplex %}} sample description file.

    - `obimultiplex_reverse_match`:"tagaacaggctcgtctag"

      The primer sequence as detected in the sequence read.

    - `obimultiplex_reverse_error`:1

      Here one mismatch has been detected between the primer sequence and the read sequence match.

- Tag identification

  As for the primers, {{% obi obimultiplex %}} can account for sequencing errors in the portion of the reads that corresponds to the tag used to discriminate between samples. This allows some amplicons to be rescued, enabling the identification of the correct sample despite sequencing errors. This is particularly important when relatively high-error-rate sequencers are used, such as Nanopore sequencing.

  The same type of information is stored for both the forward and reverse tags. This includes information on the algorithm used to match the tag, the sequence identified on the read, the actual tag sequence proposed for association with the observation, and the number of differences between the observation and the proposal.

  The tag matching algorithm and its parameters can be configured in the {{% obi obimultiplex %}} sample description file. 

  - Forward tag:
    - "obimultiplex_forward_tag":"gcctcct"

      The observed sequence tag associated with the forward primer.

    - "obimultiplex_forward_proposed_tag":"gcctcct"

      The actual tag inferred by the matching algorithm.

    - `obimultiplex_forward_matching`: "strict"

      The algorithm used to match the tag on the sequence read. Possible values are:

      + `strict` : no sequencing error allowed in the sequence tag,
      + `hamming`: only substitutions are allowed,
      + `indel`: insertions/deletions are accepted in the sequence tag.
       
    - `obimultiplex_forward_tag_dist`: 0

      The number of differences between the observed and proposed sequence tag. When the algorithm is `strict`, this attribute is always 0.
      
  - Reverse tag:
    - `obimultiplex_reverse_tag`: "gcctcct"

      The observed sequence tag associated with the reverse primer.

    - `obimultiplex_reverse_proposed_tag`: "gcctcct"

      The actual tag inferred by the matching algorithm.

    - `obimultiplex_reverse_matching`: "strict"

      The algorithm used to match the tag on the sequence read. 

    - `obimultiplex_reverse_tag_dist`: 0

      The number of differences between the observed and proposed sequence tag.


#### Adding supplementary columns to the sample description

In addition to the [five required columns](#five-columns), as many columns as needed can be added to each sample description line. In the next example, four columns have been added to the sample description file:

- **sex**,
- **age**, 
- **plate**,
- **position**

This information will be added to each amplicon assigned to a sample. 

{{< code "samples_extra.csv" csv true >}}

```bash
obimultiplex -s samples_extra.csv \
             wolf_4seq.fastq \
             > wolf_4seq_extra.fastq
``` 

{{< code "wolf_4seq_extra.fastq" fastq true >}}

#### Tuning the primer and tag matching

Optimising primer matching and tag identification can increase the yield of recognised amplicons. However, this must be balanced against the risk of erroneous barcodes being extracted and/or assigned to the wrong sample if the parameters are set too loosely.

##### Changing primer matching parameters

Two parameters are available to tune the matching of primers:

- The number of differences allowed between the primer and the read sequence,
- The nature of the differences:
  - Only mismatches are allowed (default), 
  - mismatches and insertions/deletions (indels) are permitted.

These two parameters can be set using options on the {{% obi obimultiplex %}} command line, or by setting parameters in the sample description file using `@param` lines at the beginning of the file.

###### Changing the nature of the differences

By default only mismatches are allowed as differences between the primer sequence and the read sequence. This is perfectly suited for the [Illumina](https://www.illumina.com/) or [Aviti](https://www.elementbiosciences.com/products/aviti) sequencers. 

With [Oxford Nanopore](https://nanoporetech.com/) sequencers, it is better to allow indels in addition to mismatches, as indels represent half of the sequencing errors produced by these machines. 

Allowing indels can be done by adding the `--with-indels` option to the {{% obi obimultiplex %}} command. 

```bash
obimultiplex -s samples_simple.csv \
             --with-indels \
             wolf_4seq.fastq \
             > wolf_4seq_simple.fastq
``` 

It can also be set using the `@param,indels` line in the sample description file.

```csv
@param,indels,false
````

```csv
@param,indels,true
```

Here a modified version of the sample description file including the `@param,indels,true` line.

{{< code "samples_with_indels.csv" csv true >}}

If such file is used, no need to add the `--with-indel` option to the {{% obi obimultiplex %}} command.


```bash
obimultiplex -s samples_with_indels.csv \
             wolf_4seq.fastq \
             > wolf_4seq_with_indels.fastq
``` 

{{< code "wolf_4seq_with_indels.fastq" fastq true >}}

It can be noted that on our four sequences example, the `@param,indels,true` allows for retrieving an amplicon also from the fourth sequence.

A different mode can be allowed for the forward and reverse primers by setting the `@param,forward_indels` and `@param,reverse_indels` parameters. 

```csv
@param,forward_indels,true
@param,reverse_indels,false
```

It is even possible to be more precise by defining the `indel` mode for each primer by setting the `@param,indels` parameter with the sequence of the primer targeted:

```csv
@param,primer_indels,TTAGATACCCCACTATGC,true
@param,primer_indels,TAGAACAGGCTCCTCTAG,false
```

###### Setting the maximum number of mismatches allowed 

The maximum number of mismatches allowed is set using the `--allowed-mismatches` option in its long format or `-e` in its short format. The default value for this option is two. This number of mismatches is per primer. It can also be set adding the `@param,primer_mismatches` parameter in the sample description file. 

```csv
@param,primer_mismatches,4
```

This sets the maximum number of differences allowed for each primer to four. If indels are permitted, each insertion/deletion accounts as one difference, as a mismatch.

A different number of differences can be allowed for the forward and reverse primers by setting the `@param,forward_mismatches` and `@param,reverse_mismatches` parameters. 

```csv
@param,forward_mismatches,4
@param,reverse_mismatches,2
```

It is even possible to be more precise by defining a different number of mismatches for each primer by setting the `@param,primer_mismatches` parameter with the sequence of the primer targeted:

```csv
@param,primer_mismatches,TTAGATACCCCACTATGC,4
@param,primer_mismatches,TAGAACAGGCTCCTCTAG,2
```

##### Changing tag matching parameters

There are more parameters for tag matching than for primer matching. They can only be changed by parametrizing them in the '@param' section of the sample description file. These parameters have no corresponding option available on the {{% obi obimultiplex %}} command. 

###### The tag matching algorithms

There are three matching algorithms:

* `strict`: the primers are matched exactly, no differences are allowed. This is the default.
* `hamming`: only mismatching bases are allowed. 
* `indel`: insertions/deletions are accepted in addition to mismatches.

Each matcher returns a distance between the tag present in the sample description file and the observed tag on the sequence read. The closest tag is assumed to be the correct one. If two true tags are at the same closest distance to the observed one, the tag is considered as not identified and the corresponding amplicon will not be assigned to a sample.

```csv 
@param,matching,hamming
```

The parameter usable to specify the matching algorithm for the forward and reverse primers disctinctively is `@param,forward_matching`, and `@param,reverse_matching`.

```csv
@param,forward_matching,hamming
@param,reverse_matching,indel
```

It is also possible to specify a tag matching algorithm for a specific primer by writing a `@param,matching` parameter with the targeted primer sequence.

```csv 
@param,matching,TTAGATACCCCACTATGC,hamming
@param,matching,TAGAACAGGCTCCTCTAG,strict
```

###### Specifying the spacer length between the primers and the sequence tag

Most of the time, the tag sequences stick straight onto the 5' end of the primer sequence.

**age**
```
5'-TAG-PRIMER->3'
```

This property is used to extract the tag sequence once the primer has been located on the read. 
It is possible to indicate that some bases have been added in between the tag and the primer sequence.

```
5'-TAG-SPACER-PRIMER->3'
```

It is important to indicate the length of this spacer to the {{% obi obimultiplex %}} command to allow it to correctly extract the tag sequence. As for the previously described parameters, this spacer length can be specified globally for the forward and reverse primers, or for any primer individually.

To specify globally you can use the `@param,spacer` parametter

```csv
@param,spacer,2
```

The forward, reverse version of the parameter is

```csv
@param,forward_spacer,2
@param,reverse_spacer,3
```

To specify the spacer length individually for a given primer, you can use:

```csv
@param,spacer,TTAGATACCCCACTATGC,2
@param,spacer,TAGAACAGGCTCCTCTAG,4
```

##### Tag specially designed to allow matching with indels

Matching tag when allowing indels is not trivial as we cannot know at first which exact length will have the observed version of the tag on the sequence read. Because tags are very short sequences (a few nucleotides) it is almost impossible to distinguish between a mismatch and an insertion/deletion in terms of sequence alignment.

To delimitate the tag and allows a robust alignment that accounts for insertion/deletion a strategy is to design tag using only three of the four nucleotides (*e.g.* `A`,`C`,`T` but not `G`) and to flank the tag on each side by at least two of the missing nucleotide (*e.g.* `GGACTTCAGG` for the tag `ACTTCA` not containing any `G`).

To indicate such tagging strategy, the sample description file has to be parametrised as following:

```csv
# Indicates the tag matching strategy
@param,matching,indel
# Indicates to use the nucleotide G as tag delimiter
@param,tag_delimiter,G
# The tag used (not containing any G) is indicated without the flanking G
experiment,sample,sample_tag,forward_primer,reverse_primer
wolf_diet,13a_F730603,aattaac,TTAGATACCCCACTATGC,TAGAACAGGCTCCTCTAG
```

As for the above parameters, versions of the parameter exist for specifying differently the forward and reverse properties.

```csv
@param,forward_tag_delimiter,G
@param,reverse_tag_delimiter,T
```

And it is also possible to specify the tag delimiter for a given primer.

```csv
@param,tag_delimiter,TTAGATACCCCACTATGC,G
```

### Understanding why some amplicons are not assigned to a sample

The {{% obi obimultiplex %}} can reject some reads because it is unable to identify any amplicon. It can also reject some detected amplicon because it is not able to assign it to a sample. In these cases, the corresponding sequences are not included in the result file. The problematic sequences can be stored separately in another file whose name is specified by the `--unidentified` or `-u` option. 

```bash
obimultiplex -s samples_simple.csv \
             -u wolf_4seq_bad.fastq \
             wolf_4seq.fastq \
             > wolf_4seq_simple.fastq
``` 

The resulting file containing the demultiplexed amplicons

{{< code "wolf_4seq_simple.fastq" fastq true >}}

The file containing the rejected sequences

{{< code "wolf_4seq_bad.fastq" fastq true >}}

In the latest file, the rejected sequences are annotated with a `obimultiplex_error` tag indicating the reason why the amplicon was discarded.

It is for example possible to make some statistics about the rejection causes:

```bash
obicsv -k obimultiplex_error  \
       wolf_4seq_bad.fastq \
  | csvsql --query 'select obimultiplex_error, 
                           count(*) as n 
                    from errors 
                    group by obimultiplex_error' \
         --tables errors \
         -d ',' \
  | csvlook --no-inference
```
```
| obimultiplex_error    | n |
| --------------------- | - |
| No barcode identified | 1 |
```

In this trivial example with a single rejected sequence you obtain only a single reason `No barcode identified` occurring only a single time.

## Synopsis

```bash
obimultiplex [--allowed-mismatches|-e <int>] [--batch-size <int>]
             [--compress|-Z] [--debug] [--ecopcr] [--embl] [--fasta]
             [--fasta-output] [--fastq] [--fastq-output] [--force-one-cpu]
             [--genbank] [--help|-h|-?] [--input-OBI-header]
             [--input-json-header] [--json-output] [--keep-errors]
             [--max-cpu <int>] [--no-order] [--no-progressbar]
             [--out|-o <FILENAME>] [--output-OBI-header|-O]
             [--output-json-header] [--paired-with <FILENAME>] [--pprof]
             [--pprof-goroutine <int>] [--pprof-mutex <int>] [--skip-empty]
             [--solexa] [--tag-list|-s <string>] [--taxonomy|-t <string>]
             [--template] [--unidentified|-u <string>] [--version]
             [--with-indels] [<args>]
```

## Options

#### {{< obi obimultiplex >}} specific options

- {{< cmd-options/demultiplexing/allowed-mismatches >}}
- {{< cmd-options/demultiplexing/keep-errors >}}
- {{< cmd-options/paired-with >}}
- {{< cmd-options/demultiplexing/tag-list >}}
- {{< cmd-options/demultiplexing/template >}}
- {{< cmd-options/demultiplexing/unidentified >}}
- {{< cmd-options/demultiplexing/with-indels >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obimultiplex --help
```
