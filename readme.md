# Note to the OBITools documentation writers

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


### Rebuild the bibliography file 

```bash
pandoc data/bibliography.bib -t csljson -o data/bibliography.json
```