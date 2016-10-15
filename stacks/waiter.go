// https://www.hackerrank.com/challenges/waiter

// In this solution I'm trying to inline code more rather than create all these
// little functions just for the sake of refactoring a la Jonathan Blow:
// https://www.youtube.com/watch?v=JjDsP5n2kSM. His basic idea is that if some
// function does a large sequence of actions then he would rather see those
// actions listed out one after the other instead of breaking up that function
// into smaller functions and calling those functions one after the other. His
// basic reasoning is that code is easier to understand if there are less parts
// that communicate with each other and he considers a function to be one more
// communicating partner. If a function really does need to be used in multiple
// places then it is okay to define this function, but if you are defining a
// function just for the sake of refactoring and this function only gets used
// in one place, don't do that. Instead, where that function would be called,
// open up a new scope (i.e just put your code inside of curly braces), so
// variables can be declared locally to that block, write your code in that
// block, and give a meaningful comment at the top of this block indicating
// what it does. He says the benefits are basically:
//
// 1. Reading the code is more straightforward because you just read a sequence
// of steps one after another and don't have to go hunting for function
// definitions to figure out what is happening when you reach the function
// call.
// 2. When you define a function, even if you only intend to use it in one
// place, it is now in the global scope meaning that it *could* be used in
// other places and extra care has to be taken if you want to change how that
// function operates. Defining this one off function essentially obfuscates
// whether it was intended to be reusable or if it was just a one off thing.
//
// Like everything, there are probably exceptions to this rule but I've never
// tried it before. I've always been sort of gung-ho about breaking up big
// functions into smaller ones whenever possible so this will be interesting to
// try.
package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
	"strconv"
)

func main() {
	var plates *plateStack
	var q int
	{ // Read in input
		nextInt := func(s *bufio.Scanner) (int, error) {
			if !s.Scan() {
				if s.Err() != nil {
					return 0, s.Err()
				}
				return 0, io.EOF
			}
			return strconv.Atoi(s.Text())
		}
		s := bufio.NewScanner(os.Stdin)
		s.Split(bufio.ScanWords)
		n, err := nextInt(s)
		if err != nil {
			log.Panic(err)
		}
		q, err = nextInt(s)
		if err != nil {
			log.Panic(err)
		}
		plates = &plateStack{}
		for i := 0; i < n; i++ {
			num, err := nextInt(s)
			if err != nil {
				log.Panic(err)
			}
			plates.push(num)
		}
	}
	primes := []int{}
	{ // Get our prime numbers
		n := 2
		i := 0
		for i < q {
			isPrime := true
			for _, p := range primes {
				if n%p == 0 {
					isPrime = false
					break
				}
			}
			if isPrime {
				primes = append(primes, n)
				i++
			}
			n++
		}
	}
	bStacks := []*plateStack{}
	// Solve the problem by building our "B" stacks of plates and finding out
	// what the last "A" stack will look like.
	{
		for _, p := range primes {
			bStack := &plateStack{}
			tempPlates := &plateStack{}
			for len(*plates) > 0 {
				if plates.peek()%p == 0 {
					bStack.push(plates.pop())
				} else {
					tempPlates.push(plates.pop())
				}
			}
			bStacks = append(bStacks, bStack)
			plates = tempPlates
		}
	}
	// Print out our solution
	for b := 0; b < len(bStacks); b++ {
		bStack := bStacks[b]
		for len(*bStack) > 0 {
			fmt.Println(bStack.pop())
		}
	}
	for len(*plates) > 0 {
		fmt.Println(plates.pop())
	}
}

type plateStack []int

func (s *plateStack) push(i int) {
	*s = append(*s, i)
}

func (s *plateStack) pop() int {
	i := (*s)[len(*s)-1]
	*s = (*s)[:len(*s)-1]
	return i
}

func (s plateStack) peek() int {
	return s[len(s)-1]
}
