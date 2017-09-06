-- https://www.hackerrank.com/challenges/utopian-tree

main :: IO ()
main = do
  n <- fmap read getLine
  heights <- fmap (map read) (getLines n)
  mapM_ print (map (growNCycles 1) heights)

growNCycles :: Integer -> Integer -> Integer
growNCycles n cycles = go n cycles True
  where go n 0 _ = n
        go n cycles True = go (2*n) (cycles-1) False
        go n cycles False = go (1+n) (cycles-1) True

getLines :: Int -> IO [String]
getLines n
  | n < 0 = error "must be non-negative"
  | n == 0 = return []
  | otherwise = do
      l <- getLine
      ls <- getLines (n-1)
      return (l:ls)
