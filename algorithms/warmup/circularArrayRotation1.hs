-- https://www.hackerrank.com/challenges/circular-array-rotation

-- There has got to be a way to avoid this nested structure. Maybe those monad
-- transformer things? I could do an EitherT with IO? I'm not entirely sure. But
-- if I do that would I lose context about what error is occurring? Because
-- although I'm not a huge fan of the nesting, it does let us identify exactly
-- which kind of error we encountered.
main :: IO ()
main =
  getLine >>= \nkqInput ->
  case parseNKQLine nkqInput of
    Left err -> putStrLn ("error parsing first line of input: " ++ err)
    Right (k, q) ->
      getLine >>= \arrInput ->
      case (readsArray arrInput :: Either String [Integer]) of
        Left err -> putStrLn ("error parsing array input: parsing \"" ++ err ++ "\"")
        Right arr ->
          getLines q >>= \qsInput ->
          case (sequence . map readsEither) qsInput of
            Left err -> putStrLn ("could not parse qs: " ++ err)
            Right qs ->
              if all (\i -> 0 <= i && i < (length arr)) qs
                then mapM_ putStrLn (map (\i -> show ((rotateArray k arr) !! i)) qs)
                else putStrLn "some indices are out of bounds"

-- rotateArray performs a right circular rotation on a given array.
rotateArray :: Int -> [a] -> [a]
rotateArray n arr = let l = length arr in
  take l (drop (l - mod n l) (cycle arr))

-- parseNKQLine parses the first line of input fro mthe problem returning a
-- tuple (k, q).
parseNKQLine :: String -> Either String (Int, Int)
parseNKQLine s =
  case readsArray s of
    Left err -> Left ("parsing \"" ++ err ++ "\" into an integer: input was: " ++ s)
    Right nkq -> let numIntsOnNKQLine = 3 in
      if length nkq /= numIntsOnNKQLine
      then Left ("string contained " ++ (show (length nkq)) ++ " integers, there should have been " ++ (show numIntsOnNKQLine))
      else Right (nkq !! 1, nkq !! 2) -- Strictly speaking, we do not need 'n' so we don't use it

-- readsArray is a utility function which parses a string into a list of some
-- type 'a' or a string of the item that failed to parse.
readsArray :: (Read a) => String -> Either String [a]
readsArray = sequence . map readsEither . words

-- getLines reads a specified number of lines from the input.
getLines :: Int -> IO [String]
getLines n
  | n < 0 = error "negative input to getLines function"
  | n == 0 = return []
  | otherwise = do
      l <- getLine
      ls <- getLines (n - 1)
      return (l:ls)

-- readsEither takes a string and parses it into some datatype 'a'. If the
-- parsing fails then the string that was being parsed is returned in Left.
readsEither :: (Read a) => String -> Either String a
readsEither x = case reads x of
  [(y, "")] -> Right y
  _ -> Left x
