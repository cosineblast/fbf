
# fbf - fortified brainfuck

This is a simple brainfuck interpreter, with additional features to aid in the development of programs.

-----

## Features

  * **Standard Brainfuck Commands:** Supports `+`, `-`, `>`, `<`, `[`, `]`, `.`, `,`.
  * **Tape Size:** Uses a tape of $\mathbf{30,000}$ cells, each storing a $\mathbf{8-bit}$ unsigned integer ($\mathbf{uint8}$).
  * **Debugging Command:** Includes a non-standard command `?` to print the current tape index and the value of the cell at that index.
  * **Preprocessor:** Supports defining and using "words" (macros) in the source code.

-----

## Preprocessor

The interpreter includes a simple preprocessor that allows defining custom **words** to represent sequences of Brainfuck commands. This feature is inspired by languages like Forth.

### Syntax

  * **Word Declaration:** Use a colon (`:`) followed by the word name, then the Brainfuck code sequence, and terminate with a semicolon (`;`).
      * Example: `: inc_cell + ;` defines a word `inc_cell` as the command `+`.
  * **Word Usage:** Use the word name in the main code. The preprocessor replaces the word with its defined sequence of commands.
      * Example: `inc_cell inc_cell .`
  * **Tokenization:** The preprocessor tokenizes the source code by splitting it on whitespace. Commands and word definitions must be separated by whitespace.
      * This means `+; ` is not the same as `+ ; `, only in the latter `;` counts as a word terminator. 
  * **Comments:** Any code inside  whitespace-delimited parenthesis `(` `)` is ignored. Only single-level parenthesis comments are considered.

-----

## Usage

### Building

To build the executable, run:

```bash
go build
```

The executable will be saved as `fbf`.

### Running

The interpreter requires one argument: the path to the Brainfuck source file.

```bash
./fbf <path/to/brainfuck/file>
```

Note: Input for the `,` command is read from standard input (**stdin**), and output from the `.` command is written to standard output (**stdout**).

-----

## Brainfuck Commands Reference

| Command | Action |
| :---: | :--- |
| **`+`** | Increment the value of the current cell by 1. Wraps from 255 to 0. |
| **`-`** | Decrement the value of the current cell by 1. Wraps from 0 to 255. |
| **`>`** | Move the tape pointer to the right (to the next cell). |
| **`<`** | Move the tape pointer to the left (to the previous cell). |
| **`[`** | If the value of the current cell is 0, jump forward to the command *after* the matching `]`. |
| **`]`** | If the value of the current cell is non-zero, jump back to the command *after* the matching `[`. |
| **`.`** | Output the character represented by the ASCII value of the current cell. |
| **`,`** | Accept one byte of input, storing its value in the current cell. |
| **`?`** | **(Custom Debug)** Print the current tape index and the value of the cell at that index to standard output. |

----

Disclaimer: This README was written with the assistance of generative bias automation (AI).
