-- https://www.hackerrank.com/challenges/time-conversion
-- If hackerrank used a more updated version of the time package (I think I'm
-- using the latest?) then this could work.
import Data.Time (parseTimeOrError, formatTime, defaultTimeLocale, UTCTime)

main :: IO ()
main = do
  input <- getLine
  let parsedTime = parseTimeOrError True defaultTimeLocale "%I:%M:%S%p" input :: UTCTime
  putStrLn (formatTime defaultTimeLocale "%H:%M:%S" parsedTime)
