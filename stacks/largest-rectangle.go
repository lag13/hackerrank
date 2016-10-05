// https://www.hackerrank.com/challenges/largest-rectangle
//
// There was of course a super neat way to solve this problem using stacks. I
// don't think I would have realized a stack could help solve this problem if
// the problem wasn't listed under the "stack" section :). I still don't like
// my solution overly much (the code feels a bit messy) but it should get the
// job done.
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
	inputBuildings, err := getInput(os.Stdin)
	if err != nil {
		log.Panic(err)
	}
	largestArea := 0
	seenBuildings := &rectangleStack{}
	for len(*inputBuildings) > 0 {
		if len(*seenBuildings) == 0 || inputBuildings.peek().height > seenBuildings.peek().height {
			seenBuildings.push(inputBuildings.pop())
			continue
		}
		if inputBuildings.peek().height == seenBuildings.peek().height {
			seenBuilding := seenBuildings.pop()
			seenBuilding.width += inputBuildings.pop().width
			seenBuildings.push(seenBuilding)
			continue
		}
		// The next building on the input is shorter then the most recent
		// building we've seen.
		top := seenBuildings.pop()
		if top.height*top.width > largestArea {
			largestArea = top.height * top.width
		}
		if len(*seenBuildings) > 0 && inputBuildings.peek().height < seenBuildings.peek().height {
			next := seenBuildings.pop()
			next.width += top.width
			seenBuildings.push(next)
		} else {
			inputBuilding := inputBuildings.pop()
			inputBuilding.width += top.width
			inputBuildings.push(inputBuilding)
		}
	}
	// Check the remaining buildings left on the stack, note that by
	// construction the topmost element of this stack will have a larger height
	// than the ones below it.
	for len(*seenBuildings) > 0 {
		top := seenBuildings.pop()
		if top.height*top.width > largestArea {
			largestArea = top.height * top.width
		}
		if len(*seenBuildings) > 0 {
			next := seenBuildings.pop()
			next.width += top.width
			seenBuildings.push(next)
		}
	}
	fmt.Println(largestArea)
}

func getInput(r io.Reader) (*rectangleStack, error) {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(bufio.ScanWords)
	n, err := nextInt(scanner)
	if err != nil {
		return nil, err
	}
	buildings := &rectangleStack{}
	for i := 0; i < n; i++ {
		h, err := nextInt(scanner)
		if err != nil {
			return nil, err
		}
		buildings.push(rectangle{height: h, width: 1})
	}
	return buildings, nil
}

func nextInt(s *bufio.Scanner) (int, error) {
	if !s.Scan() {
		if s.Err() != nil {
			return 0, fmt.Errorf("reading input: %v", s.Err())
		}
		return 0, fmt.Errorf("expected input, got none")
	}
	return strconv.Atoi(s.Text())
}

type rectangle struct {
	height int
	width  int
}

type rectangleStack []rectangle

func (s *rectangleStack) push(r rectangle) {
	if *s == nil {
		*s = []rectangle{}
	}
	*s = append(*s, r)
}

func (s *rectangleStack) pop() rectangle {
	r := (*s)[len(*s)-1]
	*s = (*s)[:len(*s)-1]
	return r
}

func (s rectangleStack) peek() rectangle {
	return s[len(s)-1]
}
