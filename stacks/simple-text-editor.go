// https://www.hackerrank.com/challenges/simple-text-editor
//
// I've restructured the logic a bit. I was just curious to see how the code
// would look if I read all the inputs first before doing any program logic
// instead of getting input as I'm performing program logic on said input. I
// think I like the look of it!
//
// I liked this one! Very cute. Made me realize more that vim (my current text
// editor) stores a lot of information as I edit. I also wonder what sort of
// data structures it uses to keep track of things. I believe it keeps a tree
// for undo information rather than a simple stack!
//
// Originally when I solved this problem I was just using the fmt.Scan()
// function to read directly from stdin but it turned out it was too slow.
// Switching to using a buffered reader and using strconv.Atoi() to convert
// strings to numbers increased the speed by a good margin. This is the second
// time this has bit me (the dorsey thief being the first). It's really amazing
// how much speed is saved by doing this.
package main

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"log"
	"os"
	"strconv"
)

const (
	_ = iota // We need the constants to start at 1
	appendString
	deleteChars
	printChar
	undo
)

func main() {
	inputLines := getInput(os.Stdin)
	stringHistory := &strStack{""}
	output := []byte{}
	for _, input := range inputLines {
		switch input.queryType {
		case appendString:
			stringHistory.push(stringHistory.peek() + input.value.(string))
		case deleteChars:
			s := stringHistory.peek()
			stringHistory.push(s[:len(s)-input.value.(int)])
		case printChar:
			output = append(output, stringHistory.peek()[input.value.(int)-1], '\n')
		case undo:
			stringHistory.pop()
		}
	}
	fmt.Printf("%s", output)
}

type inputLine struct {
	queryType int
	value     interface{}
}

func getInput(r io.Reader) []inputLine {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(bufio.ScanWords)
	n, err := nextInt(scanner)
	if err != nil {
		log.Panic(err)
	}
	inputs := make([]inputLine, n)
	for i := 0; i < n; i++ {
		queryType, err := nextInt(scanner)
		if err != nil {
			log.Panic(err)
		}
		switch queryType {
		case appendString:
			s, err := nextString(scanner)
			if err != nil {
				log.Panic(err)
			}
			inputs[i] = inputLine{queryType: queryType, value: s}
		case deleteChars:
			k, err := nextInt(scanner)
			if err != nil {
				log.Panic(err)
			}
			inputs[i] = inputLine{queryType: queryType, value: k}
		case printChar:
			k, err := nextInt(scanner)
			if err != nil {
				log.Panic(err)
			}
			inputs[i] = inputLine{queryType: queryType, value: k}
		case undo:
			inputs[i] = inputLine{queryType: queryType}
		}
	}
	return inputs
}

func nextInt(s *bufio.Scanner) (int, error) {
	if !s.Scan() {
		if s.Err() != nil {
			return 0, s.Err()
		}
		return 0, errors.New("reached end of input before expected")
	}
	n, err := strconv.Atoi(s.Text())
	if err != nil {
		return 0, fmt.Errorf("converting text to number: %v", err)
	}
	return n, nil
}

func nextString(s *bufio.Scanner) (string, error) {
	if !s.Scan() {
		if s.Err() != nil {
			return "", s.Err()
		}
		return "", errors.New("reached end of input before expected")
	}
	return s.Text(), nil
}

type strStack []string

func (st *strStack) push(s string) {
	*st = append(*st, s)
}

func (st *strStack) pop() string {
	r := (*st)[len(*st)-1]
	*st = (*st)[:len(*st)-1]
	return r
}

func (st strStack) peek() string {
	return st[len(st)-1]
}
