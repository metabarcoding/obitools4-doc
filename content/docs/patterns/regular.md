---
title: "Regular Expressions"
weight: 10
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# Regular Expressions

Regular expressions are a powerful tool for describing patterns in text. They are used in several {{< gloentry "OBITools" >}} like {{< obi obigrep >}}, {{< obi obiannotate >}} or {{< obi obiscript >}}.

## Single characters

| Pattern            | Description                                        |
|--------------------|----------------------------------------------------|
| `.`                | any character, possibly including newline (flag s=true) |
| `[xyz]`            | character class                                   |
| `[^xyz]`           | negated character class                           |
| `[[:alpha:]]`      | ASCII character class                             |
| `[[:^alpha:]]`     | negated ASCII character class                     |

## Composites

| Pattern          | Description               |
|------------------|---------------------------|
| `xy`             | x followed by y           |
| `x\|y`            | x or y (prefer x)        |

## Repetitions

| Pattern          | Description                                   |
|------------------|-----------------------------------------------|
| `x*`             | zero or more x, prefer more                  |
| `x+`             | one or more x, prefer more                   |
| `x?`             | zero or one x, prefer one                    |
| `x{n,m}`         | n or n+1 or ... or m x, prefer more         |
| `x{n,}`          | n or more x, prefer more                     |
| `x{n}`           | exactly n x                                  |
| `x*?`            | zero or more x, prefer fewer                 |
| `x+?`            | one or more x, prefer fewer                  |
| `x??`            | zero or one x, prefer zero                   |
| `x{n,m}?`        | n or n+1 or ... or m x, prefer fewer        |
| `x{n,}?`         | n or more x, prefer fewer                    |
| `x{n}?`          | exactly n x                                  |

## Grouping
  
| Pattern                | Description                                      |
|------------------------|--------------------------------------------------|
| `(re)`                 | numbered capturing group (submatch)              |
| `(?P<name>re)`        | named & numbered capturing group (submatch)      |
| `(?<name>re)`         | named & numbered capturing group (submatch)      |
| `(?:re)`              | non-capturing group                              |
| `(?flags)`            | set flags within current group; non-capturing    |
| `(?flags:re)`         | set flags during re; non-capturing               |

## Character classes

| Pattern                | Description                                          |
|------------------------|------------------------------------------------------|
| `[\d]`                 | digits (== \d)                                      |
| `[^\d]`                | not digits (== \D)                                  |
| `[\D]`                 | not digits (== \D)                                  |
| `[^\D]`                | not not digits (== \d)                              |
| `[[:name:]]`          | named ASCII class inside character class (== [:name:]) |
| `[^[:name:]]`         | named ASCII class inside negated character class (== [:^name:]) |
| `[\p{Name}]`          | named Unicode property inside character class (== \p{Name}) |
| `[^\p{Name}]`         | named Unicode property inside negated character class (== \P{Name}) |

## Named character classes
  
| Pattern                | Description                                          |
|------------------------|------------------------------------------------------|
| `[[:alnum:]]`         | alphanumeric (== `[0-9A-Za-z]`)                       |
| `[[:alpha:]]`         | alphabetic (== `[A-Za-z]`)                            |
| `[[:ascii:]]`         | ASCII (== `[\x00-\x7F]`)                              |
| `[[:blank:]]`         | blank (== `[\t ]`)                                    |
| `[[:cntrl:]]`         | control (== `[\x00-\x1F\x7F]`)                        |
| `[[:digit:]]`         | digits (== `[0-9]`)                                   |
| `[[:graph:]]`         | graphical (== `[!-~]` == ```[A-Za-z0-9!"#$%&'()*+,\-./:;<=>?@[\\\]^_`{\|}~])``` |
| `[[:lower:]]`         | lower case (== `[a-z]`)                               |
| `[[:print:]]`         | printable (== `[ -~]` == `[[:graph:]]`)               |
| `[[:punct:]]`         | punctuation (== ```[!-/:-@[-\`{-~]```)                |
| `[[:space:]]`         | whitespace (== `[\t\n\v\f\r ]`)                       |
| `[[:upper:]]`         | upper case (== `[A-Z]`)                               |
| `[[:word:]]`          | word characters (== `[0-9A-Za-z_]`)                   |
| `[[:xdigit:]]`        | hex digit (== `[0-9A-Fa-f]`)                          |