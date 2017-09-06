-- https://www.hackerrank.com/challenges/mini-max-sum
import Data.List (sort)
import Text.Printf (printf)

main :: IO ()
main = do
  input <- getLine
  case parseSortedArray input of
    Left err -> putStrLn ("error: parsing integer \"" ++ err ++ "\": input was \"" ++ input ++ "\"")
    Right arr ->
      let numToSum = 4
          maxSum = (sum (take numToSum arr))
          minSum = (sum (take numToSum (reverse arr)))
      in printf "%d %d\n" maxSum minSum
  where parseSortedArray :: String -> Either String [Integer]
        parseSortedArray = fmap sort . sequence . map readsEither . words

-- readsEither takes a string and parses it into some datatype 'a'. If the
-- parsing fails then the string that was being parsed is returned in Left.
readsEither :: (Read a) => String -> Either String a
readsEither x = case reads x of
  [(y, "")] -> Right y
  _ -> Left x
