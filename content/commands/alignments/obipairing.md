+++
archetype = "command"
title = "Obipairing: align the forward and reverse paired reads"
+++

## Description :

### Synopsis

```bash
obipairing --forward-reads|-F <FILENAME_F> --reverse-reads|-R <FILENAME_R>
           [--batch-size <int>] [--compress|-Z] [--debug] [--delta|-D <int>]
           [--ecopcr] [--embl] [--exact-mode] [--fast-absolute] [--fasta]
           [--fasta-output] [--fastq] [--fastq-output] [--force-one-cpu]
           [--gap-penality|-G <float64>] [--genbank] [--help|-h|-?]
           [--input-OBI-header] [--input-json-header] [--json-output]
           [--max-cpu <int>] [--min-identity|-X <float64>]
           [--min-overlap <int>] [--no-order] [--no-progressbar]
           [--out|-o <FILENAME>] [--output-OBI-header|-O]
           [--output-json-header] [--penality-scale <float64>] [--pprof]
           [--pprof-goroutine <int>] [--pprof-mutex <int>] [--skip-empty]
           [--solexa] [--version] [--without-stat|-S] [<args>]
```

### Options

#### `obipairing` mandatory options

- {{< cmd-option name="forward-reads" short="F" param="FILENAME" >}}
  The name of the file containing the forward reads.
  {{< /cmd-option >}}

- {{< cmd-option name="reverse-reads" short="R" param="FILENAME" >}}
  The name of the file containing the reverse reads.
  {{< /cmd-option >}}


#### Other `obipairing` specific options:

- {{< cmd-option name="delta" short="D" param="INTEGER" >}}
  Length added to the fast-detected overlap for the exact alignment algorithm (default: 5 nucleotides).  
  {{< /cmd-option >}}

- {{< cmd-option name="exact-mode" >}}
  Do not run fast alignment heuristic. (default: a fast algorithm is run at first to accelerate the final exact alignment).  
  {{< /cmd-option >}}

- {{< cmd-option name="fast-absolute" >}}
  Compute absolute fast score, this option has no effect in exact mode (default: false).
  {{< /cmd-option >}}

- {{< cmd-option name="gap-penality" short="G" param="FLOAT64" >}}
  Gap penality expressed as the multiply factor applied to the mismatch score between two nucleotides with a quality of 40 (default 2). (default: 2.000000)
  {{< /cmd-option >}}

- {{< cmd-option name="min-identity" short="X" param="FLOAT64" >}}
  Minimum identity between ovelaped regions of the reads to consider the aligment (default: 0.900000).
  {{< /cmd-option >}}

- {{< cmd-option name="min-overlap" param="INTEGER" >}}
  Minimum overlap between both the reads to consider the aligment (default: 20).
  {{< /cmd-option >}}

- {{< cmd-option name="penality-scale" param="FLOAT64" >}}
  Scale factor applied to the mismatch score and the gap penality (default 1).
  {{< /cmd-option >}}

- {{< cmd-option name="without-stat" short="S" >}}
  Remove alignment statistics from the produced consensus sequences (default: false).
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
obipairing --help
```
