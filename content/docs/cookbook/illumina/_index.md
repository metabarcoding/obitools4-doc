---
title: "Analysing an Illumina data set"
weight: 1
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# The wolf diet tutorial

Here is a short tutorial for analyzing metabarcoding data, on an Illumina dataset from a wolf diet study, using the OBITools 4 and basic unix commands.
It presents the following analysis steps:

1. Assembly of forward and reverse reads
2. Suppression of unaligned sequence records
3. Sequence demultiplexing
4. Dereplication of sequences
5. Dataset denoising
6. Taxonomic assignation of the sequences
7. Generate the contingency table of results

## The dataset to analyze and the reference database

The data used in this tutorial corresponds to the analysis of four wolf scats
using the protocol published in @Shehzad2012-pn for carnivore diet assessment.
After extraction of DNA from feces, DNA amplification was performed using the
primers `TTAGATACCCCACTATGC` and `TAGAACAGGCTCCTCTAG` amplifying the *12S-V5*
region [@Riaz2011-gn], together with a wolf blocking oligonucleotide.

An archive containing all the files needed for the analysis can be downloaded by clicking here: [wolf_diet_dataset](wolf_diet_dataset.tgz) 

The downloaded archive can be unarchived using the following unix command:

```bash
tar zxvf wolf_diet_dataset.tgz
```

It creates a `wolf_data` directory with the following data files:

- Two {{% fastq %}} files resulting from the aGA IIx (Illumina) paired-end (2 x 108 bp) sequencing of DNA extracted and amplified from four wolf feces:
    - [`wolf_F.fastq`](wolf_data/wolf_F.fastq) with the forward sequences
    - [`wolf_R.fastq`](wolf_data/wolf_R.fastq) with the reverse sequences

- A tabulated file for sample demultiplexing, named [`wolf_diet_ngsfilter.csv`](wolf_data/wolf_diet_ngsfilter.csv), with primer and tag sequences for each sample.
The tags correspond to short and specific sequences added to the 5\' end of each primer to distinguish the different samples.

- The reference database in {{% fasta %}} format named
  [`db_v05_r117.fasta.gz`](wolf_data/db_v05_r117.fasta.gz), which has been
  extracted from the from EMBL release 117 (see "build a reference database"
  documentation for details)

We recommend creating a new folder for the results, to separate them from the raw data:

```bash
mkdir results
```

## Recover full length sequences from forward and reverse reads

When using the result of a paired-end sequencing with supposedly overlapping forward and reverse reads,
the first step is to recover the assembled sequence.

Forward and reverse reads of the same fragment are located at the same line position in both fastqs files.
Based on these two files, the assembly of the forward and reverse reads is performed using the {{% obi obipairing %}} 
program, which aligns the two reads and returns the reconstructed sequence:

```bash
obipairing --min-identity=0.8 \
           --min-overlap=10 \
           -F wolf_data/wolf_F.fastq \
           -R wolf_data/wolf_R.fastq \
           > results/wolf.fastq 
```

The `--min-identity` and `--min-overlap` options allow to discard sequences with low alignment quality:
overlapping reads with less than 10 base pairs, or alignment with less than 80% similarity (identity)
produce a concatenated sequence of the two reads, with an attribute `"mode":"join"`.
Other reads that assemble well together produce sequences with the attribute `"mode":"alignment"`.
For more information, please refer to the program {{% obi obipairing %}}.

## Remove unaligned sequence records

Unaligned sequences, with an attribute `"mode":"join"`, cannot be used. They are removed from the dataset:

```bash
obigrep -p 'annotations.mode != "join"' \
        results/wolf.fastq > results/wolf_assembled.fastq
```

The `-p` requires a go like expression, `annotations.mode != "join"` means that
if the value of the `mode` annotation of a sequence is different from `join`,
the corresponding sequence record will be kept.

The first sequence record of `wolf_assembled.fastq` can be obtained by the command:

```bash
head -n 4 results/wolf_assembled.fastq
```
```
@HELIUM_000100422_612GNAAXX:7:108:5640:3823#0/1 {"ali_dir":"left","ali_length":62,"mode":"alignment","pairing_fast_count":53,"pairing_fast_overlap":62,"pairing_fast_score":0.898,"pairing_mismatches":{"(T:26)->(G:13)":62,"(T:34)->(G:18)":48},"score":1826,"score_norm":0.968,"seq_a_single":46,"seq_ab_match":60,"seq_b_single":46}
ccgcctcctttagataccccactatgcttagccctaaacacaagtaattaatataacaaaattgttcgccagagtactaccggcaatagcttaaaactcaaaggacttggcggtgctttatacccttctagaggagcctgttctaaggaggcgg
+
CCCCCCCBCCCCCCCCCCCCCCCCCCCCCCBCCCCCBCCCCCCC<CcDccbe[`F`accXV=TA\RYU\\ee_e[XZ[XEEEEEEEEEE?EEEEEEEEEEDEEEEEEECCCCCCCCCCCCCCCCCCCCCCCACCCCCACCCCCCCCCCCCCCCC
```

## Assign each sequence record to the corresponding sample and marker combination

Each sequence record is assigned to its corresponding sample and marker using the data provided in the file [`wolf_diet_ngsfilter.csv`](wolf_data/wolf_diet_ngsfilter.csv).
This file follows the required format for {{% obi obimultiplex %}} program.

{{< code "wolf_data/wolf_diet_ngsfilter.csv" csv true >}}

The minimal file is a {{% csv %}} containing at least these five columns.
The order of the column is not mandatory.

- **experiment**: the name of the experiment (several experiments can be
  included in the same file)
- **sample**: the name of the sample (PCR)
- **sample_tag**: the tags (*e.g.* `aattaac` if a same tag has been used on each
  extremity of the PCR products, or `aattaac:gaagtag` if two different tags were
  used)
- **forward_primer**: the sequence of the forward primer
- **reverse_primer**: the sequence of the reverse primer

Some extra lines can be added in front. They start with the `@param` value.
Here three parameters are set. 

- `@param,matching,strict`: The tags are match strictly without allowing any mismatches.
- `@param,primer_mismatches,2`: The primers are matched allowing for two diferences
- `@param,indels,false`: Theses differences cannot be insertions or deletions (only mismatches)  
  
see {{% obi obimultiplex %}} for details.

```bash
obimultiplex -s wolf_data/wolf_diet_ngsfilter.csv \
             -u results/unidentified.fastq \
             results/wolf_assembled.fastq \
             > results/wolf_assembled_assigned.fastq
```

This command creates two files:

-   [`unidentified.fastq`](results/unidentified.fastq) with the sequences that
    failed to be assigned to a sample/marker combination
-   [`wolf_assembled_assigned.fastq`](results/wolf_assembled_assigned.fastq)
    with the sequence records that were properly assigned to a sample/marker
    combination

Note that each sequence record of the
[`wolf_assembled_assigned.fastq`](results/wolf_assembled_assigned.fastq) file
contains only the barcode sequence as the sequences of primers and tags are
removed by the {{% obi obimultiplex %}} program. Information concerning the
experiment, sample, primers and tags is added as attributes in the sequence
header.

For instance, the first sequence record of [`wolf_assembled_assigned.fastq`](results/wolf_assembled_assigned.fastq) is:

```
@HELIUM_000100422_612GNAAXX:7:108:5640:3823#0/1_sub[28..127] {"ali_dir":"left","ali_length":62,"experiment":"wolf_diet","mode":"alignment","obimultiplex_amplicon_rank":"1/1","obimultiplex_direction":"forward","obimultiplex_forward_error":0,"obimultiplex_forward_match":"ttagataccccactatgc","obimultiplex_forward_matching":"strict","obimultiplex_forward_primer":"ttagataccccactatgc","obimultiplex_forward_proposed_tag":"gcctcct","obimultiplex_forward_tag":"gcctcct","obimultiplex_forward_tag_dist":0,"obimultiplex_reverse_error":0,"obimultiplex_reverse_match":"tagaacaggctcctctag","obimultiplex_reverse_matching":"strict","obimultiplex_reverse_primer":"tagaacaggctcctctag","obimultiplex_reverse_proposed_tag":"gcctcct","obimultiplex_reverse_tag":"gcctcct","obimultiplex_reverse_tag_dist":0,"pairing_mismatches":{"(T:26)->(G:13)":35,"(T:34)->(G:18)":21},"paring_fast_count":53,"paring_fast_overlap":62,"paring_fast_score":0.898,"sample":"29a_F260619","score":1826,"score_norm":0.968,"seq_a_single":46,"seq_ab_match":60,"seq_b_single":46}
ttagccctaaacacaagtaattaatataacaaaattgttcgccagagtactaccggcaatagcttaaaactcaaaggacttggcggtgctttataccctt
+
CCCBCCCCCBCCCCCCC<CcDccbe[`F`accXV=TA\RYU\\ee_e[XZ[XEEEEEEEEEE?EEEEEEEEEEDEEEEEEECCCCCCCCCCCCCCCCCCC
```

## Dereplicate the sequences 

Since in a DNA metabarcoding experiment it is expected that the same DNA
sequence will be found several times, it is convenient to work with unique
*sequences* instead of *reads* to reduce both file size and computation time,
and to get more interpretable results. To dereplicate such *reads* into unique
*sequences*, we use the {{< obi obiuniq >}} command.

All reads in the dataset are compared in pairs, those that are strictly
identical are grouped together, and only one copy of each sequence is kept, with
frequency information in the `count` attribute.

In the command below, we use the {{% obi obiuniq %}} command with the `-m
sample` option to keep the original sample information for each unique sequence.
It will return a {{% fasta %}} file.

```bash
obiuniq -m sample \
        results/wolf_assembled_assigned.fastq \
        > results/wolf_assembled_assigned_uniq.fasta
```

The first sequence record of [`wolf_assembled_assigned_uniq.fasta`](results/wolf_assembled_assigned_uniq.fasta) is:

```
>HELIUM_000100422_612GNAAXX:7:99:12017:19418#0/1_sub[28..127] {"ali_dir":"left","ali_length":62,"count":1,"experiment":"wolf_diet","merged_sample":{"29a_F260619":1},"mode":"alignment","obimultiplex_amplicon_rank":"1/1","obimultiplex_direction":"forward","obimultiplex_forward_error":0,"obimultiplex_forward_match":"ttagataccccactatgc","obimultiplex_forward_matching":"strict","obimultiplex_forward_primer":"ttagataccccactatgc","obimultiplex_forward_proposed_tag":"gcctcct","obimultiplex_forward_tag":"gcctcct","obimultiplex_forward_tag_dist":0,"obimultiplex_reverse_error":0,"obimultiplex_reverse_match":"tagaacaggctcctctag","obimultiplex_reverse_matching":"strict","obimultiplex_reverse_primer":"tagaacaggctcctctag","obimultiplex_reverse_proposed_tag":"gcctcct","obimultiplex_reverse_tag":"gcctcct","obimultiplex_reverse_tag_dist":0,"pairing_mismatches":{"(A:02)->(C:07)":54,"(A:02)->(G:17)":59,"(C:02)->(G:10)":42},"paring_fast_count":43,"paring_fast_overlap":62,"paring_fast_score":0.729,"sample":"29a_F260619","score":567,"score_norm":0.935,"seq_a_single":46,"seq_ab_match":58,"seq_b_single":46}
ttagccctaaacacaagtaattaatataacaaaattattcggcagagtactaccggcagt
agcttaaaactcaaaggacttggcggtgctttatacccct
```

The `obiuniq` command has added two `key:value` entries in the sequences attributes:

-   `"merged_sample":{"29a_F260619":1}`: this sequence has been found once in a single sample called "29a_F260619"
-   `"count":1` : the total count for this sequence is 1

To keep only these two attributes, we can use the {{% obi obiannotate %}} command:

```bash
obiannotate -k count -k merged_sample \
  results/wolf_assembled_assigned_uniq.fasta \
  > results/wolf_assembled_assigned_simple.fasta
```

The first five sequence records of [`wolf_assembled_assigned_simple.fasta`](results/wolf_assembled_assigned_simple.fasta) become:

```
>HELIUM_000100422_612GNAAXX:7:99:12017:19418#0/1_sub[28..127] {"count":1,"merged_sample":{"29a_F260619":1}}
ttagccctaaacacaagtaattaatataacaaaattattcggcagagtactaccggcagt
agcttaaaactcaaaggacttggcggtgctttatacccct
>HELIUM_000100422_612GNAAXX:7:56:19300:10949#0/1_sub[28..127] {"count":37,"merged_sample":{"29a_F260619":37}}
ttagccctaaacacaagtaattaatataacaaaattgttcaccagagtactagcggcaac
agcttaaaactcaaaggacttggcggtgctttataccctt
>HELIUM_000100422_612GNAAXX:7:117:10934:7472#0/1_sub[28..127] {"count":1,"merged_sample":{"29a_F260619":1}}
ttagccctaaacacaagtaattattataacaaaattattcgccagagtactaccggcaat
agcttaaaactcaaaggacttggcggtgctttatacccgt
>HELIUM_000100422_612GNAAXX:7:28:9432:2506#0/1_sub[28..127] {"count":4,"merged_sample":{"13a_F730603":4}}
ccagccttaaacacaaatagttatgcaaacaaaactattcgccagagtactaccggcaat
agcttaaaactcaaaggacttggcggtgctttataccctt
>HELIUM_000100422_612GNAAXX:7:94:11447:14902#0/1_sub[28..127] {"count":1,"merged_sample":{"15a_F730814":1}}
ttagccctaaacacaagtaattagtataacaaaattattccccagagtactaccggcaat
agcttaaaactcaaaggacttggcggtgctttataccctt
```

## Denoise the sequence dataset

To have a set of sequences assigned to their corresponding samples does
not mean that all sequences are *biologically* meaningful, *i.e.* some of
these sequences can contain PCR and/or sequencing errors, or chimeras.

#### Tag the sequences for PCR errors (sequence variants) {.unnumbered}

The {{% obi obiclean %}} program tags sequence variants as potential error generated during
PCR amplification. We ask it to keep the cluster-head sequences (`-H` option) that are sequences which
are not variants of another sequence with a count greater than 5% of their own count
(`-r 0.05` option). See the {{% obi obiclean %}} documentation for details.

```bash
obiclean -s sample -r 0.05 --detect-chimera -H \
         results/wolf_assembled_assigned_simple.fasta \
         > results/wolf_assembled_assigned_simple_clean.fasta
```

One of the sequence records of [`wolf_assembled_assigned_simple_clean.fasta`](results/wolf_assembled_assigned_simple_clean.fasta) is:

```
>HELIUM_000100422_612GNAAXX:7:3:3008:16359#0/1_sub[28..127] {"count":1,"merged_sample":{"29a_F260619":1},"obiclean_head":true,"obiclean_headcount":0,"obiclean_internalcount":0,"obiclean_samplecount":1,"obiclean_singletoncount":1,"obiclean_status":{"29a_F260619":"s"},"obiclean_weight":{"29a_F260619":1}}
ttagccctaaacacaagtaattaatataacaaaattattcgacagagtaccaccggcaat
agcttaaaactcaaaggacttggcggtgctttataccctt
```

#### Get some statistics about the sequence counts 

After every filtering step, it is good to have an overview on its effects. The
basic statistics can be obtained with {{< obi obicount >}} command, which
provides counts for variants (unique sequence variants), reads (sequence
occurrences) and symbols (total number of nucleotides). The output is a CSV file
with two columns: the first one being the type of entity/statistic and the
second one its count.

```bash
obicount results/wolf_assembled_assigned_simple_clean.fasta
```
```
entities,n
variants,715
reads,33762
symbols,70775
```

The result is returned in a CSV format, which can be easily read by many tools. For
example, you could use the `csvlook` command-line tool from the csvkit package to pretty-print it:

```bash
obicount results/wolf_assembled_assigned_simple_clean.fasta \
        | csvlook
```
```
| entities |      n |
| -------- | ------ |
| variants |    715 |
| reads    | 33 762 |
| symbols  | 70 775 |
```

The data set contains 715 sequence variants corresponding to 33762 sequence
reads. Most of the variants occur only once in the whole data set and are
usually named *singletons*, let us see how many singletons there are:

```bash
obigrep -p 'sequence.Count() == 1' \
        results/wolf_assembled_assigned_simple_clean.fasta |\
        obicount | csvlook
```
```
| entities |      n |
| -------- | ------ |
| variants |    604 |
| reads    |    604 |
| symbols  | 60 101 |
```

To understand the {{< obi obigrep >}} command, you need to know about the `-p`
option. This option allows you to specify a predicate function to be applied to
each sequence in the data set. If the function returns `True`, the sequence is
included in the output; if it returns `False`, it's excluded. In this case, we
use a predicate that checks whether the count of sequences (which is what
`sequence.Count()` gives us) is equal to 1. In our data set, there are 649
singletons (or variants). These singleton sequences are more likely to be errors
than true sequences. It is generally accepted to discard them. The {{< obi obigrep >}} 
command keeps only sequences that occur at least twice in the data set.

```bash
obigrep -c 2 \
        results/wolf_assembled_assigned_simple_clean.fasta \
        > results/wolf_assembled_no_singleton.fasta
```

To get some insight into the distribution of the sequence among the samples, we
can use {{< obi obisummary >}}. This command will provide a summary of the data
set including the number of sequence reads, sequence variants and singleton
occurring in each sample. Here singleton has to be interpreted as sequence
variants occurring a single time in the sample.

```bash
obisummary --yaml results/wolf_assembled_no_singleton.fasta
```
```yaml
annotations:
    keys:
        map:
            merged_sample: 111
            obiclean_mutation: 5
            obiclean_status: 111
            obiclean_weight: 111
        scalar:
            count: 111
            obiclean_head: 111
            obiclean_headcount: 111
            obiclean_internalcount: 111
            obiclean_samplecount: 111
            obiclean_singletoncount: 111
    map_attributes: 4
    scalar_attributes: 6
    vector_attributes: 0
count:
    reads: 33158
    total_length: 10674
    variants: 111
samples:
    sample_count: 4
    sample_stats:
        13a_F730603:
            obiclean_bad: 0
            reads: 7318
            singletons: 1
            variants: 22
        15a_F730814:
            obiclean_bad: 0
            reads: 7503
            singletons: 5
            variants: 18
        26a_F040644:
            obiclean_bad: 0
            reads: 10963
            singletons: 1
            variants: 49
        29a_F260619:
            obiclean_bad: 0
            reads: 7374
            singletons: 7
            variants: 36
```

For example, for the sample *29a_F260619*, *7374* reads were obtained,
distributed over *36* sequence variants. Among them, *7* occur only once.

Considering that we are not interested in sequences that represent less than one
percent of the diet, we can filter out any sequence that occurs less than one
percent of the *7000* times in the data set, i.e. less than *70* times.

To get an idea of the effect of this filter, we can run the following command to
plot the distribution of the `count` attribute in the data set:

```bash
obicsv -k count results/wolf_assembled_no_singleton.fasta \
     | tail -n +2 \
     | sort -n \
     | uniq -c \
     | awk '{print $2,$1}' \
     | uplot -d ' ' barplot 
```
```
         ┌                                        ┐ 
       2 ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 43.0   
       3 ┤■■■■■■■■ 10.0                             
       4 ┤■■■■■■ 8.0                                
       5 ┤■■■■■■■ 9.0                               
       6 ┤■■■■ 5.0                                  
       7 ┤■■■ 4.0                                   
       8 ┤■■ 2.0                                    
       9 ┤■■ 2.0                                    
      10 ┤■■ 2.0                                    
      11 ┤■ 1.0                                     
      12 ┤■■ 2.0                                    
      13 ┤■■ 2.0                                    
      14 ┤■ 1.0                                     
      15 ┤■ 1.0                                     
      16 ┤■ 1.0                                     
      17 ┤■ 1.0                                     
      19 ┤■ 1.0                                     
      20 ┤■ 1.0                                     
      22 ┤■ 1.0                                     
      26 ┤■ 1.0                                     
      37 ┤■ 1.0                                     
      38 ┤■ 1.0                                     
      43 ┤■ 1.0                                     
      69 ┤■ 1.0                                     
      87 ┤■ 1.0                                     
      95 ┤■ 1.0                                     
     260 ┤■ 1.0                                     
     319 ┤■ 1.0                                     
     366 ┤■ 1.0                                     
    2007 ┤■ 1.0                                     
    7146 ┤■ 1.0                                     
   10172 ┤■ 1.0                                     
   12004 ┤■ 1.0                                     
         └                                        ┘                                  
```

The y-axis is the 'count' attribute (the number of occurrences of the sequence
in the data set), and the x-axis is the number of sequences that occur that
number of times. For example, 43 sequences occur twice in the data set.

From this distribution, we can see that with this 1% filter, we will only keep
the 9 sequence variants that occur at least 87 times in the entire data set.

```bash
obigrep -c 70 \
        results/wolf_assembled_no_singleton.fasta \
        > results/wolf_assembled_1_percent.fasta
```

```bash
obicount results/wolf_assembled_1_percent.fasta \
  | csvlook
```
```
| entities |      n |
| -------- | ------ |
| variants |      9 |
| reads    | 32 456 |
| symbols  |    800 |
```

Another criterion for filtering the sequences could be based on their length. We
know the expected length of the sequences in our data set. Therefore, we know
that sequences that are too long or too short are likely to be errors. It is
possible to plot the distribution of sequence length of the sequences in the
data set by adapting the previous command used to look at the distribution of
sequence abundance.

```bash
obiannotate --length \
            results/wolf_assembled_1_percent.fasta\
     | obicsv -k seq_length \
     | uplot -H hist -n 20
```
```
                                 seq_length
                  ┌                                        ┐ 
   [  0.0,   5.0) ┤▇▇▇▇▇▇▇▇▇ 1                               
   [  5.0,  10.0) ┤ 0                                        
   [ 10.0,  15.0) ┤ 0                                        
   [ 15.0,  20.0) ┤ 0                                        
   [ 20.0,  25.0) ┤ 0                                        
   [ 25.0,  30.0) ┤ 0                                        
   [ 30.0,  35.0) ┤ 0                                        
   [ 35.0,  40.0) ┤ 0                                        
   [ 40.0,  45.0) ┤ 0                                        
   [ 45.0,  50.0) ┤ 0                                        
   [ 50.0,  55.0) ┤ 0                                        
   [ 55.0,  60.0) ┤ 0                                        
   [ 60.0,  65.0) ┤ 0                                        
   [ 65.0,  70.0) ┤ 0                                        
   [ 70.0,  75.0) ┤ 0                                        
   [ 75.0,  80.0) ┤ 0                                        
   [ 80.0,  85.0) ┤ 0                                        
   [ 85.0,  90.0) ┤ 0                                        
   [ 90.0,  95.0) ┤ 0                                        
   [ 95.0, 100.0) ┤▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 4   
   [100.0, 105.0) ┤▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 4   
                  └                                        ┘ 
                                  Frequency
```

The metabarcode sequence should be about 100 bp long, but one sequence is very
short (<5 bp). We filter out this short sequence with {{% obi obigrep %}}:

```bash
obigrep -l 50 \
        results/wolf_assembled_1_percent.fasta \
        > results/wolf_assembled_no_short.fasta
```

To check the effectiveness of your filter command, you can check the
distribution of sequence lengths in the new file
[wolf_assembled_no_short.fasta](results/wolf_assembled_no_short.fasta):
wolf_assembled_no_short.fasta):

```bash
obiannotate --length \
            results/wolf_assembled_no_short.fasta \
     | obicsv -k seq_length \
     | uplot -H hist
```
```
                                 seq_length
                  ┌                                        ┐ 
   [ 99.0,  99.5) ┤▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 4   
   [ 99.5, 100.0) ┤ 0                                        
   [100.0, 100.5) ┤▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 4   
                  └                                        ┘ 
                                  Frequency
```

{{< code "results/wolf_assembled_no_short.fasta" fasta true >}}


## Taxonomic assignment of sequences

After denoising the data, the next step in diet analysis is to assign the
barcodes to the appropriate taxa (species, genus, etc.) to get the complete list
of taxa associated with each sample.

The taxonomic assignment of sequences requires a reference database to detect
all possible taxa identified in the samples, which is provided in this tutorial
as [`db_v05_r117.fasta.gz`](wolf_data/db_v05_r117.fasta.gz) (see the "Building a
reference database" documentation for more information on the reference
database). The taxonomic annotation is then based on a sequence comparison
between sample and reference sequences.

### Download the taxonomy

{{< obi obitag >}} needs access to the full taxonomy to compute its inferences.
The current and complete taxonomy from the NCBI is available online, it is
possible to download a copy of it with the following command:

```bash
obitaxonomy --download-ncbi --out ncbitaxo.tgz
```

The full copy of the [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy) is
now locally stored in the `ncbitaxo.tgz` file present in your current working
directory.

### Assign the sequences from the data set to a taxon

Thanks to the reference database, taxonomic assignment can be
carried out with {{% obi obitag %}}:

```bash
obitag -t ncbitaxo.tgz \
       -R wolf_data/db_v05_r117.fasta.gz \
       results/wolf_assembled_no_short.fasta \
       > results/wolf_assembled_taxo.fasta
```

The result file, containing only few sequences in this tutorial, looks like this:

{{< code "results/wolf_assembled_taxo.fasta" fasta true >}}

The {{% obi obitag %}} command adds several attributes in the sequence record header, like:

- `obitag_bestmatch:ACCESSION` where ACCESSION is the id of the sequence in
the reference database that best aligns to the query sequence
- `obitag_bestid:FLOAT` where FLOAT\*100 is the identity percent between
the best match sequence and the query sequence
- `taxid:TAXID` where TAXID is the final taxonomy ID assigned to the sequence by {{% obi obitag %}}

## Generate the contingency table of results

To reduce the file size and make it easier to analyze, we will make some
cosmetic changes to the data file, removing some useless information that {{%
obitools4 %}} inserts to explain its decisions.

{{% obi obiannotate %}} is the tool to make such changes. In the next command,
we will remove some tags inserted by {{< obi obiclean >}}.

```bash
obiannotate  --delete-tag=obiclean_head \
             --delete-tag=obiclean_headcount \
             --delete-tag=obiclean_internalcount \
             --delete-tag=obiclean_samplecount \
             --delete-tag=obiclean_singletoncount \
             results/wolf_assembled_taxo.fasta \
             > results/wolf_minimal.fasta
```

The effect of the above command can be seen below:

{{< code "results/wolf_minimal.fasta" fasta true >}}

The sequence id is very long and refers to some information that is useful for
the sequencer but useless for us, so we will change it to a more readable
format. This is done in two steps. First, we use the first {{< obi obiannotate >}} 
command to add a `seq_number` attribute that numbers the sequence from *1*
to *n*, the number of sequence variants. In the second step, we use the value of
this new attribute to create a new sequence id with a more readable format using
the `sprintf` function of the {{% obitools4 %}} expression language. The new
sequence id is a string consisting of the prefix "seq" followed by the sequence
number, padded with zeros to make it 4 characters long (e.g., seq0001, seq0002,
etc.).

```bash
obiannotate --number results/wolf_minimal.fasta \
  | obiannotate --set-id 'sprintf("seq%04d",annotations.seq_number)' \
  > results/wolf_final.fasta
```

{{< code "results/wolf_final.fasta" fasta true >}}

It is now possible to extract the useful information for our ecological analysis
from our sequence file. This will consist of two CSV files, one describing the
occurrence of each sequence variant in the different samples, and one for the
metadata describing each MOTU.

### The MOTU occurrence table

In the results file [`wolf_final.fasta`](results/wolf_final.fasta), two
attributes inform us about the distribution of MOTU abundances across samples
(PCR). The `merge_sample` attribute and the `obiclean_weight` attribute.

The `merge_sample` attribute was set by {{< obi obiuniq >}} during the initial
dereplication procedure. It contains the observed number of reads for each
sequence variant in the different samples. The `obiclean_weight` attribute is
the number of reads assigned to each sequence variant after the {{< obi obiclean >}} 
clustering step. The number of reads shown in this attribute takes into
account not only the number of reads observed for this variant, but also the
number of reads observed for the erroneous sequences clustered to this estimated
true sequence. According to {{< obi obiclean >}}, `obiclean_weight` is a better
estimate of the true sequence occurrence than the `merge_sample` attribute.

The {{< obi obimatrix >}} command creates the CSV file representing any map
attribute of a {{% obitools4 %}} sequence file. By default, it dumps the
`merge_sample` attribute, but you can specify any other map attribute. Here we
decided to use the `obiclean_weight` attribute, as we prefer to report the
abundances of the MOTUs.

```bash
obimatrix --map obiclean_weight \
          results/wolf_final.fasta \
          > results/wolf_final_occurrency.csv

csvlook results/wolf_final_occurrency.csv
```
```
| id          | seq0001 | seq0002 | seq0003 | seq0004 | seq0005 | seq0006 | seq0007 | seq0008 |
| ----------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| 29a_F260619 |       0 |     337 |       0 |       0 |     105 |   5 789 |     376 |       1 |
| 15a_F730814 |       0 |       0 |       0 |       0 |       0 |   8 822 |       0 |       5 |
| 13a_F730603 |       0 |       0 |   8 039 |       0 |       0 |       0 |       0 |      17 |
| 26a_F040644 |  12 205 |       0 |       0 |     202 |      12 |       0 |       0 |     468 |
|             |         |         |         |         |         |         |         |         |
```

To create the [CSV metadata file](results/wolf_final_motus.csv) describing the
MOTUs, you can use {{< obi obicsv >}} with the `--auto` option. This will create
a CSV file from the OBI file and automatically determine which columns to
include based on their contents from the first sequence records of the input
data set. The `-i` and `-s` options are used to include the sequence id and the
sequence itself in the output CSV file. The resulting CSV file can be viewed
with `csvlook`:

```bash
obicsv --auto -i -s \
       results/wolf_final.fasta \
       > results/wolf_final_motus.csv 

csvlook results/wolf_final_motus.csv
```
```
| id      |  count | obitag_bestid | obitag_bestmatch | obitag_match_count | obitag_rank | obitag_similarity_method | seq_number | taxid                                          | sequence                                                                                             |
| ------- | ------ | ------------- | ---------------- | ------------------ | ----------- | ------------------------ | ---------- | ---------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| seq0001 | 10 172 |        0,980… | AY227529         |                  1 | genus       | lcs                      |          1 | taxon:9992 [Marmota]@genus                     | ttagccctaaacataaacattcaataaacaagaatgttcgccagagtactactagcaacagcctgaaactcaaaggacttggcggtgctttacatccct  |
| seq0002 |    260 |        0,941… | AF154263         |                  9 | infraorder  | lcs                      |          2 | taxon:35500 [Pecora]@infraorder                | ttagccctaaacacaaataattacacaaacaaaattgttcaccagagtactagcggcaacagcttaaaactcaaaggacttggcggtgctttataccctt |
| seq0003 |  7 146 |        1,000… | AB245427         |                  1 | species     | lcs                      |          3 | taxon:9860 [Cervus elaphus]@species            | ctagccttaaacacaaatagttatgcaaacaaaactattcgccagagtactaccggcaatagcttaaaactcaaaggacttggcggtgctttataccctt |
| seq0004 |     87 |        0,949… | AY227530         |                  2 | tribe       | lcs                      |          4 | taxon:337730 [Marmotini]@tribe                 | ttagccctaaacataaacattcaataaacaagaatgttcgccagaggactactagcaatagcttaaaactcaaaggacttggcggtgctttatatccct  |
| seq0005 |     95 |        0,960… | AC187326         |                  1 | subspecies  | lcs                      |          5 | taxon:9615 [Canis lupus familiaris]@subspecies | ttagccctaaacataagctattccataacaaaataattcgccagagaactactagcaacagattaaacctcaaaggacttggcagtgctttatacccct  |
| seq0006 | 12 004 |        1,000… | AJ885202         |                  1 | species     | lcs                      |          6 | taxon:9858 [Capreolus capreolus]@species       | ttagccctaaacacaagtaattaatataacaaaattattcgccagagtactaccggcaatagcttaaaactcaaaggacttggcggtgctttataccctt |
| seq0007 |    319 |        1,000… | AJ972683         |                  1 | species     | lcs                      |          7 | taxon:9858 [Capreolus capreolus]@species       | ttagccctaaacacaagtaattattataacaaaattattcgccagagtactaccggcaatagcttaaaactcaaaggacttggcggtgctttataccctt |
| seq0008 |    366 |        1,000… | AB048590         |                  1 | genus       | lcs                      |          8 | taxon:9611 [Canis]@genus                       | ttagccctaaacatagataattttacaacaaaataattcgccagaggactactagcaatagcttaaaactcaaaggacttggcggtgctttatatccct  |
```

