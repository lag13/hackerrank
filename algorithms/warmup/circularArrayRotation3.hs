-- https://www.hackerrank.com/challenges/circular-array-rotation

-- This is my second attempt to reduce the nesting that was present in the
-- circularArrayRotation1.hs solution. It also uses monad transformers but this
-- time I tried to have more functions that do not have IO in their signature
-- because I felt that was making things confusing and less... functional? This
-- is my favorite implementation so far and I'd like to think that it's the
-- "best" one but both of those feelings might be due to me making use of new
-- concepts and new concepts are always fun :).
import Control.Monad.Trans.Either (EitherT(..))
import System.Exit (die)

main :: IO ()
main = (runEitherT main') >>= \result ->
  case result of
    Left err -> die ("error: " ++ err)
    Right results -> mapM_ print results
  where main' :: EitherT String IO [Int]
        main' = do
          (k, q) <- EitherT (fmap parseKQ getLine)
          arr <- EitherT (fmap parseArray getLine)
          indices <- EitherT (fmap (parseIndices (length arr)) (getLines q))
          return (map (\i -> (rotateArray k arr) !! i) indices)

-- mapLeft lifts a function over the Left data constructor.
mapLeft :: (a -> a) -> Either a b -> Either a b
mapLeft f (Left a) = Left (f a)
mapLeft _ r = r

-- parseKQ parses the first line of input described in the problem.
parseKQ :: String -> Either String (Int, Int)
parseKQ s = mapLeft
  (\err -> "parsing \"" ++ s ++ "\": " ++ err)
  (parseKQ' ((sequence . map readsEither . words) s))
  where parseKQ' (Left badParse) = Left ("converting \"" ++ badParse ++ "\" to an integer")
        parseKQ' (Right nkq) = let numIntsOnNKQLine = 3 in
          if length nkq /= numIntsOnNKQLine
            then Left ("there were " ++ (show (length nkq)) ++ " integers, there should have been " ++ (show numIntsOnNKQLine))
            else Right (nkq !! 1, nkq !! 2) -- Strictly speaking, we do not need the 0th character

-- parseArray parses the second line of input described in the problem which is
-- just an array.
parseArray :: String -> Either String [Int]
parseArray s = mapLeft
  (\badParse -> "parsing \"" ++ s ++ "\": converting \"" ++ badParse ++ "\" to an integer")
  ((sequence . map readsEither . words) s)

-- parseIndices converts a list of strings to a list of integers on success and
-- a string on failure.
parseIndices :: Int -> [String] -> Either String [Int]
parseIndices arrLen toParse = mapLeft
  (\err -> "parsing \"" ++ (show toParse) ++ "\": " ++ err)
  (parseIndices' arrLen ((sequence . map readsEither) toParse))
  where parseIndices' _ (Left badParse) = Left ("converting \"" ++ badParse ++ "\" to integer")
        parseIndices' arrLen (Right indices) =
          if all (\i -> 0 <= i && i < arrLen) indices
            then Right indices
            else Left "some indices are out of bounds"

-- rotateArray performs a right circular rotation on a given array.
rotateArray :: Int -> [a] -> [a]
rotateArray n arr = let l = length arr in
  take l (drop (l - mod n l) (cycle arr))

-- getLines reads a specified number of lines from stdin.
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
