---
title: "DNA Patterns"
weight: 20
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# DNA Patterns

DNA patterns are useful for describing short DNA sequences like oligonucleotides. They are used by several {{< gloentry "OBITools" >}} like {{< obi obimultiplex >}}, {{< obi obipcr >}} or {{< obi obigrep >}}. The advantage of using DNA patterns over classical regular expressions is that they can be matched with errors. Allowed errors can be simple mismatches, or mismatches and insertions/deletions.

## Syntax of a DNA Pattern

- Patterns are limited to sequences up to 63 bases long.
- As all DNA sequences, they are represented from the 5' end to the 3' end.
- Each base is represented by a single letter (A, C, G, T).
- IUPAC codes can be used to represent ambiguous bases (N, M, K, R, Y, S, W, B, D, H, V, N, see table below).
- Ambiguous positions can also be denoted by a range of base characters (*i.e.* `ATGC`) surrounded by square brackets (`[]`) : `[ATC]`.
- A range of bases can negate by prefixing it with a `!` : `[!AC]`.
- Patterns do not allow for ambiguity on the number of occurrences of a base.
- Positions where errors are not allowed, are denoted by a sharp (`#`) symbol after the base.
- Patterns are case unsensitive.

>[!EXAMPLE]
> A DNA pattern corresponding to the forward primer of the *Euka02* marker with no errors allowed
> at the two last bases on the 3' end:
>
> `TTTGTCTGSTTAATTSC#G#`

>[!EXAMPLE]
>
> The same pattern using base ranges for indicating the second `S` ambiguity:
>
> `TTTGTCTGSTTAATT[CG]C#G#`

## IUPAC Codes for Ambiguous Bases

{{< iupac >}}