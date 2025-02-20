# Note to the OBITools documentation writers

## The public version of the OBITools4 documentation

GitHub through the GitHub Pages feature allows for maintaining an up-to-date version of the documentation at the following URL:

https://obitools4.metabarcoding.org/

The documentation is automatically generated from the source code of the OBITools4-doc repository at each commit.

## Installing hugo 

### For Linux (Debian/Ubuntu) 
You need to install the extended version of Hugo using snap :
 ```bash
sudo snap install hugo --channel=extended
```
You can check that you have installed the latest version of Hugo (Hugo v0.143.1 or later).
 ```bash
hugo version  
 ```


## Getting a copy of the OBITools4 documentation

For the official OBITools4 developers, the documentation is hosted on GitHub
If you want to edit the documentation, you have to clone the repository:

```bash
git clone --recurse-submodules \
          --remote-submodules  \
          -j 8  \
          git@github.com:metabarcoding/obitools4-doc.git
```

On each commit, the documentation is automatically generated and pushed to the public documentation website.

## The editor

I recommend to use VSCodium, all installation instructions are available on https://vscodium.com/.

### VsCode extensions

The OBITools4 documentation is written in Markdown using the Hugo static site generator.
Therefore, I recommend using the following extensions to edit the documentation:

- [Hugo Language and Syntax Support](https://marketplace.visualstudio.com/items?itemName=budparr.language-hugo-vscode)


### Testing the documentation on the local machine

When you edit the documentation from VSCodium, I recommend you to open two unix terminals. In one of them, run the following command to start the Hugo server:

* for mac OS :
```bash
hugo server --buildDrafts
```

* for linux :
```bash
hugo server --buildDrafts --config hugo.yaml
```

Each time you edit the documentation, your local copy of the documentation will be automatically rebuilt and visible at the URL specified by the `hugo server` command.

```
Web Server is available at http://localhost:1313/obitools4-doc/ (bind address 127.0.0.1)
Total in 110 ms
```

The URL is changing each time you restart the server. So be sure to use the correct URL.


## Some commands to help you edit the documentation

In the second terminal, you will be able to run other hugo commands to create new pages as example.

### Add a new content

To add a new page, use the following command:

```bash
hugo new content content/docs/new_page/_index.md
```

This will create a new folder in the `content/docs` folder named `new_page` in which a new file named `_index.md` will be created.

Edit this file to modify the page.

You can add auxiliary files (images, sequence examples files, etc.) in the same folder.
They can thus be easily referenced from the page.

#### Add a new command description page

The following command will create a new page in the `content/docs/commands` folder,
containing a pre-filled template for the command description (here `obiconvert`).

```bash
hugo new content --kind command content/docs/commands/obiconvert/_index.md
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

## Download a developer copy of the obitools4

Currently, the documentation uses the obitools4 as present in the `V4.3` branch of the obitools4 repository.

To be able to get that version of the obitools4, you have to clone the repository:

```bash
git clone --recursive git@github.com:metabarcoding/obitools4.git
```

You can now enter the `obitools4` directory:

```bash
cd obitools4
```

You have to fetch all remote branches. And create the corresponding local branches.
From the `obitools4` directory, run the following command:

```bash
git fetch --all
for branch in $(git branch -r | grep -v '\->'); do
    if [[ "$branch" != "origin/master" ]]; then
      git branch --track ${branch#origin/} $branch
    fi
done
```

Finally, to ensure all branches are up-to-date, pull all branches:

```bash
git pull --all
```

The last step is to switch to the `V4.3` branch:

```bash
git checkout V4.3
```

### Compiling the obitools4

To compile the obitools4, run the following command:

```bash
make
```

The obitools4 will be compiled in the `build` directory.
