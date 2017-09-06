-- https://www.hackerrank.com/challenges/apple-and-orange

-- This solution does not do any error handling, if bad input is given the
-- program will crash.
main :: IO ()
main = do
  (hleft, hright) <- fmap parseTuple getLine
  (appleTreeLoc, orangeTreeLoc) <- fmap parseTuple getLine
  getLine -- We don't really need to know the number of apples and oranges because they'll be apparent
  appleDistances <- fmap (map read . words) getLine
  orangeDistances <- fmap (map read . words) getLine
  print (numWithinRange hleft hright (map (+appleTreeLoc) appleDistances))
  print (numWithinRange hleft hright (map (+orangeTreeLoc) orangeDistances))
  where numWithinRange :: (Ord a) => a -> a -> [a] -> Int
        numWithinRange lowerBound upperBound xs = length (filter (\x -> lowerBound <= x && x <= upperBound) xs)

-- parseTuple parses a string containing two integers into a tuple of those two
-- integers.
parseTuple :: String -> (Int, Int)
parseTuple s = let tup = map read (words s) in (tup !! 0, tup !! 1)
