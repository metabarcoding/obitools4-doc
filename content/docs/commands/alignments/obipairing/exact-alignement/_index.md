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
    <rect x="150" y="70" width="100" height="60" fill="green" opacity="0.5" />
    <text class="label" x="180" y="103">overlap</text>

    <!-- not shared parts of the reads -->
    <rect x="50" y="75" width="100" height="10" fill="red" opacity="0.5" />
    <rect x="250" y="115" width="100" height="10" fill="red" opacity="0.5" />

    <!-- the amplicon location -->
    <rect x="50" y="160" width="300" height="15" fill="blue" opacity="0.2" />
    <text class="label" x="180" y="170">amplicon</text>

    <!-- Forward Read (upper arrow) -->
    <path class="arrow" d="M 50 80 L 250 80" />
    <path class="arrow-head" d="M 250 80 L 240 75 L 240 85 Z" />
    <text class="label" x="40" y="85">5'</text>
    <text class="label" x="255" y="85">3'</text>
    <text class="text" x="100" y="65">Forward Read</text>

    <!-- Reverse Read (lower arrow) -->
    <path class="arrow" d="M 150 120 L 350 120" />
    <path class="arrow-head" d="M 150 120 L 160 115 L 160 125 Z" />
    <text class="label" x="140" y="125">3'</text>
    <text class="label" x="355" y="125">5'</text>
    <text class="text" x="200" y="143">Reverse Read</text>
  {{< /fig-svg >}}

2. The amplicon is shorter than the read: each read contains the entire amplicon.

  {{< fig-svg 
      title="Aligning paired reads with a amplicon shorter than the read"
      caption="When two paired reads are aligned to recover a full amplicon that is shorter than the reads (blue rectangle), it defines two flanking regions (red rectangles) that are not aligned and correspond to the 3' ends of the reads, and an overlap region (green rectangle) at the 5' ends of the reads that must be aligned." 
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
    <rect x="150" y="70" width="100" height="60" fill="green" opacity="0.5" />
    <text class="label" x="180" y="103">overlap</text>

    <!-- not shared parts of the reads -->
    <rect x="250" y="75" width="100" height="10" fill="red" opacity="0.5" />
    <rect x="50" y="115" width="100" height="10" fill="red" opacity="0.5" />

    <!-- the amplicon location -->
    <rect x="150" y="160" width="100" height="15" fill="blue" opacity="0.2" />
    <text class="label" x="180" y="170">amplicon</text>

    <!-- Forward Read (upper arrow) -->
    <path class="arrow" d="M 150 80 L 350 80" />
    <path class="arrow-head" d="M 350 80 L 340 75 L 340 85 Z" />
    <text class="label" x="140" y="85">5'</text>
    <text class="label" x="355" y="85">3'</text>
    <text class="text" x="160" y="65">Forward Read</text>

    <!-- Reverse Read (lower arrow) -->
    <path class="arrow" d="M 50 120 L 250 120" />
    <path class="arrow-head" d="M 50 120 L 60 115 L 60 125 Z" />
    <text class="label" x="40" y="125">3'</text>
    <text class="label" x="255" y="125">5'</text>
    <text class="text" x="160" y="143">Reverse Read</text>
  {{< /fig-svg >}}
