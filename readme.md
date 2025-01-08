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

### Add a new content

To add a new page, use the following command:

```bash
hugo new content content/docs/new_page.md
```

#### Add a new command description page

The following command will create a new page in the `content/docs/commands` folder,
containing a pre-filled template for the command description (here `obiconvert`).

```bash
hugo new content --kind command content/docs/commands/obiconvert.md
```

### The hugo shortcodes

- To cite an obitool, use the following format: `{{< obi command_name >}}`
  
  ```md
  {{< obi obigrep >}}
  ```

  That shortcode use the `data/commands.yaml` to retrieve the information
  related to an obitool.

- To refer to a glossary term, use the following format: `{{< gloentry "term" >}}`

  Glossary entries are stored in the `data/termbase.yaml` file.

  Two categories of glossary entries are available:
  - `term`: defined a term frequently used in the documentation
    - `definition`: the definition of the term.
    - `link`: an URL to a page with more information about the term.
  
  - `abbr`: the glossary entries related to the OBI.
    - `definition`: the definition of the abbreviation.
    - `link`: an URL to a page with more information about the abbreviated term.

  ```md
  {{< gloentry "OBITools" >}}
  ```

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
      
### Admonitions

```
> [!NOTIFY]
> System notification: Your password will expire in 30 days.
```

Available admonitions:

- `[!ABSTRACT]`
- `[!CAUTION]`
- `[!CODE]`
- `[!CONCLUSION]`
- `[!DANGER]`
- `[!ERROR]`
- `[!EXAMPLE]`
- `[!EXPERIMENT]`
- `[!GOAL]`
- `[!IDEA]`
- `[!IMPORTANT]`
- `[!INFO]`
- `[!MEMO]`
- `[!NOTE]`
- `[!NOTIFY]`
- `[!QUESTION]`
- `[!QUOTE]`
- `[!SUCCESS]`
- `[!TASK]`
- `[!TIP]`
- `[!WARNING]`

### Citing a reference

To cite a reference, use the following format: `{{< cite "Pearson:1988aa" >}}`


#### Rebuild the bibliography file in JSON from bibtex

```bash
pandoc assets/bibliography/bibliography.bib -t csljson -o assets/bibliography/bibliography.json
```
