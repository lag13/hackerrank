-- https://www.hackerrank.com/challenges/solve-me-first
-- Manually converting String to Num making the program more stable. When we
-- used readLn the program would crash if given bad input. My only complaint is
-- that I don't know a nice way to print out which input was the bad one.
main :: IO ()
main = do
  x <- fmap readsMaybe getLine
  y <- fmap readsMaybe getLine
  case x >>= \x' -> y >>= \y' -> return (x' + y') of
    Just n -> print n
    Nothing -> print "could not parse integer"

readsMaybe :: (Read a) => String -> Maybe a
readsMaybe x =
  case reads x of
    [(x', "")] -> Just x'
    _ -> Nothing
