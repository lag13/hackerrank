-- https://www.hackerrank.com/challenges/sherlock-and-squares
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
  where go :: EitherT String IO [Int]
        go = do
          n <- EitherT (fmap readEither getLine)
          ranges <- getLinesParse n parseTuple
          return (map numSquaresBetween ranges)

-- numSquaresBetween finds the number of square numbers between two numbers
-- inclusive.
numSquaresBetween :: (Integer, Integer) -> Int
numSquaresBetween (lower, upper) = let start = ceiling (sqrt (fromIntegral lower)) in go start lower upper
  where go start lower upper
          | start*start < lower = go (start+1) lower upper
          | lower <= start*start && start*start <= upper = 1 + go (start+1) lower upper
          | otherwise = 0

-- getLinesParse will read in lines and parse them as it goes.
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

-- parseTuple parses a string into a 2-tuple.
parseTuple :: (Read a) => String -> Either String (a,a)
parseTuple s = let lst = words s in
  mapLeft
    (\err -> "parsing \"" ++ s ++ "\": " ++ err)
    (sequence (map readEither lst) >>= \parsedList ->
      let expectNumElems = 2 in
        if length parsedList /= expectNumElems 
          then Left ("expected " ++ (show expectNumElems) ++ " elements spearated by whitespace, got " ++ (show (length parsedList)))
          else return (parsedList !! 0, parsedList !! 1))

-- readEither does Text.Read.readEither but says what we were trying to parse
-- when the error occurred.
readEither :: (Read a) => String -> Either String a
readEither s = mapLeft (\err -> "parsing \"" ++ s ++ "\": " ++ err) (Text.Read.readEither s)
