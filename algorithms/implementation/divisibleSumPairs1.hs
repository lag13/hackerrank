-- https://www.hackerrank.com/challenges/divisible-sum-pairs

main :: IO ()
main = do
  [_, k] <- fmap (map read . words) getLine
  xs <- fmap (map read . words) getLine
  print (length (filter (pairSumIsEvenlyDivisible k) (combinationsTake2 xs)))

pairSumIsEvenlyDivisible :: Integer -> (Integer, Integer) -> Bool
pairSumIsEvenlyDivisible k (x, y) = mod (x + y) k == 0

-- combinationsTake2 is a 2-combination on the given list. Another way to look
-- at that is for a list x0,x1,x2,...xn we produce the list [(xi, xj)] for 0 <=
-- i < j <= n.
combinationsTake2 :: [a] -> [(a,a)]
combinationsTake2 [] = []
combinationsTake2 xs = go xs (tail xs)
  where go _ [] = []
        go (i:is) js = map ((,) i) js ++ go is (tail js)

-- I'll keep this around for future reference, a function to produce any
-- k-combination: http://stackoverflow.com/a/22577148:
-- combinations :: Int -> [a] -> [[a]]
-- combinations k xs = combinations' (length xs) k xs
--   where combinations' n k' l@(y:ys)
--           | k' == 0   = [[]]
--           | k' >= n   = [l]
--           | null l    = []
--           | otherwise = map (y :) (combinations' (n - 1) (k' - 1) ys) ++ combinations' (n - 1) k' ys
