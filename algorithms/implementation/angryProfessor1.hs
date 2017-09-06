-- https://www.hackerrank.com/challenges/angry-professor
main :: IO ()
main = do
  n <- fmap read getLine
  inputs <- getLines (2*n)
  let cancelledClasses = (map (\(k, times) -> classIsCancelled k times) (inputToThresholdArrivalPairs inputs))
  mapM_ putStrLn (map (\b -> if b then "YES" else "NO") cancelledClasses)

-- classIsCancelled determines if the class will be cancelled.
classIsCancelled :: Int -> [Int] -> Bool
classIsCancelled threshold arrivalTimes = length (filter (<=0) arrivalTimes) < threshold

-- inputToThresholdArrivalPairs converts the list of strings we receive from the
-- input into the information relevant to the problem.
inputToThresholdArrivalPairs :: [String] -> [(Int, [Int])]
inputToThresholdArrivalPairs [] = []
inputToThresholdArrivalPairs (a:b:xs) = let [_, k] = words a in
  (read k, map read (words b)) : inputToThresholdArrivalPairs xs

getLines :: Int -> IO [String]
getLines n
  | n < 0 = error "must be a non-negative value"
  | n == 0 = return []
  | otherwise = getLine >>= \l -> getLines (n-1) >>= \ls -> return (l:ls)
