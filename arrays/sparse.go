// https://www.hackerrank.com/challenges/sparse-arrays
package main

import (
	"fmt"
	"log"
)

func main() {
	var n int
	if _, err := fmt.Scanln(&n); err != nil {
		log.Fatal(err)
	}
	strs := make([]string, n)
	for i := 0; i < n; i++ {
		var s string
		if _, err := fmt.Scan(&s); err != nil {
			log.Fatal(err)
		}
		strs[i] = s
	}
	var q int
	if _, err := fmt.Scanln(&q); err != nil {
		log.Fatal(err)
	}
	for i := 0; i < q; i++ {
		var s string
		if _, err := fmt.Scan(&s); err != nil {
			log.Fatal(err)
		}
		num := countOccurrences(s, strs)
		fmt.Println(num)
	}
}

func countOccurrences(str string, ss []string) (count int) {
	for _, s := range ss {
		if str == s {
			count++
		}
	}
	return count
}
