---
title: "Exact alignment"
weight: 2
---

## Exact alignment of paired reads

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
      title="Aligning paired reads with a amplicon shorter than the read"
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


In both cases, an exact alignment algorithm based on dynamic programming will consider the red regions as gaps, which in our case must not penalize the alignment score. The best solution for aligning the two reads to find the overlap is to use a semi-global alignment (end-gap free), but asymmetrically. To solve the first case, where the amplicon is longer than the reads, gaps at the *5'* ends of the reads should be free, but gaps at the *3'* ends of the reads should be penalized. To solve the second case, gap penalties should be applied in the opposite direction. In all cases, gaps within the overlap (green part) must be penalized.

## Scoring system

An alignment algorithm needs to define:

- A bonus score for the match between two nucleotides (same nucleotide at the corresponding position)
- A penalty for a mismatch between two nucleotides (different nucleotides at the corresponding position)
- A penalty for the insertion or deletion of a nucleotide (gap) in one of the two reads.

The bonus score and the mismatch penalty are estimated from the sequencing quality scores {{< katex >}}Q_F{{< /katex >}} and {{< katex >}}Q_R{{< /katex >}} of the considered two nucleotides on the forward and reverse reads, respectively. The idea is that the quality score is related to the probability of misreading.

{{< katex display=true >}}
P(misreading) = 10^{-\frac{Q}{10}}
{{< /katex >}}

Thus, if the sequencer reads a nucleotide *X* at position *i*, where *X* represents one of the nucleotides *A*, *C*, *G*, or *T*, with a quality score *Q*, there is a probability {{< katex >}}P(truth = X) = 1 - 10^{-\frac{Q}{10}}{{< /katex >}} that *X* is actually a *X* nucleotide, and a probability {{< katex >}}P(truth \neq X) = 10^{-\frac{Q}{10}}{{< /katex >}} that *X* is actually one of the other three nucleotides. If we assume the equivalence of the four nucleotides, the probability that *X* is one of the three other nucleotides is 
{{< katex display=true >}}P_F = \frac{10^{-\frac{Q}{10}}}{3} {{< /katex >}}

### Probability of a match

#### When a match is observed

Thus when the alignment of the forward and the reverse reads pairs two *X* nucleotides, it can be actually a true match or a mistmatch.
There are two ways of being an actual match:

1. Both nucleotides are actually *X* nucleotides.
   {{< katex display=true >}}P(case\,1) = 1 - 10^{-\frac{Q_F}{10}} - 10^{-\frac{Q_R}{10}} + 10^{-\frac{Q_F + Q_R}{10}}{{< /katex >}}. 
2. None of the nucleotides is actually *X* nucleotides but both are the same true nucleotides.
   {{< katex display=true >}}P(case\,2) = \frac{10^{-\frac{Q_F + Q_R}{10}}}{3} {{< /katex >}}. 

The probability of an actual match when a match is observed is the sum of the probabilities of the two cases.

{{< katex display=true >}}P(match | Obs(match)) = 1 - 10^{-\frac{Q_F}{10}} - 10^{-\frac{Q_R}{10}} + \frac{4}{3} \cdot 10^{-\frac{Q_F + Q_R}{10}} {{< /katex >}}

#### When a mismatch is observed

When a mismatch XY is observed, it can also be actually a match. They are three ways of being an actual match when a mismatch is observed:

1. The X nucleotide is actually *X* but the Y nucleotide is actually *X*
   {{< katex display=true >}}P(case\,1') = \frac{10^{-\frac{Q_F}{10}} - 10^{-\frac{Q_F + Q_R}{10}}}{3}{{< /katex >}}
2. The Y nucleotide is actually *Y* but the X nucleotide is actually *Y*
   {{< katex display=true >}}P(case\,2') = \frac{10^{-\frac{Q_R}{10}} - 10^{-\frac{Q_F + Q_R}{10}}}{3}{{< /katex >}}
3. None of the nucleotides is actually *X* or *Y* but both are the same true nucleotides.
   {{< katex display=true >}}P(case\,3') = \frac{2}{9} \cdot 10^{-\frac{Q_F + Q_R}{10}}{{< /katex >}}

The probability of an actual match when a mismatch is observed is the sum of the probabilities of the three cases.

{{< katex display=true >}}
P(macth | Obs(mismatch)) = \frac{3 \cdot 10^{-\frac{Q_F}{10}} + 3 \cdot 10^{-\frac{Q_R}{10}} - 4 \cdot 10^{-\frac{Q_F + Q_R}{10}}}{9}
{{< /katex >}}


 \frac{10^{-\frac{Q_F}{10}} - 10^{-\frac{Q_F + Q_R}{10}}}{3} +  \frac{10^{-\frac{Q_R}{10}} - 10^{-\frac{Q_F + Q_R}{10}}}{3} + \frac{2}{9} \cdot 10^{-\frac{Q_F + Q_R}{10}}