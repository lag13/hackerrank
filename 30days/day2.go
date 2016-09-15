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
	var mealCost float32
	if _, err := fmt.Sscanf(input, "%f\n", &mealCost); err != nil {
		fmt.Printf("could not parse the meal cost %q: %v\n", input, err)
		return
	}
	input, err = reader.ReadString('\n')
	if err == nil {
		input = input[:len(input)-1]
	}
	var tipPercent int
	if _, err := fmt.Sscanf(input, "%d\n", &tipPercent); err != nil {
		fmt.Printf("could not parse the tip percent %q: %v\n", input, err)
		return
	}
	input, err = reader.ReadString('\n')
	if err == nil {
		input = input[:len(input)-1]
	}
	var taxPercent int
	if _, err := fmt.Sscanf(input, "%d\n", &taxPercent); err != nil {
		fmt.Printf("could not parse the tax percent %q: %v\n", input, err)
		return
	}
	tip := mealCost * (float32(tipPercent) / 100.0)
	tax := mealCost * (float32(taxPercent) / 100.0)
	fmt.Printf("The total meal cost is %d dollars.\n", int(mealCost+tip+tax+0.5))
}
