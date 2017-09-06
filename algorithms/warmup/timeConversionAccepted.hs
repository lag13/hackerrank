-- https://www.hackerrank.com/challenges/time-conversion
import Data.Time (readTime, formatTime, UTCTime)
-- Looks like hackerrank uses an older version of the time package
-- (https://hackage.haskell.org/package/time) where defaultTimeLocale comes from
-- this other package.
import System.Locale (defaultTimeLocale)

main :: IO ()
main = do
  input <- getLine
  let parsedTime = readTime defaultTimeLocale "%I:%M:%S%p" input :: UTCTime
  putStrLn (formatTime defaultTimeLocale "%H:%M:%S" parsedTime)
