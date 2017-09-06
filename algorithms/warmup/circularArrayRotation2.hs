-- https://www.hackerrank.com/challenges/circular-array-rotation

-- This is my first attempt to reduce the nesting that was present in the
-- circularArrayRotation1.hs solution. It uses monad transformers. I'm not sure
-- how I feel about it. It did reduce indentation to some extent but I think it
-- just made the code more noisy/confusing.
import Control.Monad.Trans.Either (EitherT(..))

main :: IO ()
main = (runEitherT main') >>= \result ->
  case result of
    Left err -> putStrLn ("error: " ++ err)
    Right result -> mapM_ print result

main' :: EitherT String IO [Int]
main' = do
  (k, q) <- getKQ
  arr <- getArray
  indices <- getIndices q
  return (map (\i -> (rotateArray k arr) !! i) indices)

getKQ :: EitherT String IO (Int, Int)
getKQ = EitherT $ getLine >>= \input ->
  return $ case (sequence . map readsEither . words) input of
    Left err -> (Left ("parsing line \"" ++ input ++ "\": converting \"" ++ err ++ "\" to integer"))
    Right nkq -> let numIntsOnNKQLine = 3 in
      if length nkq /= numIntsOnNKQLine
        then (Left ("parsing line \"" ++ input ++ "\": there were " ++ (show (length nkq)) ++ " integers, there should have been " ++ (show numIntsOnNKQLine)))
        else (Right (nkq !! 1, nkq !! 2)) -- Strictly speaking, we do not need 'n' so we don't use it

getArray :: EitherT String IO [Int]
getArray = EitherT $ getLine >>= \input ->
  return $ case ((sequence . map readsEither . words) input :: Either String [Int]) of
    Left err -> Left ("parsing line \"" ++ input ++ "\": converting \"" ++ err ++ "\" to integer")
    Right arr -> Right arr

getIndices :: Int -> EitherT String IO [Int]
getIndices n = EitherT $ getLines n >>= \input ->
  return $ case (sequence . map readsEither) input of
    Left err -> Left ("parsing \"" ++ (show input) ++ "\": converting \"" ++ err ++ "\" to integer ")
    -- TODO: This program could stil fail if out of bounds indices are
    -- given.
    Right indices -> Right indices

-- rotateArray performs a right circular rotation on a given array.
rotateArray :: Int -> [a] -> [a]
rotateArray n arr = let l = length arr in
  take l (drop (l - mod n l) (cycle arr))

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
