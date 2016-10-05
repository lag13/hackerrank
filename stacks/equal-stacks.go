// https://www.hackerrank.com/challenges/equal-stacks
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

func main() {
	st1, st2, st3, err := getInput(os.Stdin)
	if err != nil {
		log.Panic(err)
	}
	for st1.height != st2.height || st2.height != st3.height {
		if st1.height > st2.height || st1.height > st3.height {
			st1.pop()
		}
		if st2.height > st1.height || st2.height > st3.height {
			st2.pop()
		}
		if st3.height > st1.height || st3.height > st2.height {
			st3.pop()
		}
	}
	fmt.Println(st1.height)
}

func getInput(r io.Reader) (*cylStack, *cylStack, *cylStack, error) {
	const numStacks = 3
	scn := bufio.NewScanner(r)
	scn.Split(bufio.ScanWords)
	stackSizes := []int{}
	for i := 0; i < numStacks; i++ {
		n, err := nextInt(scn)
		if err != nil {
			return nil, nil, nil, err
		}
		stackSizes = append(stackSizes, n)
	}
	stacks := []*cylStack{}
	for _, size := range stackSizes {
		st, err := getStackFromInput(size, scn)
		if err != nil {
			return nil, nil, nil, err
		}
		stacks = append(stacks, st)
	}
	return stacks[0], stacks[1], stacks[2], nil
}

func getStackFromInput(size int, s *bufio.Scanner) (*cylStack, error) {
	cyls := make([]int, size)
	height := 0
	for i := 0; i < size; i++ {
		n, err := nextInt(s)
		if err != nil {
			return nil, err
		}
		cyls[size-i-1] = n
		height += n
	}
	return &cylStack{elems: cyls, height: height}, nil
}

func nextInt(s *bufio.Scanner) (int, error) {
	if !s.Scan() {
		if s.Err() != nil {
			return 0, s.Err()
		}
		return 0, errors.New("reached end of input")
	}
	return strconv.Atoi(s.Text())
}

type cylStack struct {
	elems  []int
	height int
}

func (s *cylStack) pop() {
	h := s.elems[len(s.elems)-1]
	s.elems = s.elems[:len(s.elems)-1]
	s.height -= h
}
