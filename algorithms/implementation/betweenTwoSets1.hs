-- https://www.hackerrank.com/challenges/between-two-sets

main :: IO ()
main = do
  getLine -- we don't really care about this first line
  as <- fmap (map read . words) getLine
  bs <- fmap (map read . words) getLine
  print (length (intsBetweenSets as bs))

-- intsBetweenSets finds out all the numbers that are "between" two sets. If
-- either of the two sets are empty then I believe the amount of numbers between
-- two sets is infinite so I'm not accounting for those cases.
intsBetweenSets :: [Integer] -> [Integer] -> [Integer]
intsBetweenSets as (b:bs) =
  let commonFactorsOfB = filter (\x -> all (\b -> mod b x == 0) bs) (allFactors b) in
  filter (\x -> all (\a -> mod x a == 0) as) commonFactorsOfB

-- allFactors finds all the factors of a postitive integer.
allFactors :: Integer -> [Integer]
allFactors num
  | num <= 0 = error "can only find factors of positive numbers"
  | otherwise = foldr go [] [1..num]
  where go a b
          | mod num a == 0 = a:b
          | otherwise = b
