-- https://www.hackerrank.com/challenges/time-conversion
-- If hackerrank used a more updated version of the time package (I think I'm
-- using the latest?) then this could work.
import Data.Time (parseTimeM, formatTime, defaultTimeLocale, UTCTime)

main :: IO ()
main = do
  input <- getLine
  case parseTimeM True defaultTimeLocale "%I:%M:%S%p" input :: Maybe UTCTime of
    Just parsedTime -> putStrLn (formatTime defaultTimeLocale "%H:%M:%S" parsedTime)
    Nothing -> putStrLn ("could not parse the input: " ++ input)
