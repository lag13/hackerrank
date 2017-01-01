-- https://www.hackerrank.com/challenges/staircase
main :: IO ()
main =
  (fmap readsEither getLine) >>= \staircaseSize ->
  case staircaseSize of
    Left err -> putStrLn ("not an integer: " ++ err)
    -- mapM_ f xs = sequence_ (map f xs): https://wiki.haskell.org/How_to_work_on_lists#Lists_and_IO
    Right n -> mapM_ putStrLn (buildStaircase n '#')

-- buildStaircase creates a list of strings representing the staircase we need
-- to print.
buildStaircase :: Int -> Char -> [String]
buildStaircase n c = go 1 n c
  where go :: Int -> Int -> Char -> [String]
        go stairNum staircaseSize c
          | stairNum > staircaseSize = []
          | otherwise =
              let numSpaces = (staircaseSize - stairNum)
                  numChars = stairNum
                  stair = (replicate numSpaces ' ') ++ (replicate numChars c)
              in stair : go (stairNum+1) staircaseSize c

-- readsEither takes a string and parses it into some datatype 'a'. If the
-- parsing fails then the string that was being parsed is returned in Left.
readsEither :: (Read a) => String -> Either String a
readsEither x = case reads x of
  [(y, "")] -> Right y
  _ -> Left x
