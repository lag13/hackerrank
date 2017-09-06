-- https://www.hackerrank.com/challenges/find-digits
import qualified Text.Read (readEither)
import Control.Monad.Trans.Either (EitherT(..))
-- Hackerrank's haskell version does not have "System.Exit.die". import
-- System.Exit (die) so we make our own.
import System.Exit (exitFailure)
import System.IO (stderr, hPutStrLn)
die :: String -> IO a
die err = hPutStrLn stderr err >> exitFailure

main :: IO ()
main = runEitherT go >>= either (\err -> die ("error: " ++ err)) (\results -> mapM_ print results)
  where go :: EitherT String IO [Integer]
        go = do
          n <- EitherT (fmap readEither getLine)
          nums <- getLinesParse n readEither
          return (map numDigitDivisors nums)

-- numDigitDivisors finds how many digits of the given number evenly divide said
-- number.
numDigitDivisors :: Integer -> Integer
numDigitDivisors n = let digits = filter (/=0) (getDigits n) in
  foldr (\d b -> if mod n d == 0 then b+1 else b) 0 digits
  where getDigits 0 = []
        getDigits n = let (q,r) = quotRem n 10 in r : (getDigits q)

-- getLinesParse will read in lines and parse them as it goes. Before when I
-- would read multiple lines at once I would read in all lines before parsing
-- but I wanted to try parsing as I go.
getLinesParse :: (Read a) => Int -> (String -> Either String a) -> EitherT String IO [a]
getLinesParse n parse
  | n < 0 = error "negative input to getLines"
  | n == 0 = return []
  | otherwise = do
    l <- EitherT (fmap parse getLine)
    ls <- getLinesParse (n-1) parse
    return (l:ls)

-- mapLeft lifts a function over the Left data constructor.
mapLeft :: (a -> a) -> Either a b -> Either a b
mapLeft f (Left a) = Left (f a)
mapLeft _ r = r

-- readEither does Text.Read.readEither but says what we were trying to parse
-- when the error occurred.
readEither :: (Read a) => String -> Either String a
readEither s = mapLeft (\err -> "parsing \"" ++ s ++ "\": " ++ err) (Text.Read.readEither s)
