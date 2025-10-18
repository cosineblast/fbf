
package main

import (
	"io"
	"os"
	"fmt"
	"strings"
	"bufio"
)

func findMatches(code string) map[int]int {
	openBraces := make([]int, len(code))
	top := 0
	result := make(map[int]int)

	for i, v := range code {
		if v == '[' {
			openBraces[top] = i
			top += 1
		} else if v == ']' {
			if top == 0 {
				panic(fmt.Sprintf("Unmatched brace at position i"))
			}
			top -= 1
			left := openBraces[top]
			result[left] = i
			result[i] = left
		}
	}

	return result
}

func runBf(code string) {
	input := bufio.NewReader(os.Stdin)

	matches := findMatches(code)

	tape := make([]uint8, 30_000)

	tapeIndex := 0
	sourceIndex := 0

	for sourceIndex != len(code) {
		char := code[sourceIndex]

		switch char {
			case '+':
				tape[tapeIndex] += 1
			break
			case '-':
				tape[tapeIndex] -= 1
			break
			case '>':
				tapeIndex += 1
			break
			case '<':
				tapeIndex -= 1
			break
			case '[':
				if tape[tapeIndex] == 0 {
					sourceIndex = matches[sourceIndex]
				}
			break
			case ']':
				if tape[tapeIndex] != 0 {
					sourceIndex = matches[sourceIndex]
				}
			break
			case '.':
				fmt.Printf("%c", tape[tapeIndex])
			break
			case ',':
				value, err := input.ReadByte()
				if err != nil {
					panic(err)
				}
				tape[tapeIndex] = value
			break
			case '?':
				fmt.Printf("[%v]=%v\n", tapeIndex, tape[tapeIndex])
			break
		}


		sourceIndex += 1
	}
}

func preprocess(code string) string {
	words := make(map[string]string)
	result := strings.Builder{}
	base := strings.Builder{}

	targetWord := ""

	tokens := strings.Fields(code)
	i := 0

	for i < len(tokens)  {
		token := tokens[i]

		if token == ":" {
			i += 1

			if i == len(tokens) {
				fmt.Println("preprocessor: last token was :")
				os.Exit(2)
			}

			if targetWord != "" {
				fmt.Println("preprocessor: can't declared nested words")
				os.Exit(2)
			}

			targetWord = tokens[i]
		} else if token == ";" {
			if targetWord == "" {
				fmt.Println("preprocessor: found ; outside of a word declaration")
				os.Exit(2)
			}

			words[targetWord] = base.String()
			base = strings.Builder{}
			targetWord = ""
		} else {
			toWrite := token

			wordcode, ok := words[token]

			if ok {
				toWrite = wordcode
			}

			if targetWord == "" {
				result.WriteString(toWrite)
			} else {
				base.WriteString(toWrite)
			}
		} 
		i += 1
	}

	if targetWord != "" {
		fmt.Printf("preprocessor: declaration of word %s was not terminated\n", targetWord)
		os.Exit(1)
	}

	return result.String()
}

func main() {

	if len(os.Args) < 2 {
		fmt.Println("Missing input file argument.")
		os.Exit(1)
	}

	file, err := os.Open(os.Args[1])

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	defer file.Close()

	bytes, err := io.ReadAll(file)


	code := string(bytes)

	processed := preprocess(code)

	runBf(processed)
}
