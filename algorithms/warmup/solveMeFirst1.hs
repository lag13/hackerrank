-- https://www.hackerrank.com/challenges/solve-me-first
-- Without using the "do" syntax.
main :: IO ()
main =
  readLn >>= \x ->
  readLn >>= \y ->
  print (x+y)
