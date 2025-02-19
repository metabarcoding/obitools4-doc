---
title: "CSV formatted taxdump"
weight: 1
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# The *CSV* format to describe a taxonomy

{{% obitools4 %}} allow to describe a taxonomy with a CSV file of four columns that must be named as below:

| Field | Description |
|-------|---------------|
| `taxid` | A unique taxonomic identifier composed only of digits (0-9) lower case (a-z) and upper case (A-Z) characters |
| `parent` | The taxid of the parent taxon of the current taxon |
| `scientific_name` | The name used by the *OBITools* as the scientific name of the taxon |
| `taxonomic_rank` | The taxonomic rank of the taxon (*e.g.* species, genus, family, etc.) |

The four columns can be freely ordered.

Some constraints exist on the order of the rows describing the taxa in the CSV file. The first row must contain the taxid of the root taxon (*i.e.* the taxid of the first taxon in the taxonomic hierarchy). The taxid of the parent taxon of the root taxon must be the same as the taxid of the root taxon. For the following taxa, the parent taxon must precede the declaration of a taxon using it as parent.

## Example of a taxonomy formatted in CSV

Following this format, here a four-taxa example with the root taxon, the *Betula* genus and two species *Betula nana* and *Betula pubescence*.

```CSV
taxid,parents,scientific_name,taxonomic_rank
1,1,root,root
2ABC,1,Betula,genus
3,2ABC,Betula nana,species
4,2ABC,Betula pubescens,species
```

The corresponding taxonomic hierarchy is displayed below:

{{< mermaid class="workflow" >}}
graph RL
    1[/"root (1)"\]
    2ABC["Betula (2ABC)"]
    3["Betula nana (3)"]
    4["Betula pubescence (4)"]
    
    2ABC --> 1
    3 --> 2ABC
    4 --> 2ABC 

    classDef root fill:#fff,stroke:#333,stroke-width:2px
    classDef genus fill:#bbf,stroke:#333,stroke-width:1px
    classDef species fill:#dfd,stroke:#333,stroke-width:1px
    
    class 1 root
    class 2ABC genus
    class 3,4 species
{{< /mermaid >}}

That simple format allows to convert easily with a small UNIX script any available taxonomic hierarchy into a format useable by {{% obitools4 %}}.

## Generating a CSV taxonomy file from a larger taxonomy

The {{< obi obitaxonomy >}} command can be used to generate a CSV file from another taxonomy format. The main aim of this command functionality is to extract a subtaxonomy corresponding to a clade from a largest taxonomy.

If it was not already done, a copy of the NCBI taxonomy can be downloaded and saved into the `ncbitaxo.tgz` file.

```bash
obitaxonomy --download-ncbi --out ncbitaxo.tgz
```

{{< obi obitaxonomy >}} is used to identify the taxid of the taxon of interest, here the genus *Betula*.

- The **-t** option allows for specifying the file containing the taxonomy
- The **--rank** option allows for restricting the search to the taxa with the **genus** taxonomic rank
- The **--fixed** option indicates to look for an exact match with the taxon name
- `Betula` is the pattern used to match the taxon name.

The result of the following {{< obi obitaxonomy >}} command is {{% csv %}} formatted, and the piped result can be displayed as a nice table with the `csvlook` command:

```bash
obitaxonomy -t ncbitaxo.tgz \
            --rank genus \
            --fixed Betula \
    | csvlook
```
```
| taxid                     | parent                         | taxonomic_rank | scientific_name |
| ------------------------- | ------------------------------ | -------------- | --------------- |
| taxon:3504 [Betula]@genus | taxon:3514 [Betulaceae]@family | genus          | Betula          |
```

A single taxon meets all the specified criteria. It has the taxid `3504` or `taxon:3504` if we include the taxonomy code.

It is now possible to request {{< obi obitaxonomy >}} for dumping the sub taxonomy corresponding to the `taxon:3504` taxon. The result is saved by redirecting the **stdout** to the file  <a href="betula_subtaxo.csv" download="betula_subtaxo.csv">`betula_subtaxo.csv`</a>.

```bash
obitaxonomy -t ncbitaxo.tgz \
            --dump taxon:3504 > betula_subtaxo.csv
```

As usual with {{< obi obitaxonomy >}} the result is {{% csv %}} formatted. That allows for using the `csvtk dim` UNIX command from [csvtk program](https://github.com/shenwei356/csvtk) to display the number of columns (four as expected) and of rows, here *131* taxa. Once again `csvlook` is used to  print out the result in the form of a nice ASCII table:


```bash
csvtk dim betula_subtaxo.csv \
    | csvlook
```
```
| file               | num_cols | num_rows |
| ------------------ | -------- | -------- |
| betula_subtaxo.csv |        4 |      131 |
```

```bash
head -30 betula_subtaxo.csv \
    | csvlook
```
```
| taxid                                         | parent                                    | taxonomic_rank | scientific_name       |
| --------------------------------------------- | ----------------------------------------- | -------------- | --------------------- |
| taxon:1 [root]@no rank                        | taxon:1 [root]@no rank                    | no rank        | root                  |
| taxon:131567 [cellular organisms]@no rank     | taxon:1 [root]@no rank                    | no rank        | cellular organisms    |
| taxon:2759 [Eukaryota]@superkingdom           | taxon:131567 [cellular organisms]@no rank | superkingdom   | Eukaryota             |
| taxon:33090 [Viridiplantae]@kingdom           | taxon:2759 [Eukaryota]@superkingdom       | kingdom        | Viridiplantae         |
| taxon:35493 [Streptophyta]@phylum             | taxon:33090 [Viridiplantae]@kingdom       | phylum         | Streptophyta          |
| taxon:131221 [Streptophytina]@subphylum       | taxon:35493 [Streptophyta]@phylum         | subphylum      | Streptophytina        |
| taxon:3193 [Embryophyta]@clade                | taxon:131221 [Streptophytina]@subphylum   | clade          | Embryophyta           |
| taxon:58023 [Tracheophyta]@clade              | taxon:3193 [Embryophyta]@clade            | clade          | Tracheophyta          |
| taxon:78536 [Euphyllophyta]@clade             | taxon:58023 [Tracheophyta]@clade          | clade          | Euphyllophyta         |
| taxon:58024 [Spermatophyta]@clade             | taxon:78536 [Euphyllophyta]@clade         | clade          | Spermatophyta         |
| taxon:3398 [Magnoliopsida]@class              | taxon:58024 [Spermatophyta]@clade         | class          | Magnoliopsida         |
| taxon:1437183 [Mesangiospermae]@clade         | taxon:3398 [Magnoliopsida]@class          | clade          | Mesangiospermae       |
| taxon:71240 [eudicotyledons]@clade            | taxon:1437183 [Mesangiospermae]@clade     | clade          | eudicotyledons        |
| taxon:91827 [Gunneridae]@clade                | taxon:71240 [eudicotyledons]@clade        | clade          | Gunneridae            |
| taxon:1437201 [Pentapetalae]@clade            | taxon:91827 [Gunneridae]@clade            | clade          | Pentapetalae          |
| taxon:71275 [rosids]@clade                    | taxon:1437201 [Pentapetalae]@clade        | clade          | rosids                |
| taxon:91835 [fabids]@clade                    | taxon:71275 [rosids]@clade                | clade          | fabids                |
| taxon:3502 [Fagales]@order                    | taxon:91835 [fabids]@clade                | order          | Fagales               |
| taxon:3514 [Betulaceae]@family                | taxon:3502 [Fagales]@order                | family         | Betulaceae            |
| taxon:3504 [Betula]@genus                     | taxon:3514 [Betulaceae]@family            | genus          | Betula                |
| taxon:361421 [Betula middendorffii]@species   | taxon:3504 [Betula]@genus                 | species        | Betula middendorffii  |
| taxon:1603696 [Betula austrosinensis]@species | taxon:3504 [Betula]@genus                 | species        | Betula austrosinensis |
| taxon:216993 [Betula fruticosa]@species       | taxon:3504 [Betula]@genus                 | species        | Betula fruticosa      |
| taxon:361422 [Betula ovalifolia]@species      | taxon:3504 [Betula]@genus                 | species        | Betula ovalifolia     |
| taxon:253223 [Betula uber]@species            | taxon:3504 [Betula]@genus                 | species        | Betula uber           |
| taxon:1685986 [Betula megrelica]@species      | taxon:3504 [Betula]@genus                 | species        | Betula megrelica      |
| taxon:1685997 [Betula tianschanica]@species   | taxon:3504 [Betula]@genus                 | species        | Betula tianschanica   |
| taxon:312792 [Betula raddeana]@species        | taxon:3504 [Betula]@genus                 | species        | Betula raddeana       |
| taxon:1685980 [Betula bomiensis]@species      | taxon:3504 [Betula]@genus                 | species        | Betula bomiensis      |
```

From **taxon:1** (the root taxon) to **taxon:3504** (the taxon of interest *Betula*), the command {{< obi obitaxonomy >}} has dumped the taxonomic path classifying the *Betula* genus. The following taxa correspond to the species belonging to the *Betula* genus.

This new taxonomy saved as a CSV file <a href="betula_subtaxo.csv" download="betula_subtaxo.csv">`betula_subtaxo.csv`</a> can be used by any {{% obitools %}} as a taxonomy.
For example, {{< obi obitaxonomy >}} can use it to identify the taxid of *Betula megrelica*:

```bash
obitaxonomy -t betula_subtaxo.csv "Betula megrelica" \
    | csvlook
```
```
| taxid                                    | parent                    | taxonomic_rank | scientific_name  |
| ---------------------------------------- | ------------------------- | -------------- | ---------------- |
| taxon:1685986 [Betula megrelica]@species | taxon:3504 [Betula]@genus | species        | Betula megrelica |
```

or to just dump the subtree of the *Betula nana* species:

```bash
obitaxonomy -t betula_subtaxo.csv \
            --dump taxon:216990 \
    | csvlook
```
```
| taxid                                                   | parent                                    | taxonomic_rank | scientific_name              |
| ------------------------------------------------------- | ----------------------------------------- | -------------- | ---------------------------- |
| taxon:1 [root]@no rank                                  | taxon:1 [root]@no rank                    | no rank        | root                         |
| taxon:131567 [cellular organisms]@no rank               | taxon:1 [root]@no rank                    | no rank        | cellular organisms           |
| taxon:2759 [Eukaryota]@superkingdom                     | taxon:131567 [cellular organisms]@no rank | superkingdom   | Eukaryota                    |
| taxon:33090 [Viridiplantae]@kingdom                     | taxon:2759 [Eukaryota]@superkingdom       | kingdom        | Viridiplantae                |
| taxon:35493 [Streptophyta]@phylum                       | taxon:33090 [Viridiplantae]@kingdom       | phylum         | Streptophyta                 |
| taxon:131221 [Streptophytina]@subphylum                 | taxon:35493 [Streptophyta]@phylum         | subphylum      | Streptophytina               |
| taxon:3193 [Embryophyta]@clade                          | taxon:131221 [Streptophytina]@subphylum   | clade          | Embryophyta                  |
| taxon:58023 [Tracheophyta]@clade                        | taxon:3193 [Embryophyta]@clade            | clade          | Tracheophyta                 |
| taxon:78536 [Euphyllophyta]@clade                       | taxon:58023 [Tracheophyta]@clade          | clade          | Euphyllophyta                |
| taxon:58024 [Spermatophyta]@clade                       | taxon:78536 [Euphyllophyta]@clade         | clade          | Spermatophyta                |
| taxon:3398 [Magnoliopsida]@class                        | taxon:58024 [Spermatophyta]@clade         | class          | Magnoliopsida                |
| taxon:1437183 [Mesangiospermae]@clade                   | taxon:3398 [Magnoliopsida]@class          | clade          | Mesangiospermae              |
| taxon:71240 [eudicotyledons]@clade                      | taxon:1437183 [Mesangiospermae]@clade     | clade          | eudicotyledons               |
| taxon:91827 [Gunneridae]@clade                          | taxon:71240 [eudicotyledons]@clade        | clade          | Gunneridae                   |
| taxon:1437201 [Pentapetalae]@clade                      | taxon:91827 [Gunneridae]@clade            | clade          | Pentapetalae                 |
| taxon:71275 [rosids]@clade                              | taxon:1437201 [Pentapetalae]@clade        | clade          | rosids                       |
| taxon:91835 [fabids]@clade                              | taxon:71275 [rosids]@clade                | clade          | fabids                       |
| taxon:3502 [Fagales]@order                              | taxon:91835 [fabids]@clade                | order          | Fagales                      |
| taxon:3514 [Betulaceae]@family                          | taxon:3502 [Fagales]@order                | family         | Betulaceae                   |
| taxon:3504 [Betula]@genus                               | taxon:3514 [Betulaceae]@family            | genus          | Betula                       |
| taxon:216990 [Betula nana]@species                      | taxon:3504 [Betula]@genus                 | species        | Betula nana                  |
| taxon:2820156 [Betula nana subsp. tundrarum]@subspecies | taxon:216990 [Betula nana]@species        | subspecies     | Betula nana subsp. tundrarum |
| taxon:717482 [Betula nana subsp. exilis]@subspecies     | taxon:216990 [Betula nana]@species        | subspecies     | Betula nana subsp. exilis    |
| taxon:3080005 [Betula nana var. macrophylla]@varietas   | taxon:216990 [Betula nana]@species        | varietas       | Betula nana var. macrophylla |
| taxon:1623466 [Betula nana subsp. nana]@subspecies      | taxon:216990 [Betula nana]@species        | subspecies     | Betula nana subsp. nana      |
```

Using an appropriate sub-taxonomy can significantly reduce the time needed for an {{% obitools %}} to read the taxonomy, compared with the time needed to read the entire taxonomy.