---
title: "Analysing an Illumina data set"
weight: 1
bibFile: bibliography/bibliography.json 
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

1. Pairing (i.e. partial alignment) of forward and reverse reads
2. Exclusion of unpaired reads
3. Reads demultiplexing (i.e. assignment to their original sample)
4. Reads dereplication
5. Dataset denoising
6. Sequence taxonomic assignment
7. Exporting the results in a tabular format

## The dataset to analyze and the reference database

The dataset used in this tutorial corresponds to data obtained from the analysis of four wolf scats
using the protocol published in {{< cite Shehzad2012-pn >}} for carnivore diet assessment.
After extraction of DNA from feces, DNA amplification was performed using the Vert01
primers (`TTAGATACCCCACTATGC` and `TAGAACAGGCTCCTCTAG` amplifying the *12S-V5*
region {{< cite Riaz2011-gn >}}), together with a wolf blocking oligonucleotide.

An archive containing all the files needed for the analysis can be downloaded by clicking here: [wolf_diet_dataset](wolf_diet_dataset.tgz) 

The downloaded archive can be unarchived using the following unix command:

```bash
tar zxvf wolf_diet_dataset.tgz
```

It creates a directory named `wolf_data`, containing the following files:

- Two {{% fastq %}} files generated by the sequencing of DNA extracted and amplified from four wolf feces using the Genome Analyzer IIx plateform (Illumina) and the paired-end (2 x 108 bp) sequencing chemistry:
    - [`wolf_F.fastq`](wolf_data/wolf_F.fastq) with the forward sequences
    - [`wolf_R.fastq`](wolf_data/wolf_R.fastq) with the reverse sequences

- A [csv tabular file](https://obitools4.metabarcoding.org/docs/formats/csv/) for the reads demultiplexing step, named [`wolf_diet_ngsfilter.csv`](wolf_data/wolf_diet_ngsfilter.csv). This file contains the primer and tag sequences used for each sample. The tags correspond to short and specific sequences added to the 5\' end of each primer to distinguish the different samples.

- A reference database in {{% fasta %}} format named
  [`db_v05_r117.fasta.gz`](wolf_data/db_v05_r117.fasta.gz), extracted from the EMBL release 117 following the procedure indicated in the tutorial [build a reference database](https://obitools4.metabarcoding.org/docs/cookbook/reference_db/).

We recommend to create a new folder to store the results and separate them from the raw data:

```bash
mkdir results
```

## Recover full length sequences from forward and reverse reads

When using the result of a paired-end sequencing with supposedly overlapping forward and reverse reads,
the first step is to assemble them in order to recover the corresponding full length sequence.

The forward and reverse reads of the same fragment are located at the same line position in both fastq files. These two files are used as inputs by the {{% obi obipairing %}} program to assemble the forward and reverse reads. This program then returns the reconstructed sequence as output:

```bash
obipairing --min-identity=0.8 \
           --min-overlap=10 \
           -F wolf_data/wolf_F.fastq \
           -R wolf_data/wolf_R.fastq \
           > results/wolf.fastq 
```

The `--min-identity` and `--min-overlap` options allow to discard sequences with low alignment quality. In the example command above, a low alignment quality corresponds to paired-end reads overlapping over less than 10 base pairs, or to paired-end reads exhibiting an alignment of less than 80% of identity. Paired-end reads producing such low quality alignments are returned concatenated with an attribute `"mode":"join"`. Those that do not fulfill the above criteria are assembled and the result is returned with the attribute `"mode":"alignment"`. For more information, please refer to the command {{% obi obipairing %}}.

The output of the above procedure can be rapidly checked by looking at the first sequence record of `wolf_assembled.fastq`. This can be done with the unix command:

```bash
head -n 4 results/wolf.fastq
```
```
@HELIUM_000100422_612GNAAXX:7:108:5640:3823#0/1 {"ali_dir":"left","ali_length":62,"mode":"alignment","pairing_fast_count":53,"pairing_fast_overlap":62,"pairing_fast_score":0.898,"pairing_mismatches":{"(T:26)->(G:13)":62,"(T:34)->(G:18)":48},"score":1826,"score_norm":0.968,"seq_a_single":46,"seq_ab_match":60,"seq_b_single":46}
ccgcctcctttagataccccactatgcttagccctaaacacaagtaattaatataacaaaattgttcgccagagtactaccggcaatagcttaaaactcaaaggacttggcggtgctttatacccttctagaggagcctgttctaaggaggcgg
+
CCCCCCCBCCCCCCCCCCCCCCCCCCCCCCBCCCCCBCCCCCCC<CcDccbe[`F`accXV=TA\RYU\\ee_e[XZ[XEEEEEEEEEE?EEEEEEEEEEDEEEEEEECCCCCCCCCCCCCCCCCCCCCCCACCCCCACCCCCCCCCCCCCCCC
```


The `-n 4` option of the head command indicates to print only the first four lines of the file, i.e. to print only the first sequence record (each sequence record in the [fastq format](https://obitools4.metabarcoding.org/docs/formats/fastq/) is stored on four lines).  


## Exclude unpaired reads

Sequences corresponding to unpaired reads exhibit an attribute `"mode":"join"` and cannot be reliably used in downstream analyses. They can be removed from the dataset using the {{% obi obigrep %}} command, as follows:

```bash
obigrep -p 'annotations.mode != "join"' \
        results/wolf.fastq > results/wolf_assembled.fastq
```

The `-p` requires a [{{% obitools4 %}} expression]({{< ref "/docs/programming/expression" >}}), here `annotations.mode != "join"`, which means that
if the value of the `mode` annotation of a sequence is different from `join`,
then the corresponding sequence record should be kept in the output.

## Assign each sequence record to the corresponding sample and marker combination

Each sequence record is assigned to its corresponding sample and marker using the information provided in the file [`wolf_diet_ngsfilter.csv`](wolf_data/wolf_diet_ngsfilter.csv).
This file, which is in a  {{% csv %}} tabular format, exemplifies the type of information necessary for the {{% obi obimultiplex %}} program to run.

{{< code "wolf_data/wolf_diet_ngsfilter.csv" csv true >}}

The minimal file should contain at least the five columns below.
The order of the column is not mandatory.

- **experiment**: the name/identifier of the experiment/project (several experiments/projects can be
  included in the same file)
- **sample**: the name/identifier of the sample or of the PCR
- **sample_tag**: the sequences of the tags (*e.g.* `aattaac` if a same tag has been used on each
  extremity of the PCR products, or `aattaac:gaagtag` if two different tags were
  used)
- **forward_primer**: the sequence of the forward primer
- **reverse_primer**: the sequence of the reverse primer

Other information can be added as extra columns (e.g. position of the sample/PCR in the PCR plate, type of sample or control, etc.)

Some extra lines can be added at the top of this file. They start with the `@param` value.
Here three parameters have been provided: 

- `@param,matching,strict`: The match between the sequence of the tags in the file [`wolf_diet_ngsfilter.csv`] and their corresponding sequences in the sequencing data should be strict, without any mismatches.
- `@param,primer_mismatches,2`: The match between the primers and their corresponding sequences in the sequencing data can exhibit at most two mismatches.
- `@param,indels,false`: The mismatches between the primers and their corresponding sequences in the sequencing data cannot be insertions or deletions, but only substitutions.  
  
See {{% obi obimultiplex %}} for more details.

```bash
obimultiplex -s wolf_data/wolf_diet_ngsfilter.csv \
             -u results/unidentified.fastq \
             results/wolf_assembled.fastq \
             > results/wolf_assembled_assigned.fastq
```

The command {{% obi obimultiplex %}} written above creates two files:

-   [`unidentified.fastq`](results/unidentified.fastq) containing the sequences records that
    failed to be assigned to a sample/marker combination
-   [`wolf_assembled_assigned.fastq`](results/wolf_assembled_assigned.fastq)
    containing the sequence records that were properly assigned to a sample/marker
    combination

Note that each sequence record of the
[`wolf_assembled_assigned.fastq`](results/wolf_assembled_assigned.fastq) file
contains only the barcode sequence as the sequences of primers and tags are
removed by the {{% obi obimultiplex %}} program. Information concerning the
experiment, sample, primers and tags is added as attributes in the sequence
header.

For example, the first sequence record of [`wolf_assembled_assigned.fastq`](results/wolf_assembled_assigned.fastq) is:

```
@HELIUM_000100422_612GNAAXX:7:108:5640:3823#0/1_sub[28..127] {"ali_dir":"left","ali_length":62,"experiment":"wolf_diet","mode":"alignment","obimultiplex_amplicon_rank":"1/1","obimultiplex_direction":"forward","obimultiplex_forward_error":0,"obimultiplex_forward_match":"ttagataccccactatgc","obimultiplex_forward_matching":"strict","obimultiplex_forward_primer":"ttagataccccactatgc","obimultiplex_forward_proposed_tag":"gcctcct","obimultiplex_forward_tag":"gcctcct","obimultiplex_forward_tag_dist":0,"obimultiplex_reverse_error":0,"obimultiplex_reverse_match":"tagaacaggctcctctag","obimultiplex_reverse_matching":"strict","obimultiplex_reverse_primer":"tagaacaggctcctctag","obimultiplex_reverse_proposed_tag":"gcctcct","obimultiplex_reverse_tag":"gcctcct","obimultiplex_reverse_tag_dist":0,"pairing_mismatches":{"(T:26)->(G:13)":35,"(T:34)->(G:18)":21},"paring_fast_count":53,"paring_fast_overlap":62,"paring_fast_score":0.898,"sample":"29a_F260619","score":1826,"score_norm":0.968,"seq_a_single":46,"seq_ab_match":60,"seq_b_single":46}
ttagccctaaacacaagtaattaatataacaaaattgttcgccagagtactaccggcaatagcttaaaactcaaaggacttggcggtgctttataccctt
+
CCCBCCCCCBCCCCCCC<CcDccbe[`F`accXV=TA\RYU\\ee_e[XZ[XEEEEEEEEEE?EEEEEEEEEEDEEEEEEECCCCCCCCCCCCCCCCCCC
```

The sample to which the sequence above belongs to is shown in the attribute `"sample":"29a_F260619"`. The other attributes added correspond to the tags and primers matching properties against the sequence.

## Reads dereplication

A DNA metabarcoding experiment inherently yields the same DNA
sequence several times (i.e. replicated reads). Such a redundancy can be reduced by processing unique
*sequences* instead of *reads* so as to reduce both file size and computation time,
as well as to obtain more interpretable results. Dereplicating replicated *reads* into unique
*sequences* can be done with the {{< obi obiuniq >}} command.

The program performs a pairwise comparison of all reads in the dataset. For reads that are strictly
identical, only one representative sequence is kept while its frequency in the dataset is saved in the `count` attribute.

In the command below, we use the {{% obi obiuniq %}} command with the `-m sample` option to also store the frequency of the sequence in each sample. The program returns a {{% fasta %}} file.

```bash
obiuniq -m sample \
        results/wolf_assembled_assigned.fastq \
        > results/wolf_assembled_assigned_uniq.fasta
```

The first sequence record of the output, [`wolf_assembled_assigned_uniq.fasta`](results/wolf_assembled_assigned_uniq.fasta) is:

```
>HELIUM_000100422_612GNAAXX:7:99:12017:19418#0/1_sub[28..127] {"ali_dir":"left","ali_length":62,"count":1,"experiment":"wolf_diet","merged_sample":{"29a_F260619":1},"mode":"alignment","obimultiplex_amplicon_rank":"1/1","obimultiplex_direction":"forward","obimultiplex_forward_error":0,"obimultiplex_forward_match":"ttagataccccactatgc","obimultiplex_forward_matching":"strict","obimultiplex_forward_primer":"ttagataccccactatgc","obimultiplex_forward_proposed_tag":"gcctcct","obimultiplex_forward_tag":"gcctcct","obimultiplex_forward_tag_dist":0,"obimultiplex_reverse_error":0,"obimultiplex_reverse_match":"tagaacaggctcctctag","obimultiplex_reverse_matching":"strict","obimultiplex_reverse_primer":"tagaacaggctcctctag","obimultiplex_reverse_proposed_tag":"gcctcct","obimultiplex_reverse_tag":"gcctcct","obimultiplex_reverse_tag_dist":0,"pairing_mismatches":{"(A:02)->(C:07)":54,"(A:02)->(G:17)":59,"(C:02)->(G:10)":42},"paring_fast_count":43,"paring_fast_overlap":62,"paring_fast_score":0.729,"sample":"29a_F260619","score":567,"score_norm":0.935,"seq_a_single":46,"seq_ab_match":58,"seq_b_single":46}
ttagccctaaacacaagtaattaatataacaaaattattcggcagagtactaccggcagt
agcttaaaactcaaaggacttggcggtgctttatacccct
```

The {{% obi obiuniq %}} command has added two `key:value` entries in the sequences attributes:

-   `"merged_sample":{"29a_F260619":1}`: means that this sequence has been found once, in a single sample called "29a_F260619". 
-   `"count":1` : represents the number of times, i.e. 1, this sequence has been found in the whole dataset.

To keep only these two attributes in the sequence definition, we can use the {{% obi obiannotate %}} command:

```bash
obiannotate -k count -k merged_sample \
  results/wolf_assembled_assigned_uniq.fasta \
  > results/wolf_assembled_assigned_simple.fasta
```

The first five sequence records of the result, [`wolf_assembled_assigned_simple.fasta`](results/wolf_assembled_assigned_simple.fasta), become:

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

## Dataset denoising

Having all sequences assigned to their respective samples does 
not mean that all these sequences are *biologically* meaningful. Some of
these sequences can correspond to PCR/sequencing errors, or chimeras.

#### Flagging PCR errors

The {{% obi obiclean %}} program flags sequence variants as:
- potential error generated during PCR amplification (flagged as `internal` sequences), 
- genuine sequences:
  - flagged as `head`, 
  - or `singletons` sequences, i.e. sequences for which the program could not identify a variant.

In the example below, a sequence is considered as a variant of another one if:
- both occurred in the same sample (`-s sample`),
- it exist only a single difference between both sequences (substitution, insertion, or deletion)
- if the abondance of the variant is less than 5% of the abondance of the main sequence (`-r 0.05` option).
We ask {{% obi obiclean %}} to keep only the sequences that are considered as genuine `head` or `singleton` in at least one sample (`-H` option). See the {{% obi obiclean %}} documentation for details.

```bash
obiclean -s sample -r 0.05 --detect-chimera -H \
         results/wolf_assembled_assigned_simple.fasta \
         > results/wolf_assembled_assigned_simple_clean.fasta
```

Below an example of a sequence record of [`wolf_assembled_assigned_simple_clean.fasta`](results/wolf_assembled_assigned_simple_clean.fasta):

```
>HELIUM_000100422_612GNAAXX:7:3:3008:16359#0/1_sub[28..127] {"count":1,"merged_sample":{"29a_F260619":1},"obiclean_head":true,"obiclean_headcount":0,"obiclean_internalcount":0,"obiclean_samplecount":1,"obiclean_singletoncount":1,"obiclean_status":{"29a_F260619":"s"},"obiclean_weight":{"29a_F260619":1}}
ttagccctaaacacaagtaattaatataacaaaattattcgacagagtaccaccggcaat
agcttaaaactcaaaggacttggcggtgctttataccctt
```

The attribute `"obiclean_head":true` indicates that this sequence record is considered as a `head`, hence a genuine sequence, but the attributes `"obiclean_status":{"29a_F260619":"s"}` also indicates that this sequence is actually a "singleton" sequence.

#### Getting some statistics on the dataset size 

A good practice is to monitor the effect of each filtering step on the dataset characteristics. Basic statistics can be obtained with {{< obi obicount >}} command. This command counts the number of sequence *variants*, of *reads* and of *symbols* (i.e. nucleotides) in the dataset. The output is a {{% csv %}} file
with two columns: the first one being the type of entity/statistic and the
second one its corresponding count in the whole dataset.

```bash
obicount results/wolf_assembled_assigned_simple_clean.fasta
```
```
entities,n
variants,715
reads,33762
symbols,70775
```

As a {{% csv %}} file, the result can be easily read by many tools, such as the `csvlook` command-line tool from the csvkit package to return the result in a more readable way (pretty-print):

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

At this stage of the analysis, the [`wolf_assembled_assigned_simple_clean.fasta`](results/wolf_assembled_assigned_simple_clean.fasta) file contains 715 sequence variants corresponding to 33762 sequencing reads. Amongst these variants, we expect many of them to occur only once in the whole data set, i.e. to be *singletons*. Using the {{< obi obigrep >}} command, we can see how many singletons there are:

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

To understand the {{< obi obigrep >}} command, you need to know more about the `-p`
option. This option allows you to specify a predicate function to be applied to
each sequence in the dataset. If the function returns `True`, the sequence is
included in the output; if it returns `False`, it is excluded. In this case, we
use a predicate that checks whether the count of sequences (which is what
`sequence.Count()` gives us) is equal to 1. In our data set, there are 649
singletons (or variants). These singleton sequences have more chances to be errors
than genuine sequences, and it is of common practice to exclude them from the dataset. 
The {{< obi obigrep >}} command below keeps only sequences that occur at least twice in the data set.

```bash
obigrep -c 2 \
        results/wolf_assembled_assigned_simple_clean.fasta \
        > results/wolf_assembled_no_singleton.fasta
```

We can also get insights into the distribution of the sequence across samples with {{< obi obisummary >}}. This command provides a summary of the dataset including the number of sequencing reads, sequence variants and singletons occurring in each sample. Here singleton has to be interpreted as sequence
variants occurring only once in the sample.

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

In this example, the sample *29a_F260619* produced *7374* reads that are
distributed over *36* sequence variants. Amongst these variants, *7* occur only once, i.e. are singletons.

In a diet analysis - and many other DNA metabarcoding application, we are often not interested in sequences that represent less than one percent of the diet. In other words, we can filter out any sequence that occurs less than one percent of the *7000* times in the dataset, i.e. less than *70* times.

To get an idea of the effect of this filtering, we can run the following command to
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

The y-axis represents the 'count' attribute, which is the number of occurrences of a sequence in the dataset. The x-axis represents the number of sequences that occur that many times. For example, 43 sequences occur twice in the data set.

In this sequence abundance distribution, we can see that with a 1% filter, we will only keep
 9 sequence variants, i.e. those that occur at least 87 times in the entire dataset.

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

Another criterion commonly used to filter out sequences relies on their length. We
know the expected length of the marker, as well as that of the sequences in our dataset. Therefore, we can define the sequences that are too long or too short as potential errors. Inspired by the command above, we can build another command plotting the distribution of sequences length in the
dataset:

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

The DNA marker amplified here, i.e. the v5 region of the mitochondrial 12S rRNA gene, should be about 100 bp long. Here, one sequence is very short (<5 bp). We can filter this sequence out with {{% obi obigrep %}}:

```bash
obigrep -l 50 \
        results/wolf_assembled_1_percent.fasta \
        > results/wolf_assembled_no_short.fasta
```

To check the effectiveness of your filtering command, you can check the distribution of sequences length in the new file 
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


## Sequences taxonomic assignment

Once the dataset is curated, the next step in a classical diet metabarcoding analysis is to assign the
barcodes a taxon name (species, genus, etc.), in order to retrieve the list
of taxa detected in each sample.

The taxonomic assignment of sequences requires a reference database to detect
all possible taxa identified in the samples, which is provided in this tutorial
as [`db_v05_r117.fasta.gz`](wolf_data/db_v05_r117.fasta.gz) (see the tutorial [build a reference database](https://obitools4.metabarcoding.org/docs/cookbook/reference_db/) for know how to obtain this reference
database). The taxonomic annotation is then based on a comparison of the metabarcoding sequences against a pool of reference sequences. This operation is done with the {{< obi obitag >}} programm.

### Downloading of the taxonomy

The {{< obi obitag >}} programm requires access to the full taxonomy in order to compute its inferences.
The [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy) is complete and available online. It is possible to download a copy of it with the following command:

```bash
obitaxonomy --download-ncbi --out ncbitaxo.tgz
```

The full copy of the NCBI taxonomy is now locally stored in the `ncbitaxo.tgz` file of your current working
directory.

### Assigning taxa to the sequences 

Using the reference database [`db_v05_r117.fasta.gz`](wolf_data/db_v05_r117.fasta.gz) and the full NCBI taxonomy, assigning taxa to the sequences can be done with {{% obi obitag %}} as follows:

```bash
obitag -t ncbitaxo.tgz \
       -R wolf_data/db_v05_r117.fasta.gz \
       results/wolf_assembled_no_short.fasta \
       > results/wolf_assembled_taxo.fasta
```

The resulting file, containing only few sequences in this tutorial, looks like this:

{{< code "results/wolf_assembled_taxo.fasta" fasta true >}}

The {{% obi obitag %}} command adds several attributes in the sequence record header, like:

- `obitag_bestmatch:ACCESSION` where ACCESSION is the id of the sequence in
the reference database that best aligns to the query sequence
- `obitag_bestid:FLOAT` where FLOAT\*100 is the percentage of identity between
the best match sequence and the query sequence
- `taxid:TAXID` where TAXID is the taxonomic ID of the taxon assigned to the sequence by {{% obi obitag %}}

## Exporting the results in a tabular format

To reduce the file size and make it easier to analyze, we can make some
cosmetic changes to the data file, for example by removing some useless information that 
{{% obitools4 %}} inserts in the sequence header to explain its decisions.

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
analyzing the sequencing process, but useless for us, especially after a {{< obi obiuniq >}} command, as the sequence id correponds to the id of only one of the merged sequences. We can thus change it to make it more readable. This is done in two steps. First, we use the first {{< obi obiannotate >}} 
command to add a `seq_number` attribute in the sequence header that numbers the sequence from *1*
to *n*, the number of sequence variants. Second, we use the value of this new attribute to create a new, more readable sequence identifier using the `sprintf` function of the {{% obitools4 %}} expression language. The new sequence identifier is a string consisting of the prefix "seq" followed by the sequence
number, padded with zeros to make it 4 characters long (e.g., seq0001, seq0002,
etc.).

```bash
obiannotate --number results/wolf_minimal.fasta \
  | obiannotate --set-id 'sprintf("seq%04d",annotations.seq_number)' \
  > results/wolf_final.fasta
```

{{< code "results/wolf_final.fasta" fasta true >}}

It is now possible to extract the useful information for our ecological analysis
from our sequence file. The results of this extraction consists of two {{% csv %}} files, one describing the occurrence of each sequence variant in the different samples, and one for the
metadata describing each sequence variant, which can at this stage of the analysis be considered as a Molecular Taxonomic Unit, i.e. MOTU.

### The MOTU occurrence table

In the results file [`wolf_final.fasta`](results/wolf_final.fasta), two
attributes inform us about the distribution of MOTU abundances across samples
(which here correspond to individual PCR): the `merge_sample` attribute and the `obiclean_weight` attribute.

The `merge_sample` attribute was set by {{< obi obiuniq >}} during the initial
reads dereplication procedure. It contains the observed number of reads for each
sequence variant in the different samples. The `obiclean_weight` attribute is
the number of reads assigned to each sequence variant after the {{< obi obiclean >}} 
denoising (or clustering) step. The number of reads shown in this attribute takes into
account not only the number of reads observed for this variant, but also the
number of reads observed for the erroneous sequences clustered to this estimated
genuine sequence. According to {{< obi obiclean >}}, `obiclean_weight` is a better
estimate of the true sequence occurrence than the `merge_sample` attribute.

The {{< obi obimatrix >}} command creates the {{% csv %}} file representing any map
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
MOTUs attributes, you can use {{< obi obicsv >}} with the `--auto` option. This will create
a {{% csv %}} file from the [`wolf_final.fasta`](results/wolf_final.fasta) file and automatically determine which columns to include based on their contents from the first sequence records of the input
dataset. In the example below, the `-i` and `-s` options are used to include the sequence identifier and the sequence itself in the output {{% csv %}} file. The result can be viewed with `csvlook`:

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

## References

{{< bibliography cited >}}