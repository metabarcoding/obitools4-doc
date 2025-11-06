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

The first line is mandatory and must contains at least the five column names presented below:

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

  > [!CAUTION] For a given primer all the tags must have the same length.

- forward_primer: the forward primer sequence
- reverse_primer: the reverse primer sequence

{{< code "samples_simple.csv" csv true >}}


{{< code "wolf_4seq.fastq" fastq true >}}

```bash
obimultiplex -s samples_simple.csv \
             wolf_4seq.fastq \
             > wolf_4seq_simple.fastq
``` 

{{< code "wolf_4seq_simple.fastq" fastq true >}}

- Sample description
  
  - `experiment`: "wolf_diet"
  
    The experiment name imputed to the barcode sequence

  - `sample`: "13a_F730603"
  
    The sample (PCR) name imputed to the barcode sequence

- Amplicon description
  
  - `obimultiplex_amplicon_rank`: "1/1"
    
    {{% obi obimultiplex %}} is able to detect concatemer of several amplicons. This information
    is reported in the `obimultiplex_amplicon_rank` as a ratio here "1/1" meaning the first among one in the read. A value of "2/3" would mean the second amplicon detected among three in the read.

  - `obimultiplex_direction`: "reverse"
  
    The direction in which the amplicon has been detected:

    - "forward" means, the forward primer has been identified, then the reverse complementary sequence of the reverse primer.

    - "reverse" means, the reverse primer has been identified, then the forward complementary sequence of the forward primer. The sequence of the barcode has been reverse complemented to be always reported as a sequence oriented from the forward to the reverse primer.
  
- Primer matching
  
  - Forward primer:
  
    - `obimultiplex_forward_primer`: "ttagataccccactatgc"
      
      The true forward primer sequence as provided in the {{% obi obimultiplex %}} sample description file.

    - `obimultiplex_forward_match`: "ttagataccccactatgc"
  
      The primer sequence as detected in the sequence read.

    - `obimultiplex_forward_error`: 0

      The number of differences between the `obimultiplex_forward_primer` and the `obimultiplex_forward_match` attribute values. {{% obi obimultiplex %}} by default
      allows up to two mismatches. That threshold can be changed using the **--allowed-mismatches** option (or **-e** for the short version option). 

  - Reverse primer:
    - "obimultiplex_reverse_primer":"tagaacaggctcctctag"

      The true reverse primer sequence as provided in the {{% obi obimultiplex %}} sample description file.

    - "obimultiplex_reverse_match":"tagaacaggctcgtctag"

      The primer sequence as detected in the sequence read.

    - "obimultiplex_reverse_error":1

      Here one mismatch has been detected between the primer sequence and the read sequence match.

- Tag identification
  - Forward tag:
    - "obimultiplex_forward_tag":"gcctcct"
    - "obimultiplex_forward_proposed_tag":"gcctcct"
    - "obimultiplex_forward_matching":"strict"
    - "obimultiplex_forward_tag_dist":0
  - Reverse tag:
    - "obimultiplex_reverse_tag":"gcctcct"
    - "obimultiplex_reverse_proposed_tag":"gcctcct"
    - "obimultiplex_reverse_matching":"strict"
    - "obimultiplex_reverse_tag_dist":0

#### Supplementary columns

{{< code "samples_extra.csv" csv true >}}

```bash
obimultiplex -s samples_extra.csv \
             wolf_4seq.fastq \
             > wolf_4seq_extra.fastq
``` 

{{< code "wolf_4seq_extra.fastq" fastq true >}}


```bash
obimultiplex -s samples_simple.csv \
             -u wolf_4seq_bad.fastq \
             wolf_4seq.fastq \
             > wolf_4seq_simple.fastq
``` 
{{< code "wolf_4seq_bad.fastq" fastq true >}}


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
