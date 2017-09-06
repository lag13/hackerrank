-- https://www.hackerrank.com/challenges/sherlock-and-squares
-- No error handling.
main :: IO ()
main = do
  n <- fmap read getLine
  ranges <- getLinesParse n parseTuple
  mapM_ print (map numSquaresBetween ranges)

-- numSquaresBetween finds the number of square numbers between two numbers
-- inclusive.
numSquaresBetween :: (Integer, Integer) -> Int
numSquaresBetween (lower, upper) = let start = ceiling (sqrt (fromIntegral lower)) in go start lower upper
  where go start lower upper
          | start*start < lower = go (start+1) lower upper
          | lower <= start*start && start*start <= upper = 1 + go (start+1) lower upper
          | otherwise = 0

-- getLinesParse will read in lines and parse them as it goes.
getLinesParse :: (Read a) => Int -> (String -> a) -> IO [a]
getLinesParse n parse
  | n < 0 = error "negative input to getLines"
  | n == 0 = return []
  | otherwise = do
    l <- fmap parse getLine
    ls <- getLinesParse (n-1) parse
    return (l:ls)

-- parseTuple parses a string into a 2-tuple.
parseTuple :: (Read a) => String -> (a,a)
parseTuple s = let [a,b] = map read (words s) in (a, b)
