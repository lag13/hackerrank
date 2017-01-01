-- https://www.hackerrank.com/challenges/compare-the-triplets
main :: IO ()
main =
  getLine >>= \ratings1 ->
  getLine >>= \ratings2 ->
  case compareTriplets ratings1 ratings2 of
    (Left err) -> print ("could not convert string to number: " ++ err)
    (Right comparison) -> print comparison

newtype Comparison = Comparison (Int, Int)

instance Show Comparison where
  show (Comparison (x, y)) = (show x) ++ " " ++ (show y)

-- compareTriplets takes two strings representing 3 numbers each and compares
-- the 3 numbers from each string with eachother. Upon success it will return
-- the result of the comparison and on failure a string describing the error.
compareTriplets :: String -> String -> Either String Comparison
compareTriplets x y = let eitherList = sequence . map readsEither . words
  in compareTriplets (eitherList x) (eitherList y)
  where compareTriplets :: (Num a, Ord a) => Either String [a] -> Either String [a] -> Either String Comparison
        compareTriplets e1 e2 = do
          e1' <- e1
          e2' <- e2
          return (foldr compareTriplets' (Comparison (0, 0)) (zip e1' e2'))
          where compareTriplets' :: (Num a, Ord a) => (a, a) -> Comparison -> Comparison
                compareTriplets' (x, y) (Comparison (a, b))
                  | x > y = Comparison (a+1,b)
                  | x < y = Comparison (a,b+1)
                  | otherwise = Comparison (a,b)

-- readsEither takes a string and parses it into some datatype 'a'. If the
-- parsing fails then a string description of the error is returned in Left.
readsEither :: (Read a) => String -> Either String a
readsEither x =
  case reads x of
    [(x', "")] -> Right x'
    _ -> Left x

