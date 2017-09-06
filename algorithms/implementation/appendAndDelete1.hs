-- https://www.hackerrank.com/challenges/append-and-delete
import qualified Text.Read (readEither)
import Data.List (isPrefixOf)
-- Hackerrank's haskell version does not have "System.Exit.die". import
-- System.Exit (die) so we make our own.
import System.Exit (exitFailure)
import System.IO (stderr, hPutStrLn)
die :: String -> IO a
die err = hPutStrLn stderr err >> exitFailure

main :: IO ()
main = do
  initialStr <- getLine
  target <- getLine
  ek <- fmap readEither getLine
  case ek of
    Left err -> die ("error: " ++ err)
    Right k -> putStrLn (if conversionIsPossible k initialStr target then "Yes" else "No")

-- conversionIsPossible determines if converting from one string to another in
-- the specified moves is possible. Two examples I thought of to help figure out
-- this algorithm:
--
--  "a" -> "abc", 5 YES
--  "abc" -> "abc", 7 YES
conversionIsPossible :: Int -> String -> String -> Bool
conversionIsPossible k s target
  | k < 0 = False
  | isPrefixOf s target && go (k - (length target - length s)) = True
  | otherwise = conversionIsPossible (k-1) (if s == "" then "" else init s) target
  where go numMovesToWaste
          | numMovesToWaste < 0 = False
          | even numMovesToWaste = True
          | otherwise = False

-- mapLeft lifts a function over the Left data constructor.
mapLeft :: (a -> a) -> Either a b -> Either a b
mapLeft f (Left a) = Left (f a)
mapLeft _ r = r

-- readEither does Text.Read.readEither but says what we were trying to parse
-- when the error occurred.
readEither :: (Read a) => String -> Either String a
readEither s = mapLeft (\err -> "parsing \"" ++ s ++ "\": " ++ err) (Text.Read.readEither s)
