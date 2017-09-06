-- https://www.hackerrank.com/challenges/strange-advertising
-- No error handling.

main :: IO ()
main = fmap read getLine >>= print . howManyLikes

-- howManyLikes determines how many likes occur in a given number of days.
howManyLikes :: Integer -> Integer
howManyLikes = go 5
  where go _ 0 = 0
        go numAdvertised days = let numberLiked = div numAdvertised 2 in
          numberLiked + go (3*numberLiked) (days-1)
