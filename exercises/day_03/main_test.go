// go test

package day03

import (
	"io/ioutil"
	"regexp"
	"strconv"
	"strings"
	"testing"
)

var REAL_INPUT, _ = ioutil.ReadFile("./input.txt")

const TEST_INPUT = `
#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2
`

type position struct {
	left int
	top  int
}

type claim struct {
	id int
	position
	width  int
	height int
}

func buildClaims(input string) []claim {
	var digitRegex = regexp.MustCompile("[0-9]+")
	var lines = strings.Split(strings.TrimSpace(input), "\n")
	var claims = []claim{}
	for _, line := range lines {
		var digits []int
		for _, stringDigit := range digitRegex.FindAllString(line, -1) {
			var i, _ = strconv.Atoi(stringDigit)
			digits = append(digits, i)
		}
		var c = claim{id: digits[0], position: position{left: digits[1], top: digits[2]}, width: digits[3], height: digits[4]}
		claims = append(claims, c)
	}
	return claims
}

func buildUsage(claims []claim) map[position]int {
	var usage = map[position]int{}
	for _, c := range claims {
		for l := 0; l < c.width; l++ {
			for t := 0; t < c.height; t++ {
				var p = position{left: c.position.left + l, top: c.position.top + t}
				usage[p] += 1
			}
		}
	}
	return usage
}

func countOverlappingSquares(input string) int {
	var claims = buildClaims(input)
	var usage = buildUsage(claims)
	var count = 0
	for _, c := range usage {
		if c > 1 {
			count++
		}
	}
	return count
}

func findNotOverlappingClaimId(input string) int {
	var claims = buildClaims(input)
	var usage = buildUsage(claims)
	for _, c := range claims {
		var isOverlapping = false
		for l := 0; l < c.width; l++ {
			for t := 0; t < c.height; t++ {
				var p = position{left: c.position.left + l, top: c.position.top + t}
				if usage[p] > 1 {
					isOverlapping = true
				}
			}
		}
		if isOverlapping == false {
			return c.id
		}
	}
	panic("Could not find claim id")
}

func TestStarOneExample(t *testing.T) {
	var result = countOverlappingSquares(TEST_INPUT)
	if result != 4 {
		t.Errorf("Expected 4, got %d", result)
	}
}

func TestFindStarOne(t *testing.T) {
	var result = countOverlappingSquares(string(REAL_INPUT))
	if result != 118840 {
		t.Errorf("Expected 118840, got %d", result)
	}
}

func TestStarTwoExample(t *testing.T) {
	var result = findNotOverlappingClaimId(TEST_INPUT)
	if result != 3 {
		t.Errorf("Expected 3, got %d", result)
	}
}

func TestFindStarTwo(t *testing.T) {
	var result = findNotOverlappingClaimId(string(REAL_INPUT))
	if result != 919 {
		t.Errorf("Expected 919, got %d", result)
	}
}
