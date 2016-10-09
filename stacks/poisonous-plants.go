// https://www.hackerrank.com/challenges/poisonous-plants
// I don't think I could give a nice concise explanation of what some of the
// code is doing which makes me think that I can simplify this code.
package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
	"strconv"
)

func main() {
	input, err := getInput(os.Stdin)
	if err != nil {
		log.Panic(err)
	}
	largestNumDays := 0
	survivors := &plantStack{}
	// We are guaranteed at least one plant in the input
	survivors.push(input.pop())
	for len(*input) > 0 {
		numDays := 0
		for len(*survivors) > 0 && input.peek().poison < survivors.peek().poison {
			s := survivors.pop()
			if numDays < s.numDays {
				numDays = s.numDays
			}
			numDays++
		}
		if len(*survivors) > 0 {
			if survivors.peek().numDays < numDays {
				s := survivors.pop()
				survivors.push(plant{poison: s.poison, numDays: numDays})
			}
		}
		survivors.push(input.pop())
		if numDays > largestNumDays {
			largestNumDays = numDays
		}
	}
	fmt.Println(largestNumDays)
}

func getInput(r io.Reader) (*plantStack, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanWords)
	n, err := nextInt(scanner)
	if err != nil {
		return nil, err
	}
	st := &plantStack{}
	for i := 0; i < n; i++ {
		p, err := nextInt(scanner)
		if err != nil {
			return nil, err
		}
		st.push(plant{poison: p, numDays: 0})
	}
	return st, nil
}

func nextInt(s *bufio.Scanner) (int, error) {
	if !s.Scan() {
		if s.Err() != nil {
			return 0, s.Err()
		}
		return 0, io.EOF
	}
	return strconv.Atoi(s.Text())
}

type plant struct {
	poison  int
	numDays int
}

type plantStack []plant

func (s *plantStack) push(p plant) {
	*s = append(*s, p)
}

func (s *plantStack) pop() plant {
	p := (*s)[len(*s)-1]
	*s = (*s)[:len(*s)-1]
	return p
}

func (s plantStack) peek() plant {
	return s[len(s)-1]
}
