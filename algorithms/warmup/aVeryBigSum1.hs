main :: IO ()
main = do
  getLine -- As per usual with these problems, the first line doesn't really matter
  ints <- getLine
  case (sumEithers . map readsEither . words) ints of
    Left err -> print ("error converting string to int: " ++ err)
    Right n -> print n

-- sumEithers takes a list of Either's and sum's the "Right" value if it exists
-- and returns the first "Left" value found otherwise.
sumEithers :: [Either String Integer] -> Either String Integer
sumEithers [] = Right 0
sumEithers ((Left err):_) = Left err
sumEithers ((Right x):xs) =
  case sumEithers xs of
    Left err -> Left err
    Right n -> Right (x + n)
                      
-- readsEither takes a string and parses it into some datatype 'a'. If the
-- parsing fails then a string description of the error is returned in Left.
readsEither :: (Read a) => String -> Either String a
readsEither x =
  case reads x of
    [(x', "")] -> Right x'
    _ -> Left x
