-- https://www.hackerrank.com/challenges/extra-long-factorials

import qualified Text.Read (readEither)
-- Hackerrank's haskell version does not have "System.Exit.die". import
-- System.Exit (die) so we make our own.
import System.Exit (exitFailure)
import System.IO (stderr, hPutStrLn)
die :: String -> IO a
die err = hPutStrLn stderr err >> exitFailure

main :: IO ()
main = fmap readEither getLine >>= \eitherStrNum ->
  case eitherStrNum of
    Left err -> die ("error: " ++ err)
    Right r -> print (factorial r)

-- factorial calculates the factorial of an integer.
factorial :: Integer -> Integer
factorial n = product [1..n]

-- mapLeft lifts a function over the Left data constructor.
mapLeft :: (a -> a) -> Either a b -> Either a b
mapLeft f (Left a) = Left (f a)
mapLeft _ r = r

-- readEither does Text.Read.readEither but says what we were trying to parse
-- when the error occurred.
readEither :: (Read a) => String -> Either String a
readEither s = mapLeft (\err -> "parsing \"" ++ s ++ "\": " ++ err) (Text.Read.readEither s)
