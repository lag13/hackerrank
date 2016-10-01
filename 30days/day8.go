package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	phoneBook, err := buildPhoneBook(scanner)
	if err != nil {
		fmt.Printf("error building phone book: %v\n", err)
		return
	}
	for scanner.Scan() {
		number, ok := phoneBook[scanner.Text()]
		if ok {
			fmt.Printf("%s=%s\n", scanner.Text(), number)
		} else {
			fmt.Println("Not found")
		}
	}
	if scanner.Err() != nil {
		fmt.Printf("error when scanning for names to lookup: %v\n", scanner.Err())
		return
	}
}

func buildPhoneBook(scanner *bufio.Scanner) (map[string]string, error) {
	if !scanner.Scan() {
		if scanner.Err() != nil {
			return nil, fmt.Errorf("error scanning first line: %v", scanner.Err())
		}
	}
	var phoneBookSize uint
	if _, err := fmt.Sscanln(scanner.Text(), &phoneBookSize); err != nil {
		return nil, fmt.Errorf("error parsing first line for a single positive integer: %v", err)
	}
	phoneBook := map[string]string{}
	for i := 0; i < int(phoneBookSize); i++ {
		if !scanner.Scan() {
			if scanner.Err() != nil {
				return nil, fmt.Errorf("error scanning line %d: %v", i+1, scanner.Err())
			}
			return nil, fmt.Errorf("got %d phone book entries, expected %d", i, phoneBookSize)
		}
		var name, number string
		if _, err := fmt.Sscanln(scanner.Text(), &name, &number); err != nil {
			return nil, fmt.Errorf("error parsing line %q for two strings: %v", scanner.Text(), err)
		}
		phoneBook[name] = number
	}
	return phoneBook, nil
}
