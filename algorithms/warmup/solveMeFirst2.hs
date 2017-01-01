-- https://www.hackerrank.com/challenges/solve-me-first
-- Using the "do" syntax.
main :: IO ()
main = do
  x <- readLn
  y <- readLn
  print (x+y)

