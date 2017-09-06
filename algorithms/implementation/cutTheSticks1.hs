-- https://www.hackerrank.com/challenges/cut-the-sticks
import qualified Text.Read (readEither)
import Control.Monad.Trans.Either (EitherT(..))
import Control.Monad.Trans.Class (lift)
import Data.List (sort)
-- Hackerrank's haskell version does not have "System.Exit.die" so we make our
-- own.
import System.Exit (exitFailure)
import System.IO (stderr, hPutStrLn)
die :: String -> IO a
die err = hPutStrLn stderr err >> exitFailure

main :: IO ()
main = runEitherT go >>= either (\err -> die ("error: " ++ err)) (\result -> mapM_ print result)
  where go :: EitherT String IO [Int]
        go = do
          lift getLine -- Don't care about the first line
          sticks <- EitherT (fmap parseList getLine)
          return (countCutSticks sticks)

-- countCutSticks of stick lenghts and solves the problem.
countCutSticks :: [Int] -> [Int]
countCutSticks lst = go (sort lst)
  where go [] = []
        go lst@(x:xs) = length lst : go (filter (>0) (map (-x+) xs))

-- mapLeft lifts a function over the Left data constructor.
mapLeft :: (a -> a) -> Either a b -> Either a b
mapLeft f (Left a) = Left (f a)
mapLeft _ r = r

-- parseList parses a string of whitespace separated elements into a list.
parseList :: (Read a) => String -> Either String [a]
parseList s = mapLeft 
  (\err -> "parsing \"" ++ s ++ "\": " ++ err)
  ((sequence . map readEither . words) s)

-- readEither does Text.Read.readEither but says what we were trying to parse
-- when the error occurred.
readEither :: (Read a) => String -> Either String a
readEither s = mapLeft (\err -> "parsing \"" ++ s ++ "\": " ++ err) (Text.Read.readEither s)
