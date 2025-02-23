---
title: "Exact alignment"
weight: 2
params:
  plotly: true
---
# Exact alignment of paired reads

The {{< obi obipairing >}} command uses an exact alignment algorithm based on dynamic programming to finalize the alignment between forward and reverse reads. It corresponds to a semi-global alignment (end-gap free) algorithm but asymmetric. 

## Scoring system

The alignment algorithm used by {{< obi obipairing >}} must define :

- A {{< katex >}} score > 0 {{< /katex >}} for the match between two nucleotides (same nucleotide at the same position in the alignment).
  Thus, the accumulation of matches during the alignment process will increase the alignment score.
- A {{< katex >}} score < 0 {{< /katex >}} for a mismatch between two nucleotides (different nucleotides at the same position in the alignment).
  Thus, the accumulation of mismatches during the alignment process will decrease the alignment score.
- A {{< katex >}} score < 0 {{< /katex >}} for an insertion or deletion of a nucleotide (gap) in one of the two reads.
  Thus, the accumulation of insertions or deletions during the alignment process will decrease the alignment score.

The scores are based on the sequencing quality scores {{< katex >}}Q_F{{< /katex >}} and {{< katex >}}Q_R{{< /katex >}} of the two considered nucleotides on the forward and reverse reads, respectively, because the quality score is related to the probability of an erroneous read, or more exactly the probability that the actual *X* base read is unknown.

{{< katex display=true >}}
P(X\, \text{is unknown}) = 10^{-\frac{Q}{10}}
{{< /katex >}}

Consideration of the reading uncertainty means that if the sequencer reads a nucleotide *X* at position *i*, where *X* is one of the nucleotides *A*, *C*, *G*, or *T*, with a quality score *Q*, there is a probability {{< katex >}}P(truth = X) {{< /katex >}} that *X* is actually an *X* nucleotide. 

{{< katex display=true >}}P(truth = X) = 1 - 10^{-\frac{Q}{10}}{{< /katex >}} 

The complementary probability corresponds to the case where the nature of *X* is unknown. *X* can actually be any of the four nucleotides. If we assume the equiprobability of the four nucleotides, this implies that the probability that *X* is actually *Y* one of the four nucleotides is 

{{< katex display=true >}}P(Y | Obs(X)) = \frac{10^{-\frac{Q}{10}}}{4} {{< /katex >}}


### Estimating the probability of a true match

Where {{< katex >}}Q_F{{< /katex >}} and {{< katex >}}Q_R{{< /katex >}} are the forward and reverse sequencing quality scores, respectively, let's define the corresponding log probability of misreading:

{{< katex display=true >}}
\begin{aligned}
q_F &= -\frac{Q_F}{10} \cdot \log(10) \\
q_R &= -\frac{Q_R}{10} \cdot \log(10) 
\end{aligned}
{{< /katex >}}


#### When a match is observed

If the alignment of the forward and reverse reads matches two *X*
nucleotides, it may actually be a true match or a true mismatch.

There are three reasons why it may be a true match:
1. The two *X* nucleotides read are actually *X* nucleotides.
   {{< katex display=true >}}P(case\,1) = (1-e^{q_F}) (1-e^{q_R}){{< /katex >}}. 
2. One nucleotide is read correctly, the second is not, but it's still *X* nucleotides.
   {{< katex display=true >}}P(case\,2) = (1-e^{q_F})\frac{e^{q_R}}{4}+ (1-e^{q_R})\frac{e^{q_F}}{4}{{< /katex >}}. 
3. Neither nucleotide is read correctly, but both are the same true nucleotides.
   {{< katex display=true >}}P(case\,3) = \frac{e^{q_F+q_R}}{4} {{< /katex >}}. 

If a match is observed, the sum of the probabilities of these three cases is the probability of an actual match.

{{< katex display=true >}}
\begin{aligned}
P(match | Observed(match), QF, QR) &= 1 - \frac{3}{4}\left(e^{q_F}+e^{q_R}-e^{q_F+q_R}\right)
\end{aligned}
{{< /katex >}}


#### When a mismatch is observed

If a mismatch *XY* is observed, it can also be an actual match. There are three ways to be an actual match when a mismatch is observed:

1. The *X* nucleotide read is actually *X*, but the *Y* nucleotide is actually an *X*.
   {{< katex display=true >}}P(case\,1') = \frac{(1-e^{q_F})e^{q_R}}{4} {{< /katex >}}
2. The *Y* nucleotide read is actually *Y*, but the *X* nucleotide is actually a *Y*.
   {{< katex display=true >}}P(case\,2') = \frac{(1-e^{q_R})e^{q_F}}{4}{{< /katex >}}
3. Neither nucleotide is actually an *X* or a *Y*, but both are the same true nucleotides.
   {{< katex display=true >}}P(case\,3') = \frac{e^{q_F+q_R}}{4}{{< /katex >}}

If a mismatch is observed, the sum of the probabilities of these three cases is the probability of an actual match.

{{< katex display=true >}}
\begin{aligned}
P(macth | Observed(mismatch), QF, QR) &= \frac{e^{q_F} + e^{q_R} - e^{q_F+q_R}}{4}
\end{aligned}
{{< /katex >}}


### Match and Mismatch Score

{{< obi obipairing >}} uses as the score for match and mismatch the log odd ratio between the probability of being a true match given the observation and the probability of being a true mismatch given the observation.

{{< katex display=true >}}
\begin{aligned}
Score(QF,QR) = \log &P(match | Observed(match|mismatch), QF, QR) - \\
& \log P(mismatch | Observed(match|mismatch), QF, QR) 
\end{aligned}
{{< /katex >}}

With: 

{{< katex display=true >}}
 P(mismatch | Observed(match|mismatch), QF, QR) = 1 - P(match | Observed(match|mismatch), QF, QR)
{{< /katex >}}

This compares the probability of a match given the observation to the probability of a mismatch given the same observation. If the match hypothesis is the more likely, the match score is positive, otherwise it is negative. The score is equal to zero when both the hypotheses are equally probable. On Illumina sequencer, sequencing quality score are ranging from 0 to 40, with 0 an absolute ambiguity {{< katex >}}P_{Error} = 10^{-\frac{Q}{10}}= 1 {{< /katex >}} = 1. 

{{< fig-plotly json="match.json" height="500px" modebar="false" 
    title="Match scores according to the sequencing quality score"
    caption="The score is a log odd ratio between the probability of a match and the probability of a mismatch. Here, when a match is considered during the alignment. If the sequencing quality score is 0 for at least one of the read, the chance of a match is 0.25, when the chance of a mismatch is 0.75. The match score is -1.1. Oppositely when both reads have a sequencing quality score of 40, the chance of a match close to 1, and close 1/10,000 for a mismatch. The match score becomes 8.8."
 >}} 

{{< fig-plotly json="mismatch.json" height="500px" modebar="false" 
    title="Mismatch scores according to the sequencing quality score"
    caption="The score is a log odd ratio between the probability of a match and the probability of a mismatch. Here, when a mismatch is considered during the alignment. If the sequencing quality score is 0 for at least one of the read, the chance of a match is 0.25, when the chance of a mismatch is 0.75. The mismatch score is therefore equal to the match score -1.1. Oppositely when both reads have a sequencing quality score of 40, the chance of a mismatch close to 1, and close 5/100,000 for a match. The mismatch score becomes -9.9."
 >}}

### Gap Penalty
The gap penalty is the penalty applied to the alignment score when the insertion of a gap is considered during the alignment process. It is a negative value. {{< obi obipairing >}} uses a gap penalty estimated as the score of a mismatch between two nucleotides with a quality score of 40, scaled by a constant value (*GapWeight*). This gap weight, which is set to 2 by default, can be specified with the `--gap-pelnalty' option of the {{< obi obipairing >}} command.

{{< katex display=true >}}
\begin{aligned}
Gap\,Penalty = Score(40,40 | Observed(mismatch)) \times GapWeigth
\end{aligned}
{{< /katex >}}
 ## Left and right alignment

 When aligning paired reads, depending on the length of the sequenced amplicon compared to the length of the read, two cases can occur:

1. The amplicon is longer than the read: the read must be aligned to recover the full barcode.

  {{< fig-svg 
      title="Aligning paired reads with an amplicon longer than the read"
      caption="When two paired reads are aligned to recover a full amplicon that is longer than the reads (blue rectangle), it defines two flanking regions (red rectangles) that are not aligned and correspond to the 5' ends of the reads, and an overlap region (green rectangle) at the 3' ends of the reads that must be aligned." 
      height="200"
      width="330"
  >}}
    <!-- Define styles for the arrows -->
    <style>
      .arrow {
        stroke: black;
        stroke-width: 2;
        fill: none;
      }
      .arrow-head {
        stroke: black;
        stroke-width: 2;
        fill: black;
      }
      .text {
        font-family: Arial, sans-serif;
        font-size: 12px;
        fill: black;
      }
      .label {
        font-family: Arial, sans-serif;
        font-size: 10px;
        fill: black;
      }
    </style>

    <rect x="0" y="40" width="330" height="150" fill="white" opacity="0.5" />

    <!-- Overlap region (highlighted) -->
    <rect x="110" y="70" width="100" height="60" fill="green" opacity="0.5" />
    <text class="label" x="140" y="103">overlap</text>

    <!-- not shared parts of the reads -->
    <rect x="10" y="75" width="100" height="10" fill="red" opacity="0.5" />
    <rect x="210" y="115" width="100" height="10" fill="red" opacity="0.5" />

    <!-- the amplicon location -->
    <rect x="10" y="160" width="300" height="15" fill="blue" opacity="0.2" />
    <text class="label" x="140" y="170">amplicon</text>

    <!-- Forward Read (upper arrow) -->
    <path class="arrow" d="M 10 80 L 210 80" />
    <path class="arrow-head" d="M 210 80 L 200 75 L 200 85 Z" />
    <text class="label" x="0" y="85">5'</text>
    <text class="label" x="215" y="85">3'</text>
    <text class="text" x="60" y="65">Forward Read</text>

    <!-- Reverse Read (lower arrow) -->
    <path class="arrow" d="M 110 120 L 310 120" />
    <path class="arrow-head" d="M 110 120 L 120 115 L 120 125 Z" />
    <text class="label" x="100" y="125">3'</text>
    <text class="label" x="315" y="125">5'</text>
    <text class="text" x="160" y="143">Reverse Read</text>
  {{< /fig-svg >}}

2. The amplicon is shorter than the read: each read contains the entire amplicon.

  {{< fig-svg 
      title="Aligning paired reads with an amplicon shorter than the read"
      caption="When two paired reads are aligned to recover a full amplicon that is shorter than the reads (blue rectangle), it defines two flanking regions (red rectangles) that are not aligned and correspond to the 3' ends of the reads, and an overlap region (green rectangle) at the 5' ends of the reads that must be aligned." 
      height="200"
      width="350"
  >}}
    <!-- Define styles for the arrows -->
    <style>
      .arrow {
        stroke: black;
        stroke-width: 2;
        fill: none;
      }
      .arrow-head {
        stroke: black;
        stroke-width: 2;
        fill: black;
      }
      .text {
        font-family: Arial, sans-serif;
        font-size: 12px;
        fill: black;
      }
      .label {
        font-family: Arial, sans-serif;
        font-size: 10px;
        fill: black;
      }
    </style>

    <!-- Overlap region (highlighted) -->
    <rect x="110" y="70" width="100" height="60" fill="green" opacity="0.5" />
    <text class="label" x="140" y="103">overlap</text>

    <!-- not shared parts of the reads -->
    <rect x="210" y="75" width="100" height="10" fill="red" opacity="0.5" />
    <rect x="10" y="115" width="100" height="10" fill="red" opacity="0.5" />

    <!-- the amplicon location -->
    <rect x="110" y="160" width="100" height="15" fill="blue" opacity="0.2" />
    <text class="label" x="140" y="170">amplicon</text>

    <!-- Forward Read (upper arrow) -->
    <path class="arrow" d="M 110 80 L 310 80" />

    <path class="arrow-head" d="M 310 80 L 300 75 L 300 85 Z" />
    <text class="label" x="100" y="85">5'</text>
    <text class="label" x="315" y="85">3'</text>
    <text class="text" x="120" y="65">Forward Read</text>

    <!-- Reverse Read (lower arrow) -->
    <path class="arrow" d="M 10 120 L 210 120" />
    <path class="arrow-head" d="M 10 120 L 20 115 L 20 125 Z" />
    <text class="label" x="0" y="125">3'</text>
    <text class="label" x="215" y="125">5'</text>
    <text class="text" x="120" y="143">Reverse Read</text>
  {{< /fig-svg >}}


In both cases, an exact alignment algorithm based on dynamic programming will consider the red regions as gaps, which in our case must not penalize the alignment score. The best solution for aligning the two reads to find the overlap is to use a semi-global (end-gap free) alignment, but asymmetric. To solve the first case, where the amplicon is longer than the reads, gaps at the *5'* ends of the reads should be free, but gaps at the *3'* ends of the reads should be penalized. To solve the second case, gap penalties should be applied in the opposite direction. In all cases, gaps within the overlap (green part) must be penalized.

### Left Alignment

The left alignment mode corresponds to the first case where the amplicon is longer than the reads. It does not penalize the alignment score for gaps at the *5'* ends of the reads, but does penalize the alignment score for gaps at the *3'* ends of the reads and gaps within the overlap. It is called *left alignment* because the forward read is shifted to the left compared to the reverse read. 

### Right Alignment

The right alignment mode corresponds to the second case where the amplicon is shorter than the reads. It penalizes the alignment score for gaps at the *5'* ends of the reads and gaps within the overlap, but does not penalize the alignment score for gaps at the *3'* ends of the reads. It is called *right alignment* because the forward read is shifted to the right compared to the reverse read. 

### Choosing the alignment method

The normal behavior of {{< obi obipairing >}}, is to decide for left or right alignment mode based on the result of running the [FASTA-derived algorithm]({{% relref "/docs/commands/alignments/obipairing/fasta-like" %}}). If the [FASTA-derived algorithm]({{% relref "/docs/commands/alignments/obipairing/fasta-like" %}}) specifies that forward reads must be shifted to the left, the left alignment mode is used, otherwise the right alignment mode is used. If the [FASTA-derived algorithm]({{% relref "/docs/commands/alignments/obipairing/fasta-like" %}}) is not run (by setting the `--exact-mode' option), both left and right alignments are run and the one that gives the best alignment score is selected. 

## Which parts of the reads the aligned using the exact alignment algorithm?

The default behavior of {{< obi obipairing >}} is to rely on the [FASTA derived algorithm]({{% relref "/docs/commands/alignments/obipairing/fasta-like" %}}) to decide which part of the reads to align. The [FASTA-derived algorithm]({{% relref "/docs/commands/alignments/obipairing/fasta-like" %}}) estimate heuristically the best shift to apply, and therefore, overlapping region of the reads. The exact alignment algorithm is then applied to that overlapping region augmented of {{< katex >}}\Delta{{< /katex >}} nucleotides on each side. By default, the value of {{< katex >}}\Delta{{< /katex >}} is set to 5. The user can change this value by setting the `--delta` option. Doing this extension of the overlapping region allows the exact alignment algorithm to be less sensitive to the approximation done by the [FASTA derived algorithm]({{% relref "/docs/commands/alignments/obipairing/fasta-like" %}}) when determining the overlapping region. 

In the exact mode (option `--exact-mode`), the exact alignment algorithm is applied to the full pair of reads, which increases the computation time.


