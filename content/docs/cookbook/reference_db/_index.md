---
title: "Build a reference database"
date: 2025-01-23T14:32:08+01:00
draft: true
---

# Build a reference database

One of the crucial steps in the analysis of environmental DNA data is the taxonomic assignment of sequences,
*i.e.* assigning a species, genus or other taxonomic rank to the sequences present in the collected samples.

Taxonomic assignment requires annotated reference sequences, against which the sequences of interest are compared.
These reference sequences form what is known as a *reference database*, which is a sequence file in {{% fasta %}} format,
for a given marker of metabarcoding.

Here is a quick step-by-step guide to creating a reference database, here for assigning sequences from wolf fecal 
samples to study its diet, a dataset used in the [metabarcoding analysis tutorial here](https://obitools4.metabarcoding.org/docs/cookbook/wolf-tutorial/).

One way to build a reference database is to use the {{% obi obipcr %}} program to simulate a PCR and extract all sequences 
from a general purpose DNA database such as [GenBank](https://www.ncbi.nlm.nih.gov/nucleotide/) or [EMBL](https://www.ebi.ac.uk/ena/browser/home)
that can be amplified *in silico* by the two primers used for PCR amplification.

The steps to create a reference database are:

1. Download sequences from a public database such as GenBank or EMBL
2. Perform an *in silico* PCR amplification of these sequences with a given marker with {{% obi obipcr %}}
3. Clean up the database by deleting sequences that do not provide sufficient taxonomic information and are redundant

Since Genbank and the taxonomy associated with sequences are constantly evolving, you may not get exactly the same results when using the following commands.

## Download the sequences

In this example, the sequences are downloaded from the [GenBank FTP server](https://ftp.ncbi.nlm.nih.gov/genbank/). 
Please note that the download takes more than a day and currently occupies around 1.5 TB, 
so make sure you have the necessary storage capacity before launching it.
To have a local copy of GenBank sequences, please go to the 
[Prepare a local copy of GenBank](https://obitools4.metabarcoding.org/docs/cookbook/local_genbank/) page.

## Perform a *in silico* PCR amplification

In this example, we amplify the *12S-V5* region [@Riaz2011-gn] with the forward primer **TTAGATACCCCACTATGC** 
and the reverse primer **TAGAACAGGCTCCTCTAG**, with the following command, to study the wolf diet
(see the [tutorial](https://obitools4.metabarcoding.org/docs/cookbook/wolf-tutorial/)).
Do not forget to update the release number of GenBank in the command line.

```bash
obipcr -e 3 -l 50 -L 150 \ 
       --forward TTAGATACCCCACTATGC \
       --reverse TAGAACAGGCTCCTCTAG \
       --no-order \
       genbank/Release_264/fasta/*
       > v05_pcr.fasta
```

The `-l` and `-L` options define the minimum and maximum sizes of sequence fragments to be amplified.
Three mismatches with primer sequences are allowed here (-e 3), and we recommend using the `--no-order` option
to speed up the program (see {{% obi obipcr %}} documentation).

This previous command produces a {{% fasta %}} file, with the computed amplified sequences.

## Clean the database

We choose to apply these different steps of filtering to clean up the sequences obtained with {{% obi obipcr %}}:

1. Keep the sequences with a taxid and a taxonomic description to family, genus and species ranks ({{% obi obigrep %}})
2. Remove redundant sequences (dereplicate)
3. Ensure that the dereplicated sequences have a taxid (taxon identifier) at the family level
4. Ensure that sequences each have a unique identification ID with {{% obi obiannotate %}}
5. Index the database

#### Keep annotated sequences

To use the `-t` taxonomy option on all *OBITools* commands,
you can either enter the path to the taxonomy if you have downloaded
the sequences from the help page [here](https://obitools4.metabarcoding.org/docs/cookbook/local_genbank/) 
which looks like `Release_264/taxonomy`, or download the taxdump file online with `curl`.

```bash
curl http://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz
```

The {{% obi obigrep %}} program allows to filter sequences, to keep only those with a taxid and a sufficient taxonomic description.

```bash
obigrep -t taxdump.tar.gz \
        -A taxid \
        --require-rank species \
        --require-rank genus \
        --require-rank family \
        v05_pcr.fasta > v05_clean.fasta
```

#### Dereplicate sequences

The {{% obi obiuniq %}} program is able to dereplicate the sequences.

```bash
obiuniq -c taxid v05_clean.fasta > v05_clean_uniq.fasta
```

#### Ensure that the dereplicated sequences have a taxid at the family level

Some sequences lose taxonomic information at the dereplication stage if certain versions 
of the sequence did not have this information beforehand. So we apply a second filter of this type. 

```bash
obigrep -t taxdump.tar.gz --require-rank=family v05_clean_uniq.fasta > v05_clean_uniq.fasta
```

#### Ensure that sequences each have a unique identifier


#### Index the database

```bash
obirefidx -t taxdump.tar.gz v05_clean_uniq.fasta > v05_clean_uniq_indexed.fasta
```

The database provided in the [tutorial](https://obitools4.metabarcoding.org/docs/cookbook/wolf-tutorial/)
is called `wolf_data/db_v05_r117_indexed.fasta`.