---
title: About
type: about
weight: 10
---

## What are OBITools4?

The development of {{< gloentry "OBITools" >}} started at {{< gloentry LECA >}} ([University of Grenoble](https://www.univ-grenoble-alpes.fr/)) in the early 2000s, together with the development of DNA metabarcoding methods in the same lab. The idea behind the OBITools project was to provide a set of UNIX command line tools that mimic standard UNIX shell commands like `grep`, `uniq` or `wc`, but work on DNA sequence files. Unlike standard UNIX tools, where the processing unit is a line of text, with OBITools the processing unit is a sequence record. In addition, some commands implementing algorithms specific to the processing of DNA metabarcoding data have been added, making OBITools, one of the widely used sequence processing tools available on UNIX-like systems, suitable for the analysis of DNA metabarcoding data.

{{< gloentry "OBITools" >}} were originally developed in Python version 2, with some computationally intensive code written in C. They were suitable for the volumes of DNA metabarcoding data generated by 454 pyrosequencing in the early 2000s. With the advent of Solexa and Illumina sequencers, data sizes have increased considerably, making OBITools less efficient. Coupled with the move to Python version 3, OBITools became difficult to implement.

{{< gloentry "OBITools4" >}} is the latest version of {{< gloentry "OBITools" >}}. Oppositely to the OBITools3, {{< gloentry "OBITools4" >}} follow the same philosophy as OBITools1 and OBITools2. {{< gloentry "OBITools4" >}} are a complete rewrite of the OBITools code in [GO](https://go.dev/), an efficient compiled programming language. This also allows parallelization of the code to take advantage of the multi-core architectures of today's computers. 

The most important thing to understand about {{< gloentry "OBITools">}} is that it is not a pipeline for processing DNA metabarcoding data. {{< gloentry "OBITools" >}} is a set of tools that allows you to easily build your own pipeline for processing your DNA metabarcoding data according to your biological questions.

