// https://www.hackerrank.com/challenges/maximum-element
package main

import (
	"fmt"
	"log"
)

func main() {
	var n int
	if _, err := fmt.Scanln(&n); err != nil {
		log.Panic("scanning for number of queries, encountered an error:", err)
	}
	st := &stack{}
	largestSt := &stack{}
	for i := 0; i < n; i++ {
		var qType int
		if _, err := fmt.Scan(&qType); err != nil {
			log.Panic("scanning for query type:", err)
		}
		switch qType {
		case 1:
			var num int
			if _, err := fmt.Scanln(&num); err != nil {
				log.Panic("scanning for number to push:", err)
			}
			st.push(num)
			if largestSt.size() == 0 || largestSt.peek() <= num {
				largestSt.push(num)
			}
		case 2:
			num := st.pop()
			if num == largestSt.peek() {
				largestSt.pop()
			}
		case 3:
			fmt.Println(largestSt.peek())
		default:
			log.Panic("unknown query type:", qType)
		}
	}
}

type stack struct {
	elements []int
}

func (s *stack) push(n int) {
	if s.elements == nil {
		s.elements = []int{}
	}
	s.elements = append(s.elements, n)
}

func (s *stack) pop() int {
	n := s.elements[len(s.elements)-1]
	s.elements = s.elements[:len(s.elements)-1]
	return n
}

func (s *stack) peek() int {
	return s.elements[len(s.elements)-1]
}

func (s *stack) size() int {
	return len(s.elements)
}
