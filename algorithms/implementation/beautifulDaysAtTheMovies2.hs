-- https://www.hackerrank.com/challenges/beautiful-days-at-the-movies

-- No error handling.

main :: IO ()
main = do
  [i, j, k] <- fmap (map read . words) getLine
  print (numBeautifulDays i j k)

-- numBeautifulDays calculates the number of "beautiful" days.
numBeautifulDays :: Integer -> Integer -> Integer -> Integer
numBeautifulDays i j k = foldr (\a b -> b + if mod (abs (a - reverseInt a)) k == 0 then 1 else 0) 0 [i..j]

-- reverseInt reverses a base-10 integer, ex: 123 becomes 321.
reverseInt :: Integer -> Integer
reverseInt n = reverseInt' (n,0)
  where reverseInt' (0,y) = y
        reverseInt' (x,y) = let (x',y') = x `quotRem` 10
          in reverseInt' (x',10*y+y')
