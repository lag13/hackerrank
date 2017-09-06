-- https://www.hackerrank.com/challenges/jumping-on-the-clouds-revisited

import qualified Text.Read (readEither)
-- Hackerrank's haskell version does not have "System.Exit.die". import
-- System.Exit (die) so we make our own.
import System.Exit (exitFailure)
import System.IO (stderr, hPutStrLn)
die :: String -> IO a
die err = hPutStrLn stderr err >> exitFailure

main :: IO ()
main = do
  nk <- fmap (parseListSizeN 2) getLine
  case nk of
    Left err -> die ("error: " ++ err)
    Right [_, k] -> do
      clouds <- fmap (map (\c -> if c == "0" then False else True) . words) getLine
      print (remainingEnergy k clouds)


-- remainingEnergy calculates how much energy remains after performing the jump.
remainingEnergy :: Int -> [Bool] -> Int
remainingEnergy k clouds = go 100 0 k clouds
  where go energy curCloud k clouds =
          let nextCloud = mod (k + curCloud) (length clouds)
              newEnergy = energy - if clouds !! nextCloud then 3 else 1
          in if nextCloud == 0 then newEnergy else go newEnergy nextCloud k clouds

-- parseListSizeN parses a string of whitespace separated elements into a list
-- and asserts that the list must have a certain size.
parseListSizeN :: (Read a) => Int -> String -> Either String [a]
parseListSizeN expectSize s = let lst = words s in
  mapLeft
    (\err -> "parsing \"" ++ s ++ "\": " ++ err)
    (sequence (map readEither lst) >>= \parsedList ->
      if length parsedList /= expectSize 
        then Left ("expected " ++ (show expectSize) ++ " elements spearated by whitespace, got " ++ (show (length parsedList)))
        else return parsedList)

-- mapLeft lifts a function over the Left data constructor.
mapLeft :: (a -> a) -> Either a b -> Either a b
mapLeft f (Left a) = Left (f a)
mapLeft _ r = r

-- readEither does Text.Read.readEither but says what we were trying to parse
-- when the error occurred.
readEither :: (Read a) => String -> Either String a
readEither s = mapLeft (\err -> "parsing \"" ++ s ++ "\": " ++ err) (Text.Read.readEither s)
