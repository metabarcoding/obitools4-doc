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

- {{< cmd-option name="allowed-mismatches" short="e" param="INTEGER" >}}
  Maximum number of mismatches allowed for each primer (default: 0).
  {{< /cmd-option >}}

- {{< cmd-option name="min-length" short="l" param="INTEGER" >}}
  Minimum length of the barcode primers excluded (default: no minimum length).
  {{< /cmd-option >}}

- {{< cmd-option name="circular" short="c" >}}
  Considers that sequences are circular. (default: sequences are considered linear)  
  {{< /cmd-option >}}

- {{< cmd-option name="delta" short="D" param="INTEGER" >}}
  Without this option, only the barcode sequences will be output, without the priming sites. This option allows to add the priming sites and the flanking sequences of the priming sites over a length of `delta` to each side of the barcode.
  {{< /cmd-option >}}

- {{< cmd-option name="only-complete-flanking" >}}
  Works in conjunction with **--delta**. Prints only sequences with full-length flanking sequences (default: prints every sequence regardless of whether the flanking sequences are present).
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

The minimal `ecopcr` command looks like this:

```bash
obipcr -L 220  \  
       --forward GGGCAATCCTGAGCCAA \   
       --reverse CCATTGAGTCTCTGCACCTATC \
       /data/Genbank/Release_261 \
       > Sper01_obipcr.fasta
```

It fetches the sequences from the NCBI Genbank release 261 database stored in the `/data/Genbank/Release_261` directory. The output is stored in the `Sper01_obipcr.fasta` file. The primer pair is specified as `GGGCAATCCTGAGCCAA` and `CCATTGAGTCTCTGCACCTATC` using the `--forward` and `--reverse` options. These primers correspond to the marker *Sper01*. The `-L` option specifies the maximum length of the barcode, primers excluded, here 220 nucleotides. By default no mismatches are allowed between the primers and the priming sites.

To allows mismatches between the primers and the priming sites, use the `--allowed-mismatches` option or its short form `-e`. Here, the maximum number of mismatches allowed is 3. This maximum number of mismatches is allowed per primer. The error can occur at any position of the primer.

```bash
obipcr -e 3  \  
       -L 220  \  
       --forward GGGCAATCCTGAGCCAA \
       --reverse CCATTGAGTCTCTGCACCTATC \
       /data/Genbank/Release_261 \
       > Sper01_obipcr.fasta
```

