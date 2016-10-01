// https://www.hackerrank.com/challenges/array-left-rotation
package main

import (
	"fmt"
	"log"
)

func main() {
	var size, leftRot int
	if _, err := fmt.Scanln(&size, &leftRot); err != nil {
		log.Fatal(err)
	}
	s := []int{}
	for i := 0; i < size; i++ {
		var n int
		if _, err := fmt.Scan(&n); err != nil {
			log.Fatal(err)
		}
		s = append(s, n)
	}
	s2 := make([]int, len(s))
	for i := 0; i < size; i++ {
		// for length len, a left rotation of L is the same as a right rotation
		// of len - L. So for an element at index i: `i + len - L % len` is the
		// new index.
		newPos := (i + size - leftRot) % size
		s2[newPos] = s[i]
	}
	for i := 0; i < size-1; i++ {
		fmt.Print(s2[i], " ")
	}
	fmt.Println(s2[size-1])
}
