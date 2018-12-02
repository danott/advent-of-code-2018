# https://adventofcode.com/2018/day/2
# crystal spec main.cr

require "spec"

REAL_INPUT = File.read("./input.txt")

STAR_ONE_TEST_INPUT = "
abcdef
bababc
abbcde
abcccd
aabcdd
abcdee
ababab
"

describe "checksum" do
  it "works for the test input" do
    checksum(STAR_ONE_TEST_INPUT).should eq(12)
  end

  it "finds the answer for the first star" do
    checksum(REAL_INPUT).should eq(8296)
  end
end

STAR_TWO_TEST_INPUT = "
abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz
"

describe "common_letters" do
  it "works for the test input" do
    common_letters(STAR_TWO_TEST_INPUT).should eq("fgij")
  end

  it "finds the answer for the second star" do
    common_letters(REAL_INPUT).should eq("pazvmqbftrbeosiecxlghkwud")
  end
end

def checksum(input)
  lines = input.strip.split("\n")
  pairs = lines.count { |line| has_pair(line) }
  triplets = lines.count { |line| has_triplet(line) }
  pairs * triplets
end

def has_pair(line)
  char_count(line).any? { |_, v| v == 2 }
end

def has_triplet(line)
  char_count(line).any? { |_, v| v == 3 }
end

def char_count(line)
  line.chars.each_with_object({} of Char => Int32) do |char, hash|
    hash[char] ||= 0
    hash[char] += 1
  end
end

def common_letters(input)
  lines = input.strip.split("\n")
  lines.each.with_index do |left, index|
    lines.last(lines.size - index - 1).each do |right|
      return remove_differences(left, right) if hamming_distance(left, right) == 1
    end
  end
end

def hamming_distance(left, right)
  left.chars.zip(right.chars).count { |(left, right)| left != right }
end

def remove_differences(left, right)
  left.chars.zip(right.chars).reduce("") do |same_chars, (left, right)|
    next same_chars if left != right
    "#{same_chars}#{left}"
  end
end