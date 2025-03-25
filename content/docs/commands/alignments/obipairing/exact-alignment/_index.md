---
title: "Exact alignment"
weight: 2
params:
  plotly: true
---
# Exact alignment of paired reads

The {{< obi obipairing >}} command uses an exact alignment algorithm based on dynamic programming to finalize the alignment between forward and reverse reads. It corresponds to a semi-global alignment (end-gap free) algorithm but asymmetric, in the sense that the penalization of the gap is not done in the same way at both extremities of the read (see below a dedicated [section](./#left-right)). 

## Scoring system

The alignment algorithm used by {{< obi obipairing >}} relies on the following scoring principles :

- **Match**: A positive score ({{< katex >}} score > 0 {{< /katex >}}) is assigned when two nucleotides at the same position in the alignment are identical. Thus, the accumulation of matches during the alignment process will increase the alignment score.
- **Mismatch**: A negative score ({{< katex >}} score < 0 {{< /katex >}}) is assigned when two nucleotides at the same position in the alignment are different. Thus, the accumulation of mismatches during the alignment process will decrease the alignment score.
- **Gap**: A negative score ({{< katex >}} score < 0 {{< /katex >}}) is assigne for nucleotide insertion or deletion in one of the two reads. Thus, the accumulation of insertions or deletions during the alignment process will decrease the alignment score.

The scores numerical values are then based on the sequencing quality scores {{< katex >}}Q_F{{< /katex >}} and {{< katex >}}Q_R{{< /katex >}} of the nucleotides from the forward and reverse reads, respectively. The quality score {{< katex >}}Q{{< /katex >}} represents the likelihood of a base-calling error, i.e. that the sequencer assigned (or "called") the incorrect base to (for) a given chromatogram peak, or more exactly, the probability {{< katex >}}P(X\, \text{is unknown}) {{< /katex >}} that the base called, *X*, is actually unknown:

{{< katex display=true >}}
P(X\, \text{is unknown}) = 10^{-\frac{Q}{10}}
{{< /katex >}}

If the base called by the sequencer is *X* at position *i*, where *X* is one of the nucleotides *A*, *C*, *G*, or *T*, with a quality score *Q*, the probability {{< katex >}}P(truth = X) {{< /katex >}} that the base called by the sequencer, *X*, is actually *X* is: 

{{< katex display=true >}}P(truth = X) = 1 - 10^{-\frac{Q}{10}}{{< /katex >}} 

The complementary probability corresponds to the case where the nucleotide corresponding to *X* is unknown. Assuming equal probability of each of the four nucleotides (A, C, G, T), the probability that the base called, *X*, is in fact *Y*, one of the four possible nucleotides, is: 

{{< katex display=true >}}P(Y | Obs(X)) = \frac{10^{-\frac{Q}{10}}}{4} {{< /katex >}}


### Estimating the probability of a true match

Let's then define the corresponding log probability of the base-calling uncertainty, where {{< katex >}}Q_F{{< /katex >}} and {{< katex >}}Q_R{{< /katex >}} are the forward and reverse sequencing quality scores, respectively:

{{< katex display=true >}}
\begin{aligned}
q_F &= -\frac{Q_F}{10} \cdot \log(10) \\
q_R &= -\frac{Q_R}{10} \cdot \log(10) 
\end{aligned}
{{< /katex >}}


#### When a match is observed

If an alignment between a forward and a reverse read shows two *X* nucleotides at the same position, it could represent either a genuine match, or a true mismatch.

There are three reasons why it could be a true match:
1. For both reads, the two base calls, *X*, are actually the nucleotide *X*.
   {{< katex display=true >}}P(case\,1) = (1-e^{q_F}) (1-e^{q_R}){{< /katex >}}. 
2. For one of the read, the base call, *X*, is correct, while for the second read, the base call is correct but its likelyhood is low.
   {{< katex display=true >}}P(case\,2) = (1-e^{q_F})\frac{e^{q_R}}{4}+ (1-e^{q_R})\frac{e^{q_F}}{4}{{< /katex >}}. 
3. For both reads, base calls are incorrect, but both correspond to the same nucleotide.
   {{< katex display=true >}}P(case\,3) = \frac{e^{q_F+q_R}}{4} {{< /katex >}}. 

When a match is observed, the probability of it being a true match is the sum of the probabilities of these three cases.

{{< katex display=true >}}
\begin{aligned}
P(match | Observed(match), QF, QR) &= 1 - \frac{3}{4}\left(e^{q_F}+e^{q_R}-e^{q_F+q_R}\right)
\end{aligned}
{{< /katex >}}


#### When a mismatch is observed

Even if a mismatch *XY* is observed, it can still correspond to a true match. There are three explainations for this:

1. The base call *X* is actually the nucleotide *X*, but the base call *Y* is actually the nucleotide *X*.
   {{< katex display=true >}}P(case\,1') = \frac{(1-e^{q_F})e^{q_R}}{4} {{< /katex >}}
2. The base call *Y* is actually the nucleotide *Y*, but the base call *X* is actually the nucleotide *Y*.
   {{< katex display=true >}}P(case\,2') = \frac{(1-e^{q_R})e^{q_F}}{4}{{< /katex >}}
3. Neither of the base calls are *X* or *Y*, but both correspond the same nucleotide.
   {{< katex display=true >}}P(case\,3') = \frac{e^{q_F+q_R}}{4}{{< /katex >}}

When a mismatch is observed, the probability of it to be instead a genuine match is thus the sum of the probabilities of these three cases.

{{< katex display=true >}}
\begin{aligned}
P(match | Observed(mismatch), QF, QR) &= \frac{e^{q_F} + e^{q_R} - e^{q_F+q_R}}{4}
\end{aligned}
{{< /katex >}}


### Match and Mismatch Score

At each position of the alignment, {{< obi obipairing >}} assign it a score (i.e. a score for match and mismatch) that corresponds to the log odd ratio between the probability of being a true match given the observation and the probability of being a true mismatch given the observation.

{{< katex display=true >}}
\begin{aligned}
Score(QF,QR) = \log &P(match | Observed(match|mismatch), QF, QR) - \\
& \log P(mismatch | Observed(match|mismatch), QF, QR) 
\end{aligned}
{{< /katex >}}

With: 

{{< katex display=true >}}
 P(mismatch | Observed(match|mismatch), QF, QR) = \\
 1 - P(match | Observed(match|mismatch), QF, QR)
{{< /katex >}}

This compares the probability of a match given the observation to the probability of a mismatch given the same observation. If the match hypothesis is the most likely, the match score is positive, otherwise it is negative. The score is equal to zero when both the hypotheses are equally probable. On Illumina sequencers, the sequencing quality score {{< katex >}}Q{{< /katex >}} range from 0 to 40, with 0 being an absolute ambiguity {{< katex >}}P_{Error} = 10^{-\frac{0}{10}}= 1 {{< /katex >}}. 

{{< fig-plotly json="match.json" height="500px" modebar="false" 
    title="Match scores as a function of forward and reverse reads sequencing quality scores"
    caption="The score is calculated as the log odds ratio of the probability of a true match vs. a true mismatch. When a match is observed in the alignment, if the sequencing quality score is 0 for at least one of the two reads, the probability of a match is 0.25, and the probability of a mismatch is 0.75. The resulting match score is -1.1. In contrast, when both reads have a sequencing quality score of 40, the probability of a match approaches 1, while the probability of a mismatch approach 1/10,000, resulting in a match score of 8.8."
 >}} 

{{< fig-plotly json="mismatch.json" height="500px" modebar="false" 
    title="Mismatch scores as a function of forward and reverse reads sequencing quality scores"
    caption="The score is calculated as the log odd ratio of the probability of a true match vs. a true mismatch. When a mismatch is observed in the alignment, if the sequencing quality score is 0 for at least one of the two reads, the probability of a match is 0.25, and the probability of a mismatch is 0.75. The resulting mismatch score is therefore equal to the match score: -1.1. In contrast, when both reads have a sequencing quality score of 40, the chance of a mismatch close to 1, while the probability of a match approach 5/100,000, resulting in a mismatch score pf -9.9."
 >}}

### Gap Penalty
The gap penalty is a negative value applied to the alignment score when a gap is inserted during the alignment process. {{< obi obipairing >}} estimates this penalty as the score of a mismatch between two nucleotides with a quality score of 40, scaled by a constant value (*GapWeight*). This gap weight, which is set to 2 by default, can be modified with the `--gap-pelnalty' option of the {{< obi obipairing >}} command.

{{< katex display=true >}}
\begin{aligned}
Gap\,Penalty = Score(40,40 | Observed(mismatch)) \times GapWeigth
\end{aligned}
{{< /katex >}}


 ## Left and right alignments {#left-right}

 When aligning paired reads, two scenarios arise depending on the amplicon and read lengths:

1. The amplicon is longer than the read. In that case, the forward and reverse reads must be aligned to reconstruct the full barcode.

  {{< fig-svg 
      title="Aligning paired reads when the amplicon is longer than the read"
      caption="When aligning two paired reads (arrows) to reconstruct a full-length amplicon that is longer than the reads (blue rectangle), the alignment is done in the reads 3' ends (green rectangle), leaving two flanking, unaligned regions (red rectangles) located in the reads 5' ends." 
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

2. The amplicon is shorter than the read. In that case, each read contains the entire amplicon.

  {{< fig-svg 
      title="Aligning paired reads when the amplicon shorter than the read"
      caption="When aligning two paired reads (arrows) to reconstruct a full-length amplicon that is shorter than the reads (blue rectangle), the alignment is done in the reads 5’ ends (green rectangle), leaving two flanking, unaligned regions (red rectangles) located in the reads 3’ ends" 
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


For both scenarios, an exact alignment algorithm based on dynamic programming will consider the red regions as gaps. However, when paring paired-end reads, these gaps should not penalize the alignment score. The alternative to find the paired-end reads overlap is to use a semi-global (i.e. end-gap free) alignment, but asymmetric, since depending on the above scenario, gap penality should be applied only on one of the two ends of the reads. In the first case scenario, gap penality should not apply at the reads *5'* ends but apply at the reads *3'* ends. In the second case scenario, gap penalties should apply in the opposite direction. And in both cases, gaps insertion within the overlapping region (green part) should be penalized.

### Left Alignment

The left alignment mode corresponds to the first case scenario, where the amplicon is longer than the reads. It does not penalize the alignment score for gaps introduced at the reads *5'* ends, but does penalize the alignment score for gaps introduced in the reads *3'* ends or within the paired-end reads overlapping region. It is referred to as a *left alignment* because the forward read is shifted to the left compared to the reverse read. 

### Right Alignment

The right alignment mode corresponds to the second case scenario, where the amplicon is shorter than the reads. It penalizes the alignment score for gaps introduced in the reads *5'* ends and within the reads overlapping region, but does not penalize the alignment score for gaps introduced in the reads *3'* ends . It is referred to as a *right alignment* because the forward read is shifted to the right compared to the reverse read. 

### Choosing the alignment method

The default behavior of {{< obi obipairing >}} is to choose between the left or right alignment mode depending on the result of a draft alignment obtained with the [FASTA-derived algorithm]({{% relref "/docs/commands/alignments/obipairing/fasta-like" %}}). If the [FASTA-derived algorithm]({{% relref "/docs/commands/alignments/obipairing/fasta-like" %}}) specifies that forward reads must be shifted to the left, the left alignment mode is used, otherwise the right alignment mode is used. If the [FASTA-derived algorithm]({{% relref "/docs/commands/alignments/obipairing/fasta-like" %}}) is not run (by setting the `--exact-mode' option), both left and right alignments are run and the one that gives the best alignment score is selected. 

## Which part of the read is aligned when using the exact alignment algorithm?

The default behavior of {{< obi obipairing >}} is to rely on the [FASTA-derived algorithm]({{% relref "/docs/commands/alignments/obipairing/fasta-like" %}}) to decide which part of the reads to align. The [FASTA-derived algorithm]({{% relref "/docs/commands/alignments/obipairing/fasta-like" %}}) estimate heuristically the best shift to apply, and therefore, the position of the overlapping region. The exact alignment algorithm is then applied to that overlapping region augmented of {{< katex >}}\Delta{{< /katex >}} nucleotides on each side. By default, the value of {{< katex >}}\Delta{{< /katex >}} is set to 5. The user can change this value by setting the `--delta` option. Doing this extension of the overlapping region allows the exact alignment algorithm to be less sensitive to the approximation done by the [FASTA-derived algorithm]({{% relref "/docs/commands/alignments/obipairing/fasta-like" %}}) when determining the overlapping region. 

In the exact mode (option `--exact-mode`), the exact alignment algorithm is applied to the full pair of reads, which increases the computation time.


