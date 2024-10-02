+++
archetype = "command"
title = "Obipcr: the electronic PCR tool"
+++

## Description :

`obipcr` is the successor of [`ecoPCR`](https://metabarcoding.org/ecopcr). It is known as an electronic PCR software.

### Synopsis

```bash
obipcr --forward <string> --max-length|-L <int> --reverse <string>
       [--allowed-mismatches|-e <int>] [--batch-size <int>] [--circular|-c]
       [--compress|-Z] [--debug] [--delta|-D <int>] [--ecopcr] [--embl]
       [--fasta] [--fasta-output] [--fastq] [--fastq-output]
       [--force-one-cpu] [--fragmented] [--genbank] [--help|-h|-?]
       [--input-OBI-header] [--input-json-header] [--json-output]
       [--max-cpu <int>] [--min-length|-l <int>] [--no-order]
       [--no-progressbar] [--only-complete-flanking] [--out|-o <FILENAME>]
       [--output-OBI-header|-O] [--output-json-header]
       [--paired-with <FILENAME>] [--pprof] [--pprof-goroutine <int>]
       [--pprof-mutex <int>] [--skip-empty] [--solexa] [--version] [<args>]
```

### Options

#### `obipcr` mandatory options:

- {{< cmd-option name="forward" param="PATTERN" >}}
  The forward primer used for the electronic PCR. IUPAC codes can be used in the pattern.  
  {{< /cmd-option >}}

- {{< cmd-option name="reverse" param="PATTERN" >}}
  The reverse primer used for the electronic PCR. IUPAC codes can be used in the pattern.  
  {{< /cmd-option >}}

- {{< cmd-option name="max-length" short="L" param="INTEGER" >}}
  Maximum length of the barcode, primers excluded.
  {{< /cmd-option >}}

#### Other `obipcr` specific options:

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
obipcr -e 3 -l 10 -L 220  \  
       --forward GGGCAATCCTGAGCCAA \   
       --reverse CCATTGAGTCTCTGCACCTATC \
       /data/Genbank/Release_261 \
       > Sper01_obipcr.fasta
```