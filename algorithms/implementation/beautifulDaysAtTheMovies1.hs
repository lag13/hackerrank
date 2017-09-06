-- https://www.hackerrank.com/challenges/beautiful-days-at-the-movies

import qualified Text.Read (readEither)
-- Hackerrank's haskell version does not have "System.Exit.die" so we make our
-- own. It shouldn't get used (since hackerrank gives us only good inputs) but
-- it makes for a robust program.
import System.Exit (exitFailure)
import System.IO (stderr, hPutStrLn)
die :: String -> IO a
die err = hPutStrLn stderr err >> exitFailure

main :: IO ()
main = do
  input <- getLine
  case parseListSizeN 3 input of
    Left err -> die ("error: " ++ err)
    Right [i, j, k] -> print (numBeautifulDays i j k)

-- numBeautifulDays calculates the number of "beautiful" days.
numBeautifulDays :: Integer -> Integer -> Integer -> Integer
numBeautifulDays i j k = foldr (\a b -> b + if mod (abs (a - reverseInt a)) k == 0 then 1 else 0) 0 [i..j]

-- reverseInt reverses a base-10 integer, ex: 123 becomes 321.
reverseInt :: Integer -> Integer
reverseInt n = reverseInt' (n,0)
  where reverseInt' (0,y) = y
        reverseInt' (x,y) = let (x',y') = x `quotRem` 10
          in reverseInt' (x',10*y+y')

-- parseListSizeN parses a string of whitespace separated elements into a list
-- and asserts that the list must have a certain size.
parseListSizeN :: (Read a) => Int -> String -> Either String [a]
parseListSizeN expectSize s = let lst = words s in
  mapLeft
    (\err -> "parsing \"" ++ s ++ "\": " ++ err)
    (sequence (map readEither lst) >>= \parsedList ->
      if length parsedList /= expectSize 
        then Left ("expected a list of length " ++ (show expectSize) ++ " got " ++ (show (length parsedList)))
        else return parsedList)

-- mapLeft lifts a function over the Left data constructor.
mapLeft :: (a -> a) -> Either a b -> Either a b
mapLeft f (Left a) = Left (f a)
mapLeft _ r = r

-- readEither does Text.Read.readEither but says what we were trying to parse
-- when the error occurred.
readEither :: (Read a) => String -> Either String a
readEither s = mapLeft (\err -> "parsing \"" ++ s ++ "\": " ++ err) (Text.Read.readEither s)
