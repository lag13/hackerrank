package main

import (
	"fmt"
	"os"
)

func main() {
	var n uint
	// I don't like how if there is bad input it will leave it in Stdin. Should
	// I just read the whole line as a string and parse it as I've been doing?
	// But what happens if there is more than one input line? Like if we 'cat'
	// a file into this program.
	//
	// TODO: I just noticed that I was pulling from Stdout but it was still
	// working? What's up with that?
	if _, err := fmt.Fscanln(os.Stdin, &n); err != nil {
		fmt.Printf("error scannning+parsing line for single positive integer: %v\n", err)
		return
	}
	fmt.Println(factorial(int(n)))
}

func factorial(n int) int {
	if n == 0 {
		return 1
	}
	return n * factorial(n-1)
}
