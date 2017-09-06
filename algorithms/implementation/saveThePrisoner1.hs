-- https://www.hackerrank.com/challenges/save-the-prisoner

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
          testCases <- EitherT (fmap readEither getLine)
          nmsData <- EitherT (fmap (sequence . map (parseListSizeN 3)) (getLines testCases))
          return (map (\[n,m,s] -> whoGetsPoisoned n m s) nmsData)

-- whoGetsPoisoned determines which prisoner will get poisoned given N, M, and
-- S.
whoGetsPoisoned :: Integer -> Integer -> Integer -> Integer
whoGetsPoisoned numPrisoners numSweets startingPrisoner = mod (startingPrisoner + numSweets - 2) numPrisoners + 1

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

-- getLines gets multiple lines from stdin.
getLines :: Int -> IO [String]
getLines n
  | n < 0 = error "must be a non-negative value"
  | n == 0 = return []
  | otherwise = getLine >>= \l -> getLines (n-1) >>= \ls -> return (l:ls)

-- mapLeft lifts a function over the Left data constructor.
mapLeft :: (a -> a) -> Either a b -> Either a b
mapLeft f (Left a) = Left (f a)
mapLeft _ r = r

-- readEither does Text.Read.readEither but says what we were trying to parse
-- when the error occurred.
readEither :: (Read a) => String -> Either String a
readEither s = mapLeft (\err -> "parsing \"" ++ s ++ "\": " ++ err) (Text.Read.readEither s)
