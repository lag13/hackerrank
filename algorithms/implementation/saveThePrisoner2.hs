-- https://www.hackerrank.com/challenges/save-the-prisoner
-- No error handling

main :: IO ()
main = do
  testCases <- fmap read getLine
  nmsData <- fmap (map (map read . words)) (getLines testCases)
  mapM_ print (map (\[n,m,s] -> whoGetsPoisoned n m s) nmsData)

-- whoGetsPoisoned determines which prisoner will get poisoned given N, M, and
-- S.
whoGetsPoisoned :: Integer -> Integer -> Integer -> Integer
whoGetsPoisoned numPrisoners numSweets startingPrisoner = mod (startingPrisoner + numSweets - 2) numPrisoners + 1

-- getLines gets multiple lines from stdin.
getLines :: Int -> IO [String]
getLines n
  | n < 0 = error "must be a non-negative value"
  | n == 0 = return []
  | otherwise = getLine >>= \l -> getLines (n-1) >>= \ls -> return (l:ls)

