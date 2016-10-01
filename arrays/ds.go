// https://www.hackerrank.com/challenges/arrays-ds
package main

import (
	"fmt"
	"log"
)

func main() {
	var size int
	if _, err := fmt.Scan(&size); err != nil {
		log.Fatal(err)
	}
	s := make([]int, size)
	for i := 0; i < size; i++ {
		var n int
		if _, err := fmt.Scan(&n); err != nil {
			log.Fatal(err)
		}
		s[i] = n
	}
	for i := len(s) - 1; i > 0; i-- {
		fmt.Print(s[i], " ")
	}
	fmt.Print(s[0])
}
