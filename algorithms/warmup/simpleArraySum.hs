-- https://www.hackerrank.com/challenges/simple-array-sum
main :: IO ()
main = do
  getLine -- The first line can be ignored
  eitherNums <- fmap (map readsEither . words) getLine
  case foldr go (Right 0) eitherNums of
    (Left err) -> print ("could not convert string to number: " ++ err)
    (Right n) -> print n
  where go :: (Num a) => Either String a -> Either String a -> Either String a
        go (Left err) _ = Left err
        go _ (Left err) = Left err
        go (Right a) (Right b) = Right (a + b)

readsEither :: (Read a) => String -> Either String a
readsEither x =
  case reads x of
    [(x', "")] -> Right x'
    _ -> Left x
