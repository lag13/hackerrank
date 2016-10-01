package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
)

type Point struct {
	x int
	y int
}

func main() {
	const (
		numRows = 6
		numCols = 6
	)
	matrix, err := getMatrix(os.Stdin, numRows, numCols)
	if err != nil {
		fmt.Printf("error getting+parsing matrix from intput: %v\n", err)
		return
	}
	// I'm defining an hourglass as a list of offsets from the top left hand
	// corner of the hourglass shape. I tried to write the slice of points to
	// indicate this as best as I could. The benefit of doing it like this is
	// that we could specify a new slice of offsets if we wanted to solve this
	// same algorithm for a different shape.
	hourglass := []Point{
		{0, 0}, {1, 0}, {2, 0},
		{1, 1},
		{0, 2}, {1, 2}, {2, 2},
	}
	foundSolution := false
	largestSum := 0
	for y := 0; y < numRows; y++ {
		for x := 0; x < numCols; x++ {
			sum, isValidSum := getShapeSum(hourglass, Point{x, y}, matrix, numRows, numCols)
			if !isValidSum {
				continue
			}
			if sum > largestSum || !foundSolution {
				largestSum = sum
				foundSolution = true
			}
		}
	}
	fmt.Println(largestSum)
}

// getMatrix reads and constructs a matrix from an io.Reader. Technichally they
// could specify the matrix as one big line with n*n elements (instead of n
// lines of n elements each) but I'm fine with that.
func getMatrix(r io.Reader, numRows int, numCols int) ([][]int, error) {
	matrix := [][]int{}
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanWords)
	for y := 0; y < numRows; y++ {
		row := []int{}
		for x := 0; x < numCols; x++ {
			if !scanner.Scan() {
				if scanner.Err() != nil {
					return nil, fmt.Errorf("reading input: %v", scanner.Err())
				}
			}
			var n int
			if _, err := fmt.Sscanln(scanner.Text(), &n); err != nil {
				return nil, fmt.Errorf("error parsing integer from %q: %v", scanner.Text(), err)
			}
			row = append(row, n)
		}
		matrix = append(matrix, row)
	}
	return matrix, nil
}

// getShapeSum gets the sum of the specified shape in the matrix. If no such
// sum can be computed (the shape falls outside of the matrix for instance)
// then that will be indicated in the return arguments.
func getShapeSum(offsets []Point, start Point, matrix [][]int, numRows int, numCols int) (sum int, validSum bool) {
	pointsInHourglass, areValidCoordinates := getShapePoints(offsets, start, numRows, numCols)
	if !areValidCoordinates {
		return 0, false
	}
	for _, p := range pointsInHourglass {
		sum += matrix[p.y][p.x]
	}
	return sum, true
}

// getShapePoints returns a slice of points in the matrix where the shape
// actually falls. If any part of the shape falls outside of the matrix then
// the returned values will indicate that the points should not be considered.
func getShapePoints(offsets []Point, start Point, numRows int, numCols int) (coordinates []Point, areValidCoordinates bool) {
	coordinates = []Point{}
	for _, offset := range offsets {
		coordinate := Point{start.x + offset.x, start.y + offset.y}
		if !pointInMatrix(numRows, numCols, coordinate) {
			return nil, false
		}
		coordinates = append(coordinates, coordinate)
	}
	return coordinates, true
}

func pointInMatrix(numRows int, numCols int, p Point) bool {
	if 0 <= p.x && p.x < numCols && 0 <= p.y && p.y < numRows {
		return true
	}
	return false
}
