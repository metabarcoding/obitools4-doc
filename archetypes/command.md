+++
archetype = "command"
title = "{{ .Name | title }}"
+++

## Description :

### Synopsis

```bash
{{ .Name }} [OPTIONS] [ARGS]
```

### Options

#### `{{ .Name }}` specific options:

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

### Examples

```bash
{{ .Name }} --help
```
