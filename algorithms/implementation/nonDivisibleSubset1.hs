-- https://www.hackerrank.com/challenges/non-divisible-subset
import qualified Text.Read (readEither)
import Control.Monad.Trans.Either (EitherT(..))
-- Hackerrank's haskell version does not have "System.Exit.die" so we make our
-- own.
import System.Exit (exitFailure)
import System.IO (stderr, hPutStrLn)
die :: String -> IO a
die err = hPutStrLn stderr err >> exitFailure

main :: IO ()
main = runEitherT go >>= either (\err -> die ("error: " ++ err)) (\result -> print result)
  where go :: EitherT String IO Int
        go = do
          k <- EitherT (fmap parseK getLine)
          set <- EitherT (fmap parseList getLine)
          return (findLargestDivisibleSubset k set)

-- findLargestDivisibleSubset solves the problem.
findLargestDivisibleSubset :: Int -> [Int] -> Int
findLargestDivisibleSubset k set = 0

-- powerSet returns the power set of a set.
powerSet :: [a] -> [[a]]
powerSet = foldr (\a b -> map (a:) b ++ b) [[]]

-- combinations performs any k-combination. It is undefined for negative k.
combinations :: Int -> [a] -> [[a]]
combinations 0 _ = [[]]
combinations k l
  | k > length l = []
  | otherwise = map (head l:) (combinations (k-1) (tail l)) ++ combinations k (tail l)

-- mapLeft lifts a function over the Left data constructor.
mapLeft :: (a -> a) -> Either a b -> Either a b
mapLeft f (Left a) = Left (f a)
mapLeft _ r = r

-- parseK parses the second element from a string containing two elements.
parseK :: (Read a) => String -> Either String a
parseK s = mapLeft 
  (\err -> "parsing \"" ++ s ++ "\": " ++ err)
  ((sequence . map readEither . words) s >>= \parsedList ->
    let expectSize = 2 in
      if length parsedList /= expectSize
        then Left ("expected a list of length " ++ (show expectSize) ++ " got " ++ (show (length parsedList)))
        else return (parsedList !! 1))

-- parseList parses a string of whitespace separated elements into a list.
parseList :: (Read a) => String -> Either String [a]
parseList s = mapLeft (\err -> "parsing \"" ++ s ++ "\": " ++ err)
  ((sequence . map readEither . words) s)

-- readEither does Text.Read.readEither but says what we were trying to parse
-- when the error occurred.
readEither :: (Read a) => String -> Either String a
readEither s = mapLeft (\err -> "parsing \"" ++ s ++ "\": " ++ err) (Text.Read.readEither s)
