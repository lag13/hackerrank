package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	line, err := reader.ReadString('\n')
	if err != nil && err != io.EOF {
		fmt.Printf("could not read line of input: %v\n", err)
		return
	}
	var n, mask uint32
	if _, err := fmt.Sscanln(line, &n); err != nil {
		fmt.Printf("converting %q to an integer: %v\n", line, err)
		return
	}
	mask = 1
	mostConsecOnes := 0
	consecutiveOnes := 0
	for mask != 0 {
		if n&mask != 0 {
			consecutiveOnes++
		} else {
			if consecutiveOnes > mostConsecOnes {
				mostConsecOnes = consecutiveOnes
			}
			consecutiveOnes = 0
		}
		mask = mask << 1
	}
	fmt.Println(mostConsecOnes)
}
