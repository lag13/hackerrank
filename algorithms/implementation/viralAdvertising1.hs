-- https://www.hackerrank.com/challenges/strange-advertising

import qualified Text.Read (readEither)
-- Hackerrank's haskell version does not have "System.Exit.die" so we make our
-- own. It shouldn't get used (since hackerrank gives us only good inputs) but
-- it makes for a robust program.
import System.Exit (exitFailure)
import System.IO (stderr, hPutStrLn)
die :: String -> IO a
die err = hPutStrLn stderr err >> exitFailure

main :: IO ()
main = fmap readEither getLine >>=
  either (\err -> die ("error: " ++ err)) (\r -> print (howManyLikes r))

-- howManyLikes determines how many likes occur in a given number of days.
howManyLikes :: Integer -> Integer
howManyLikes = go 5
  where go _ 0 = 0
        go numAdvertised days = let numberLiked = div numAdvertised 2 in
          numberLiked + go (3*numberLiked) (days-1)

-- mapLeft lifts a function over the Left data constructor.
mapLeft :: (a -> a) -> Either a b -> Either a b
mapLeft f (Left a) = Left (f a)
mapLeft _ r = r

-- readEither does Text.Read.readEither but says what we were trying to parse
-- when the error occurred.
readEither :: (Read a) => String -> Either String a
readEither s = mapLeft (\err -> "parsing \"" ++ s ++ "\": " ++ err) (Text.Read.readEither s)
