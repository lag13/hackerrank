-- https://www.hackerrank.com/challenges/cut-the-sticks
-- No error handling.
import Data.List (sort)

main :: IO ()
main = do
  getLine -- Don't care about the first line
  sticks <- fmap (map read . words) getLine
  mapM_ print (countCutSticks sticks)

-- countCutSticks of stick lenghts and solves the problem.
countCutSticks :: [Int] -> [Int]
countCutSticks lst = go (sort lst)
  where go [] = []
        go lst@(x:xs) = length lst : go (filter (>0) (map (-x+) xs))
