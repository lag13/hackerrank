-- https://www.hackerrank.com/challenges/jumping-on-the-clouds-revisited
-- No error handling.

main :: IO ()
main = do
  [_, k] <- fmap (map read . words) getLine
  clouds <- fmap (map (\c -> if c == "0" then False else True) . words) getLine
  print (remainingEnergy k clouds)

-- remainingEnergy calculates how much energy remains after performing the jump.
remainingEnergy :: Int -> [Bool] -> Int
remainingEnergy k clouds = go 100 0 k clouds
  where go energy curCloud k clouds =
          let nextCloud = mod (k + curCloud) (length clouds)
              newEnergy = energy - if clouds !! nextCloud then 3 else 1
          in if nextCloud == 0 then newEnergy else go newEnergy nextCloud k clouds
