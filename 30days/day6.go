package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
)

func main() {
	inputStrs, err := getInputStrings(os.Stdin)
	if err != nil {
		fmt.Println(err)
		return
	}
	for _, s := range inputStrs {
		fmt.Println(everyOtherLetterStartingFrom(0, s), everyOtherLetterStartingFrom(1, s))
	}
}

func getInputStrings(r io.Reader) ([]string, error) {
	scanner := bufio.NewScanner(r)
	if !scanner.Scan() {
		if scanner.Err() != nil {
			return nil, fmt.Errorf("error scanning first line: %v", scanner.Err())
		}
	}
	var numStrings uint
	if _, err := fmt.Sscanln(scanner.Text(), &numStrings); err != nil {
		return nil, fmt.Errorf("error scanning first line for a single positive number: %v", err)
	}
	inputStrs := []string{}
	for scanner.Scan() {
		inputStrs = append(inputStrs, scanner.Text())
	}
	if scanner.Err() != nil {
		return nil, fmt.Errorf("error when scanning lines: %v", scanner.Err())
	}
	if len(inputStrs) != int(numStrings) {
		return nil, fmt.Errorf("got %d strings in the input expected %d", len(inputStrs), numStrings)
	}
	return inputStrs, nil
}

func everyOtherLetterStartingFrom(start int, s string) (result string) {
	for i := start; i < len(s); i += 2 {
		result += s[i : i+1]
	}
	return result
}
