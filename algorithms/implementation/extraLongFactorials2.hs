-- https://www.hackerrank.com/challenges/extra-long-factorials
-- No error handling.

main :: IO ()
main = getLine >>= print . factorial . read

-- factorial calculates the factorial of an integer.
factorial :: Integer -> Integer
factorial n = product [1..n]
