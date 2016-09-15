package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
)

func main() {
	//Enter your code here. Read input from STDIN. Print output to STDOUT
	reader := bufio.NewReader(os.Stdin)
	input, err := reader.ReadString('\n')
	if err != nil && err != io.EOF {
		fmt.Printf("error reading input line: %v\n", err)
		return
	}
	var n uint
	if _, err := fmt.Sscanln(input, &n); err != nil {
		fmt.Printf("error when scanning for a single positive integer from the string %q: %v\n", input, err)
		return
	}
	for i := 1; i <= 10; i++ {
		fmt.Printf("%d x %d = %d\n", n, i, n*uint(i))
	}
}
