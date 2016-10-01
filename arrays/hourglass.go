// https://www.hackerrank.com/challenges/2d-array
package main

import (
	"fmt"
	"log"
)

const (
	rows = 6
	cols = 6
)

type Pt struct {
	x int
	y int
}

func main() {
	var n int
	mat := [][]int{}
	for y := 0; y < rows; y++ {
		row := make([]int, cols)
		for x := 0; x < cols; x++ {
			if _, err := fmt.Scan(&n); err != nil {
				log.Fatal(err)
			}
			row[x] = n
		}
		mat = append(mat, row)
	}
	hourglass := []Pt{
		{0, 0}, {1, 0}, {2, 0},
		{1, 1},
		{0, 2}, {1, 2}, {2, 2},
	}
	bestSum := 0
	foundSolution := false
	for y := 0; y < rows; y++ {
		for x := 0; x < cols; x++ {
			curSum, validSum := getSum(x, y, mat, hourglass)
			if validSum && (curSum > bestSum || !foundSolution) {
				bestSum = curSum
				foundSolution = true
			}
		}
	}
	fmt.Println(bestSum)
}

func getSum(x int, y int, mat [][]int, hourglass []Pt) (sum int, validSum bool) {
	for _, pt := range hourglass {
		pt.x = pt.x + x
		pt.y = pt.y + y
		if pt.x < 0 || cols <= pt.x || pt.y < 0 || rows <= pt.y {
			return 0, false
		}
		sum += mat[pt.y][pt.x]
	}
	return sum, true
}
