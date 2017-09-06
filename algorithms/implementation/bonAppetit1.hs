-- https://www.hackerrank.com/challenges/bon-appetit

main = do
  [_, k] <- fmap (map read . words) getLine
  costs <- fmap (map read . words) getLine
  brianCharged <- fmap read getLine
  let correctCharge = (calculateCharge k costs)
  -- The challenge stated: "If Brian did not overcharge Anna..."
  if brianCharged <= correctCharge then putStrLn "Bon Appetit" else print (brianCharged - correctCharge)

-- calculateCharge calculates what the charge to Anna should be.
calculateCharge :: Int -> [Integer] -> Integer
calculateCharge k costs = div (sum (removeNth k costs)) 2

-- removeNth removes the nth item from a list.
removeNth :: Int -> [a] -> [a]
removeNth n xs = take n xs ++ drop (n + 1) xs
