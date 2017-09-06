-- https://www.hackerrank.com/challenges/library-fine
import qualified Text.Read (readEither)
import Control.Monad.Trans.Either (EitherT(..))
-- Hackerrank's haskell version does not have "System.Exit.die". import
-- System.Exit (die) so we make our own.
import System.Exit (exitFailure)
import System.IO (stderr, hPutStrLn)
die :: String -> IO a
die err = hPutStrLn stderr err >> exitFailure

main :: IO ()
main = runEitherT go >>= either (\err -> die ("error: " ++ err)) (\result -> print result)
  where go :: EitherT String IO Int
        go = do
          returnedDate <- EitherT (fmap readDate getLine)
          dueDate <- EitherT (fmap readDate getLine)
          return (calculateFine returnedDate dueDate)

-- Date represents a date comprising of a (day, month, year)
data Date = Date Int Int Int deriving (Read)

-- calculateFine calculates the money that is owed given the returned and due
-- dates.
calculateFine :: Date -> Date -> Int
calculateFine (Date retDay retMonth retYear) (Date dueDay dueMonth dueYear)
  | retYear < dueYear || (retYear == dueYear && retMonth < dueMonth) || (retYear == dueYear && retMonth == dueMonth && retDay <= dueDay) = 0
  | retDay > dueDay && retMonth == dueMonth && retYear == dueYear = 15 * (retDay - dueDay)
  | retMonth > dueMonth && retYear == dueYear = 500 * (retMonth - dueMonth)
  | otherwise = 10000

-- mapLeft lifts a function over the Left data constructor.
mapLeft :: (a -> a) -> Either a b -> Either a b
mapLeft f (Left a) = Left (f a)
mapLeft _ r = r

-- readDate parses a string of 3 numbers into a Date.
readDate :: String -> Either String Date
readDate s = mapLeft (\err -> "parsing \"" ++ s ++ "\" to Date: " ++ err) (Text.Read.readEither ("Date " ++ s))
