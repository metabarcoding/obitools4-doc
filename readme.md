# Note to the OBITools documentation writers

## The public version of the OBITools4 documentation

https://metabarcoding.github.io/obitools4-doc/

## Getting a copy of the OBITools4 documentation

```bash
git clone --recurse-submodules \
          --remote-submodules  \
          -j 8  \
          git@github.com:metabarcoding/obitools4-doc.git
```

## The editor

I recommend to use VSCodium, all installation instructions are available on https://vscodium.com/.

### VsCode extensions

- [Hugo Language and Syntax Support](https://marketplace.visualstudio.com/items?itemName=budparr.language-hugo-vscode)


### Testing the documentation on the local machine

```bash
hugo server --buildDrafts
```


## Some commands to help you edit the documentation

### The hugo shortcodes

- To cite an obitool, use the following format: `{{< obi command_name >}}`
  
  ```md
  {{< obi obigrep >}}
  ```

  That shortcode use the `data/commands.yaml` to retrieve the information
  related to an obitool.
- To display the IUPAC DNA nucleotide abbreviations table: `{{< iupac >}}`
  
#### Shortcodes related to the obitools options

- To document an option : `{{< cmd-option name="opt_name" short="opt_short" param="param_type" >}}`
  The documentation of the option 
  `{{< /cmd-option >}}`

  - `name` is the name of the option.
  - `short` is the short name of the option (one letter only).
  - `param` is the type of the option parametter (*e.g*: `STRING`, `INT`, `FLOAT`, `BOOL`, `LIST`).

  ```md
  {{< cmd-option name="script" short="S" param="STRING" >}}
  The script to execute.
  {{< /cmd-option >}}
  ```

- Preconfigured sets of options: 
    - common options: `{{< option-sets/common >}}`
  
      List all the options shared by all the OBITools.

    - input options: `{{< option-sets/input >}}`
  
      List all the options related to the format of the input files.

    - output options: `{{< option-sets/output >}}`
  
      List all the options related to the output of the OBITools.

    - selection options: `{{< option-sets/selection >}}`
  
      List all the options related to the selection of a subset of sequence entries from the input data.
      
### Rebuild the bibliography file 

```bash
pandoc assets/bibliography/bibliography.bib -t csljson -o assets/bibliography/bibliography.json
```
