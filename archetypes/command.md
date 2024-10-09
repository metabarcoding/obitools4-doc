{{- $short := "" -}}{{- $description := "" -}}{{- $name := .Name | lower -}}{{- range .Site.Data.commands -}}{{ if eq $name .command }}{{- $description = .description -}}{{- $short = .short -}}{{ end }}{{- end -}}
---
archetype: "command"
title: "{{ .Name | title }}{{ if $short }}: {{ $short }}{{end}}"
date: {{ .Date | time.Format "2006-01-02" }}
command: "{{ .Name }}"
url: "/obitools/{{ .Name | lower }}"
---

## `{{ .Name | lower }}`{{ if $short }}: {{ $short }}{{end}}

### Description 

{{ if $description }}{{- $description -}}{{ end }}

### Synopsis

```bash
{{ .Name }} [OPTIONS] [ARGS]
```

### Options

#### {{< obi {{ .Name | lower }} >}} specific options:

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
