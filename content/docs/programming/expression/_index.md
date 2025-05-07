---
title: "Expression language"
weight: 10
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

## The OBITools Expression Language

The OBITools Expression Language is based on the [Gval Language](https://github.com/PaesslerAG/gval). It extends [Gval](https://github.com/PaesslerAG/gval) with additional functions useful for bioinformatics tasks and some predefined variables. The language is designed to compute simple expressions that are used as arguments for options of some OBITools commands (*e.g.* {{< obi obigrep >}}, {{< obi obiannotate >}}). So it is a very simple language. For more complex scripting you can use [Lua]({{< ref "/docs/programming/lua" >}}) via the {{< obi obiscript >}} command.

### 🧩 List of variables Added to the Gval Language

The expressions are evaluated in the context of a sequence. When evaluating an expression, these variables are available

1. **`sequence`** - a variable representing current sequence being processed by
   the OBITools command. It is an object of type **BioSequence**.
2. **`annotations`** - a variable representing the annotations of the current
   sequence being processed by the OBITools command. It is an object of type
   **Annotations**, actually a map indexed by string. Each string is the tag
   name that you can observe in the header of a sequence in a {{% fasta %}} or
   {{% fastq %}} file 

The expression language allows to access to the methods of the **BioSequence** class for the `sequence` variable. For example, you can use `sequence.Len()` returns the length of the sequence and `sequence.Id()` returns its identifier. The same for the **Annotations** class for the `annotations` variable.

The useful methods for the **BioSequence** class are:
1. **`Len() int`** - Returns the length of the sequence.
3. **`String() string`** - Returns the sequence itself as a string.
2. **`Id() string`** - Returns the identifier of the sequence.
3. **`Definition() string`**  - Returns the definition part of the header line of the sequence 
4. **`HasAnnotation() bool`** - Returns `true` if at least one annotation exists for this sequence.
5. **`HasDefinition() bool`** - Returns `true` if a definition exists for this sequence.
6. **`HasSequence() bool`** - Returns `true` if the sequence is not empty.
7. **`HasQualities() bool`** - Returns `true` if quality scores exist for this sequence. 
8. **`Qualities() []byte`** - Returns the quality scores as a byte array (only for FASTQ sequences).
    
## 🧩 List of Functions Added to the Gval Language

6. **`len`**  
   Calculates the length of an object (e.g., string, sequence).
   The function accepts as input a sequence, a string, a vector or a map.
   On sequence and string, it returns the length of the input (number of
   nucleotides or characters respectively). On maps and vectors and maps,
   the `len` function returns the number of elements stored in the container object.

   **Example:**  

   Here we use the `len` function to compute the length of the current sequence.

   ```gval
   len(sequence)  // Returns the length of the biological sequence
   ```

7. **`contains`**  
   Checks if a key exists in a map or a substring exists in a string. 
   This function applied on map objects. OBITools maps are indexed by string
   keys. The `contains` required a map object as first parameter and a string
   object as second parameter. It returns the logical value `true` if the map
   contains the key defined by the second parameter. Otherwise, the function
   returns `false`.

   **Example:**  

   Check if the `annotations` map of the sequence is containing the key `count`, which
   means: is the sequence annotated by a `count` tag.

   ```gval
   contains(annotations,"count")  // // Checks if "gene" is a key in the annotations map
   ```

8. **`ismap`**  
   Checks if an object is a map (key-value structure). That function is a type assertion 
   function it allows for checking that the object provided as parameter is a map. It returns the logical value `true` if the object is a map, otherwise it returns `false`.

   **Example:**  
   
   Check if the `annotations.merged_sample` object is a map. `annotation` is itself a map
   containing every annotation of the current sequence. `annotations.merged_sample` is the
   object contained in the `annotations` at the index `merged_sample`. This tag is normally
   set by {{< obi obiuniq >}} and is a map indexed by sample ids and containing the number
   of time this sequence has been observed in the different samples. If the file is correctly
   annotated, the `annotations.merged_sample` object is therefore a map and the `ismap` 
   function must return `true`.
   
   ```gval
   ismap(annotations.merged_sample)  // Returns `true` if the `merged_sample` 
                                       // `annotations` is a map
   ```

9.  **`sprintf`**  
   **Formats a string by replacing placeholders with values**, enabling dynamic
   text generation. It is commonly used to construct messages, file paths, or
   structured data by inserting variables into predefined templates.  

   ---

   **How It Works**  

   - **Placeholders** (e.g., `%s`, `%d`, `%f`) act as markers for values to be inserted.  
   - The function replaces each placeholder with the corresponding argument in order.  

   ---

   **Examples**  
   
   - **Basic String Insertion**  
  
     ```gval
     sprintf("Sample: %s", "Sper01")  
     // Output: "Sample: Sper01"
     ````

   - **Basic String Insertion**  

     ```gval
     sprintf("Sample: %s", "Sper01")  
     // Output: "Sample: Sper01"
     ````

   - **Numeric Formatting**  

     ```gval
     ssprintf("Length: %d bp", 84)  
     // Output: "Length: 84 bp"
     ````

   - **Floating-Point Precision**  

     ```gval
     sprintf("GC Content: %.2f%%", 52.345)  
     // Output: "GC Content: 52.34%"
     ````

   - **Combining Multiple Values**  

     ```gval
     sprintf("Primer: %s (position %d)", "GGGCAATCCTGAGCCAA", 10)  
     // Output: "Primer: GGGCAATCCTGAGCCAA (position 10)"
     ````
   ---

   Placeholders like `%s` (string), `%d` (integer), `%f` (float), and `%v` (generic value) are typical
   of the `printf` family of function found in many languages.

   1. Padding
      Add padding to values using 0 (zero) or space ( ) for alignment.

      | Format | Description | Example | Output | 
      |----------------|----------------|------------------|----------------| 
      | %5d | Minimum width of 5, right-aligned | sprintf("%5d", 42) | `'   42'` | 
      | %-5d | Minimum width of 5, left-aligned | sprintf("%-5d", 42) | `'42   '` | 
      | %05d | Zero-padded to 5 digits | sprintf("%05d", 42) | `'00042'` | 
      | %05.2f | Zero-padded float with precision | sprintf("%05.2f", 3.14) | `'03.14'` |

   2. Precision
      Control the number of decimal places for floats or the maximum length for strings.

      | Format | Description | Example | Output | 
      |----------------|-------------|-----------|----------------| 
      | %.2f | 2 decimal places | sprintf("%.2f", 3.14159) | `'3.14'` | 
      | %.3s | First 3 characters of a string | sprintf("%.3s", "hello") | `'hel'` | 
      | %05.2f | Zero-padded float with precision| sprintf("%05.2f", 12.3) | `'12.30'` |

   3. Alignment
      Use - to left-align values within a field.

      | Format | Description | Example | Output | 
      |----------------|---------------------|----------------|----------------| 
      | %-10s | Left-align string in 10 chars | sprintf("%-10s", "cat") | `'cat       '` | 
      | %-5.2f | Left-align float with precision | sprintf("%-5.2f", 3.14) | `'3.14 '` |

   4. Special Verbs
      
      - `%v`: Default formatting (e.g., for slices, maps, or custom types).

        ```gval
        sprintf("%v", [1, 2, 3])       // "[1 2 3]"
        sprintf("%v", {"name": "Alice"}) // "{name: Alice}"
        ```

      - `%T`: Print the type of a value.

        ```gval
        sprintf("%T", 42)       // "int"
        sprintf("%T", "hello")  // "string"
        ```

   5. Hexadecimal and Binary

      - `%x`/`%X`: Lowercase/uppercase hex.

         ```gval
         sprintf("%x", 255)  // "ff"
         sprintf("%X", 255)  // "FF"
         ```

      - `%b`: Binary representation.

         ```gval
         sprintf("%b", 5)    // "101"
         ```

   6. Scientific Notation

      `%e`/`%E`: Scientific notation with lowercase/uppercase e.

      ```gval
      sprintf("%e", 123456.789)  // "1.234568e+05"
      sprintf("%E", 123456.789)  // "1.234568E+05"
      ```

   7. Use `%%` to escape a literal % character

      ```gval
      sprintf("Percentage: %d%%", 50)  // "Percentage: 50%"
      ```

10. **`subspc`**  
   
   The function accept a string parameter and replaces spaces in a string with underscores (`_`).
   It returns the new substituted string.

   **Examples**  

   ```gval
   subspc("Abies alba")  // returns "Abies_alba"
   ```

11. **`int`**  
   Converts a value to an integer (`int`). Fails if conversion is not possible.
   
   **Examples**  

   ```gval
   int("324") # Returns the integer value 324
   int(3.24) # Returns the integer value 3
   ```

12. **`numeric`**  
   
   Converts a value to a floating-point number (`float64`). Fails if conversion is not possible.

   **Examples**  

   ```gval
   numeric("3.14159") # Returns the float value 3.14159
   numeric(3) # Returns the float value 3.0
   ```

13. **`bool`**  
   
   Converts a value to a boolean (`bool`). Fails if conversion is not possible.
   Every non-null numeric value is considered as `true`. For `string`, once
   converted to lower cases, value equals to `"true"`, `"t"`, `"yes"`, `"1"` or `"on"` are considered 
   as `true`, all others are `false`.

   **Examples**  

   ```gval
   bool("TRUE") // returns true
   bool("Toto") // returns false
   bool(3) // returns true
   bool(0) // returns false   
   ```

14. **`ifelse`**  
    Conditional operator: returns `args[1]` if `args[0]` is true, otherwise `args[2]`.

    **Examples**  

    ```gval
    ifelse(bool("true"), "yes", "no") // returns "yes"
    ifelse(bool("false"), "yes", "no") // returns "no"
    ```

15. **`gcskew`**  
    Calculates the GC skew (difference between G and C bases) of a biological sequence.

    {{< katex display=true >}}
    GC_{skew} = \frac{G - C}{G + C}
    {{< /katex >}}

    **Examples**  

    For example for sequence `"GATCG"`: {{< katex >}}GC_{skew} = \frac{2 - 1}{2 + 1} = \frac{1}{3}= 0.33 {{< /katex>}}

    ```gval
    gcskew("GATCG") // returns 0.3333 (1/3)
    ```

16. **`gc`**  
    
    Calculates the percentage of G and C bases in a biological sequence. 
   
    {{< katex display=true >}}
    GC = \frac{G + C}{len(sequence) - O}
    {{< /katex >}}  

    With *G* and *C* the number of corresponding nucleotides and *O* the number
    of ambiguous characters (Ns). 

    The function accepts a single argument of type biological sequence.

    **Examples**  

    ```gval
    gc("GATCG") // returns 0.6 (3/5, as there are two Gs and one Cs (Three in total) 
                // in a sequence of five nucleotides)
    ```

17. **`composition`**  
    
    Returns the base composition of a biological sequence as a map (`map[string]float64`)
    containing five keys: "a", "c", "g", "t", and "o". The value for each key is the number of occurrences of that base in the sequence, case-insensitive (i.e., both 'A' and 'a' are considered as 'a'). The "o" key represents the number of other characters (nucleotides that are not A, C, G or T) in the sequence. 

    The function accepts a single argument of type biological sequence.

    **Examples**  

    ```gval
    composition("GATCG") // returns map[string]float64{"a":1, "c":1, "g":2, "t":1, "o":0} 
    ```

18. **`replace`**  
    Replaces all occurrences of a regular expressions pattern in a string. The function accepts three arguments: the first one is the input string and the second one is the pattern to be replaced. The last argument is what will replace the found pattern in the string. It returns the modified string.

    **Examples**  

    ```gval
    replace("GATCG", "A.", "xx") // returns "GxxCG"
    replace("GATCG", "[ACGT]+", "X") // returns "X" 
    ```

