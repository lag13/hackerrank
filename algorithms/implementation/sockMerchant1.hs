-- https://www.hackerrank.com/challenges/sock-merchant

import Data.List ((\\))

main :: IO ()
main = getLine >> do
  (socks) <- fmap (map read . words) getLine :: IO [Int]
  print (numPossiblePairs socks)

numPossiblePairs :: (Eq a) => [a] -> Int
numPossiblePairs [] = 0
numPossiblePairs (x:ys) =
  let noXs = (filter (\y -> x /= y) ys)
      onlyXs = (x:(ys \\ noXs))
  in div (length onlyXs) 2 + numPossiblePairs noXs
  
