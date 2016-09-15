package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	var i uint32 = 4
	var d float32 = 4.0
	var s string = "HackerRank "
	scanner := bufio.NewReader(os.Stdin)

	// Declare second integer, double, and String variables.
	var i2 uint32
	var d2 float32
	var s2 string

	// Read and save an integer, double, and String to your variables.
	input, _ := scanner.ReadString('\n')
	if _, err := fmt.Sscanf(input, "%d", &i2); err != nil {
		fmt.Printf("problem with parsing an integer from %q: %v", input, err)
		return
	}
	input, _ = scanner.ReadString('\n')
	if _, err := fmt.Sscanf(input, "%f", &d2); err != nil {
		fmt.Printf("problem with parsing a float from %q: %v", input, err)
		return
	}
	s2, err := scanner.ReadString('\n')
	if err == nil {
		s2 = s2[:len(s2)-1]
	}

	// Print the sum of both integer variables on a new line.
	fmt.Println(i + i2)

	// Print the sum of the double variables on a new line.
	fmt.Printf("%.1f\n", d+d2)

	// Concatenate and print the String variables on a new line
	// The 's' variable above should be printed first.
	fmt.Println(s + s2)
}
