-- https://www.hackerrank.com/challenges/find-digits
-- No error handling.

main :: IO ()
main = do
  n <- fmap read getLine
  nums <- fmap (map read) (getLines n)
  mapM_ print (map numDigitDivisors nums)

-- numDigitDivisors finds how many digits of the given number evenly divide said
-- number.
numDigitDivisors :: Integer -> Integer
numDigitDivisors n = let digits = filter (/=0) (getDigits n) in
  foldr (\d b -> if mod n d == 0 then b+1 else b) 0 digits
  where getDigits 0 = []
        getDigits n = let (q,r) = quotRem n 10 in r : (getDigits q)

-- getLines reads multiple lines from stdin.
getLines :: Int -> IO [String]
getLines n
  | n < 0 = error "negative input to getLines"
  | n == 0 = return []
  | otherwise = do
    l <- getLine
    ls <- getLines (n-1)
    return (l:ls)
