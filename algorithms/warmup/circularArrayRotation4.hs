-- https://www.hackerrank.com/challenges/circular-array-rotation

-- For most hackerrank problems I try to handle any potential error gracefully
-- and print out a descriptive error message when such an error occurs. This
-- detailed handling of errors probably comes from my experience using Go. This
-- error handling practice is probably the right thing to do because you:
--   1. Get practice doing it
--   2. If your tiny program ever starts to grow then a solid base is there.
--   3. Can make developing faster when things go wrong because you'll have nice
--   error messages.
-- But for certain problems it is totally acceptable to let your program crash
-- on bad inputs. I like the conciseness with this solution even though it does
-- come at the cost of poor error handling.

main :: IO ()
main = do
  nkqInput <- fmap words getLine
  let k = read (nkqInput !! 1)
  let q = read (nkqInput !! 2)
  arr <- fmap (rotateArray k . map read . words) getLine :: IO [Int]
  indices <- fmap (map read) (getLines q)
  mapM_ print (map (\i -> arr !! i) indices)

-- rotateArray performs a right circular rotation on a given array.
rotateArray :: Int -> [a] -> [a]
rotateArray n arr = let l = length arr in
  take l (drop (l - mod n l) (cycle arr))

-- getLines reads a specified number of lines from stdin.
getLines :: Int -> IO [String]
getLines n
  | n < 0 = error "negative input to getLines function"
  | n == 0 = return []
  | otherwise = do
      l <- getLine
      ls <- getLines (n - 1)
      return (l:ls)
