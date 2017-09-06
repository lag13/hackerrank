-- https://www.hackerrank.com/challenges/angry-professor
-- An implementation with some error handling. My only complaint is that since I
-- read all input before processing it you don't see the errors until the end.
import qualified Text.Read as R (readEither)
import Control.Monad.Trans.Either (EitherT(..))

-- Hackerrank's haskell version does not have "System.Exit.die". import
-- System.Exit (die) so we make our own.
import System.Exit (exitFailure)
import System.IO (stderr, hPutStrLn)
die :: String -> IO a
die err = hPutStrLn stderr err >> exitFailure

main :: IO ()
main = (runEitherT go) >>= \r ->
  case r of
    Left err -> die ("error: " ++ err)
    Right results -> mapM_ putStrLn results
  where go :: EitherT String IO [String]
        go = do
          n <- EitherT (fmap readEither getLine)
          thresholdArrivalPairs <- EitherT (fmap inputToThresholdArrivalPairs (getLines (2*n)))
          let cancelledClasses = map (\(k, times) -> classIsCancelled k times) thresholdArrivalPairs
          return (map (\b -> if b then "YES" else "NO") cancelledClasses)

-- classIsCancelled determines if the class will be cancelled.
classIsCancelled :: Int -> [Int] -> Bool
classIsCancelled threshold arrivalTimes = length (filter (<=0) arrivalTimes) < threshold

-- TODO: Just curious, could we change this inputToThresholdArrivalPairs
-- function to take one string and return one (Int, [Int])? Perhaps it could be
-- a state monad so it remembers which kind of parsing it should be doing (i.e
-- the first or second line)? Also, what would be a neat way to attempt to parse
-- the lines as we read them in with the getLines function? I was wondering if
-- there was a way to combine that existing function with something else to get
-- the job done but that is probably not possible, the parsing probably needs to
-- happen as getLines is executing which. But it's a shame that we need the
-- parsing logic coupled to the reading input logic. It would be nice if we
-- could separate them somehow. Doing something like that is, I think, simpler
-- if the lines are taken and parsed one at a time. In that case getLines could
-- just take an extra function f which does the parsing. But it's trickier for
-- this problem because the lines must be taken in pairs. We could make it so
-- getLines takes two functions and does two getLine's at a time but now it
-- sounds like we're coupling input logic with parsing logic. Perhaps the
-- getLines function could just take an integer which indicates how to group the
-- input lines, yeah I think that could work. So it would be getLineGroups
-- numGroups groupSize, so if we called it like getLineGroups 3 2 then it would
-- read in 6 lines. But that doesn't solve my question of parsing things as we
-- go... Think about this.

-- inputToThresholdArrivalPairs converts the list of strings we receive from the
-- input into the information relevant to the problem.
inputToThresholdArrivalPairs :: [String] -> Either String [(Int, [Int])]
inputToThresholdArrivalPairs [] = Right []
inputToThresholdArrivalPairs (nkLine:arrivalsLine:xs) = do
  [_, k] <- parseListSizeN 2 nkLine
  arrivals <- parseList arrivalsLine
  rest <- inputToThresholdArrivalPairs xs
  return ((k, arrivals) : rest)

-- parseList parses a string of whitespace separated elements into a list.
parseList :: (Read a) => String -> Either String [a]
parseList s = mapLeft (\err -> "parsing \"" ++ s ++ "\": " ++ err)
  ((sequence . map readEither . words) s)

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
readEither s = mapLeft (\err -> "parsing \"" ++ s ++ "\": " ++ err) (R.readEither s)
