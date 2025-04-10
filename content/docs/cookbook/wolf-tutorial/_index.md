---
title: "Metabarcoding analysis tutorial"
weight: 1
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# Metabarcoding analysis tutorial

Here is a short tutorial for analyzing metabarcoding data, on an Illumina dataset from a wolf diet study, using the OBITools 4 and basic unix commands.
It presents the following analysis steps:

1. Assembly of forward and reverse reads
2. Suppression of unaligned sequence records
3. Sequence demultiplexing
4. Dereplication of sequences
5. Dataset denoising
6. Taxonomic assignation of the sequences
7. Generate the contingency table of results
8. Import the results in R

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

A same DNA molecule can be sequenced several times. In order to reduce
both file size and computations time, and to get easier interpretable
results, it is convenient to work with unique *sequences* instead of
*reads*. To dereplicate such *reads* into unique *sequences*,
we use the `obiuniq` command.

All reads in the dataset are compared in pairs, those that are strictly identical are grouped together,
and only one copy of each sequence is kept, with frequency information in the `count` attribute.

For dereplication, we use the {{% obi obiuniq %}} command with the `-m sample` option 
to keep the information of the original samples for each unique sequence. It returns a {{% fasta %}} file.

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

-   `"merged_sample":{"29a_F260619":1}`: this sequence have been found once in a single sample called "29a_F260619"
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
these sequences can contains PCR and/or sequencing errors, or chimeras.

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

#### Get some statistics about the sequence counts {.unnumbered}

```bash
obicount results/wolf_assembled_assigned_simple_clean.fasta
```
```
entities,n
variants,715
reads,33762
symbols,70775
```

The dataset contains 765 sequence variants corresponding to 33823 sequence reads.
Most of the variants occur only a single time in the complete dataset and are usually
named *singletons*, let us see how many singletons there are:

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

In our dataset, there are 649 singletons (or variants). These singleton
sequences are more likely to be errors than true sequences. It is generally
accepted to discard them. The {{< obi obigrep >}} command retains only sequences
that occur at least twice in the data set.

```bash
obigrep -c 2 \
        results/wolf_assembled_assigned_simple_clean.fasta \
        > results/wolf_assembled_no_singleton.fasta
```

To get some insight into the distribution of the sequence among the samples, we can use {{< obi obisummary >}}. This command will provide a summary of the data set including the number of sequence reads, sequence variants and singleton occurring in each sample. Here singleton has to be interpreted as sequence variants occurring a single time in the sample.

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

As example, for the sample *29a_F260619*, *7374* reads were obtained, distributed in *36* sequence variants. Among them *7* occur only once.

If we consider that we are not interested in sequence representing less than a percent of the diet, we can filter out every sequence occurring in the dataset less than one percent of *7,000* times, i.e., less than *70* times.

To have an idea of the effect of this filter, we can run the following command to plot the distribution of the `count` attribute in the dataset:

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

The Y axis is the `count` attribute (the number of occurrences of the sequence in the dataset), and the X axis is the count of sequence occurring that number of times. As example 43 sequences occur twice in the data set.

From that distribution, we can see that using this 1% filter, we will keep only the 9 sequence variants occurring at least 87 times in the total data set.

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

## Some st
In a similar way, it is also possible to plot the distribution of the sequence length.

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

The metabarcode sequence is supposed to be about 100 bp long, but few sequences are very short (<10 bp). We filter these short sequences out with {{% obi obigrep %}}:

```bash
obigrep -l 50 \
        results/wolf_assembled_1_percent.fasta \
        > results/wolf_assembled_no_short.fasta
```

On the new file [wolf_assembled_no_short.fasta](results/wolf_assembled_no_short.fasta), it is possible to check again the distribution of sequence lengths:

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

Once the denoising of the data has been done, the next step in diet analysis is to
assign the barcodes to the corresponding taxa (species, genus, etc.),
in order to get the complete list of the taxa associated to each sample.

The taxonomic assignment of sequences requires a reference database to
detect all possible taxa to be identified in samples, which is provided in 
this tutorial as `db_v05_r117.fasta` (see "Build a reference database" 
documentation for more information about the reference database).
It is then based on sequence comparison between sample
sequences and reference sequences.

#### Download the taxonomy  {.unnumbered}

The current and complete taxonomy from the NCBI is available online,
it is possible to download it with the following command:

```bash
obitaxonomy --download-ncbi --out ncbitaxo.tgz
```

A full copy of the [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy) is now locally stored in the `ncbitaxo.tgz` file.

#### Assign the sequences {.unnumbered}

Thanks to the reference database, taxonomic assignment can be
carried out with {{% obi obitag %}}:

```bash
obitag -t ncbitaxo.tgz \
       -R wolf_data/db_v05_r117.fasta.gz \
       results/wolf_assembled_no_short.fasta \
       > results/wolf_assembled_taxo.fasta
```

{{< code "results/wolf_assembled_taxo.fasta" fasta true >}}

The {{% obi obitag %}} command adds several attributes in the sequence record header, like:

- `obitag_bestmatch:ACCESSION` where ACCESSION is the id of hte sequence in
the reference database that best aligns to the query sequence
- `obitag_bestid:FLOAT` where FLOAT\*100 is the identity percent between
the best match sequence and the query sequence
- `taxid:TAXID` where TAXID is the final taxonomy ID assigned to the sequence by {{% obi obitag %}}

## Generate the contingency table of results

Some useless attributes can be removed at this stage with {{% obi obiannotate %}}:

```bash
obiannotate  --delete-tag=obiclean_head \
             --delete-tag=obiclean_headcount \
             --delete-tag=obiclean_internalcount \
             --delete-tag=obiclean_samplecount \
             --delete-tag=obiclean_singletoncount \
             results/wolf_assembled_taxo.fasta \
             > results/wolf_minimal.fasta
```

{{< code "results/wolf_minimal.fasta" fasta true >}}

```bash
obiannotate --number results/wolf_minimal.fasta \
  | obiannotate --set-id 'sprintf("seq%04d",annotations.seq_number)' \
  > results/wolf_final.fasta
```

{{< code "results/wolf_final.fasta" fasta true >}}


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

