// go test

package day01

import "testing"

func echo(value string) string {
	return value
}
func TestEcho(t *testing.T) {
	var result = echo("123")

	if result != "123" {
		t.Error("Nope")
	}
}
