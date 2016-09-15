package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	input, err := reader.ReadString('\n')
	if err != nil && err != io.EOF {
		fmt.Printf("error when reading line of intput from stdin: %v\n", err)
		return
	}
	var n int
	if _, err := fmt.Sscanln(input, &n); err != nil {
		fmt.Printf("error when scanning single integer token from the string %q: %v\n", input, err)
		return
	}
	fmt.Println(classifyN(n))
}

func classifyN(n int) string {
	if n%2 != 0 {
		return "Weird"
	}
	if 2 <= n && n <= 5 {
		return "Not Weird"
	}
	if 6 <= n && n <= 20 {
		return "Weird"
	}
	return "Not Weird"
}
