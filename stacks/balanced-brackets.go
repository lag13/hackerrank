// https://www.hackerrank.com/challenges/balanced-brackets
package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

func main() {
	var n int
	if _, err := fmt.Scanln(&n); err != nil {
		log.Panic(err)
	}
	balancedStrs := make([]bool, n)
	scanner := bufio.NewScanner(os.Stdin)
	for i := 0; i < n; i++ {
		if !scanner.Scan() {
			if scanner.Err() != nil {
				log.Panic("error reading input:", scanner.Err())
			}
			log.Panic("reached end of input before expected")
		}
		balancedStrs[i] = isBalanced(scanner.Text())
	}
	for _, b := range balancedStrs {
		if b {
			fmt.Println("YES")
		} else {
			fmt.Println("NO")
		}
	}
}

func isBalanced(s string) bool {
	const (
		openingBrackets = "([{"
		closingBrackets = ")]}"
	)
	st := &runeStack{}
	for _, r := range s {
		switch {
		case strings.ContainsRune(openingBrackets, r):
			st.push(r)
		case strings.ContainsRune(closingBrackets, r):
			if st.size() == 0 {
				return false
			}
			if strings.IndexRune(openingBrackets, st.pop()) != strings.IndexRune(closingBrackets, r) {
				return false
			}
		}
	}
	return st.size() == 0
}

type runeStack []rune

func (s *runeStack) push(r rune) {
	if *s == nil {
		*s = []rune{}
	}
	*s = append(*s, r)
}

func (s *runeStack) pop() rune {
	r := (*s)[len(*s)-1]
	*s = (*s)[:len(*s)-1]
	return r
}

func (s runeStack) peek() rune {
	return s[len(s)-1]
}

func (s runeStack) size() int {
	return len(s)
}
