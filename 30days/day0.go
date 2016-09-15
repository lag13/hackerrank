package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	input, err := reader.ReadString('\n')
	if err == nil {
		input = input[:len(input)-1]
	}
	fmt.Println("Hello, World.")
	fmt.Println(input)
}
