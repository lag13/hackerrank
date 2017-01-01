-- https://www.hackerrank.com/challenges/solve-me-first
-- Manually converting String to Num making the program more stable. It also
-- prints out which input was bad.
main :: IO ()
main = do
  x <- fmap readsEither getLine
  y <- fmap readsEither getLine
  case x >>= \x' -> y >>= \y' -> return (x' + y') of
    Left s -> print ("could not parse integer from string \"" ++ s ++ "\"")
    Right n -> print n

readsEither :: (Read a) => String -> Either String a
readsEither x =
  case reads x of
    [(x', "")] -> Right x'
    _ -> Left x
