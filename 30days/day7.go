package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strings"
)

func main() {
	size, line, err := getInput(os.Stdin)
	if err != nil {
		fmt.Printf("error getting input: %v\n", err)
		return
	}
	nums, err := convertStrToIntArray(size, line)
	if err != nil {
		fmt.Printf("error converting input to array of integers: %v\n", err)
		return
	}
	for i := len(nums) - 1; i > 0; i-- {
		fmt.Printf("%d ", nums[i])
	}
	fmt.Println(nums[0])
}

func getInput(r io.Reader) (arraySize uint, arr string, err error) {
	scanner := bufio.NewScanner(r)
	if !scanner.Scan() {
		if scanner.Err() != nil {
			return 0, "", fmt.Errorf("error scanning first line: %v", scanner.Err())
		}
	}
	if _, err := fmt.Sscanln(scanner.Text(), &arraySize); err != nil {
		return 0, "", fmt.Errorf("error scanning first line for a single positive number: %v", err)
	}
	if !scanner.Scan() {
		if scanner.Err() != nil {
			return 0, "", fmt.Errorf("error scanning line with array: %v", scanner.Err())
		}
	}
	return arraySize, scanner.Text(), nil
}

func convertStrToIntArray(arraySize uint, arr string) ([]int, error) {
	wordScanner := bufio.NewScanner(strings.NewReader(arr))
	wordScanner.Split(bufio.ScanWords)
	nums := []int{}
	for wordScanner.Scan() {
		var num int
		if _, err := fmt.Sscanln(wordScanner.Text(), &num); err != nil {
			return nil, fmt.Errorf("parsing integer from %q: %v", wordScanner.Text(), err)
		}
		nums = append(nums, num)
	}
	if len(nums) != int(arraySize) {
		return nil, fmt.Errorf("got array of size %d, expected size to be %d", len(nums), arraySize)
	}
	return nums, nil
}
