// https://www.hackerrank.com/challenges/dynamic-array
package main

import (
	"fmt"
	"log"
)

func main() {
	var numSeqs int
	var numQueries int
	if _, err := fmt.Scan(&numSeqs, &numQueries); err != nil {
		log.Fatal(err)
	}
	seqList := [][]int{}
	for i := 0; i < numSeqs; i++ {
		seqList = append(seqList, []int{})
	}
	lastAns := 0
	for i := 0; i < numQueries; i++ {
		var (
			queryType, x, y int
		)
		if _, err := fmt.Scan(&queryType, &x, &y); err != nil {
			log.Fatal(err)
		}
		if queryType == 1 {
			seq := (x ^ lastAns) % numSeqs
			seqList[seq] = append(seqList[seq], y)
		} else if queryType == 2 {
			seq := (x ^ lastAns) % numSeqs
			lastAns = seqList[seq][y%len(seqList[seq])]
			fmt.Println(lastAns)
		} else {
			log.Fatal("unkown query type", queryType)
		}
	}
}
