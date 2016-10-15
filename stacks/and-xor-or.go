// https://www.hackerrank.com/challenges/and-xor-or
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
	fmt.Println(solve(input))
}

func getInput(r io.Reader) (*intStack, error) {
	s := bufio.NewScanner(r)
	s.Split(bufio.ScanWords)
	n, err := nextInt(s)
	if err != nil {
		return nil, err
	}
	input := &intStack{}
	for i := 0; i < n; i++ {
		num, err := nextInt(s)
		if err != nil {
			return nil, err
		}
		input.push(num)
	}
	return input, nil
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

func solve(input *intStack) int {
	var largest largestNum = 0
	// smallestCombos will be a strictly increasing stack which helps us find
	// all the smallest two numbers in any interval of the input.
	smallestCombos := &intStack{}
	smallestCombos.push(input.pop())
	equation := func(m1 int, m2 int) int {
		return ((m1 & m2) ^ (m1 | m2)) & (m1 ^ m2)
	}
	for len(*input) > 0 {
		for len(*smallestCombos) > 0 && input.peek() < smallestCombos.peek() {
			largest.setIfLarger(equation(input.peek(), smallestCombos.pop()))
		}
		if len(*smallestCombos) > 0 {
			largest.setIfLarger(equation(input.peek(), smallestCombos.peek()))
		}
		smallestCombos.push(input.pop())
	}
	return int(largest)
}

type intStack []int

func (s *intStack) push(i int) {
	*s = append(*s, i)
}

func (s *intStack) pop() int {
	i := (*s)[len(*s)-1]
	*s = (*s)[:len(*s)-1]
	return i
}

func (s intStack) peek() int {
	return s[len(s)-1]
}

// largestNum is a type used when we need to check a bunch of numbers but only
// keep the largest one. It saves us the hassle of writing this kind of code:
//		temp := someEquation()
//		if temp > largest {
//			largest = temp
//		}
type largestNum int

func (ln *largestNum) setIfLarger(n int) {
	if n > int(*ln) {
		*ln = largestNum(n)
	}
}
