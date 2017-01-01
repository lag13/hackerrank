main :: IO ()
main = do
  getLine -- As per usual with these problems, the first line doesn't really matter
  ints <- getLine
  case (foldr addEither (Right 0) . map readsEither . words) ints of
    Left err -> print ("error converting string to int: " ++ err)
    Right n -> print n

-- addEither takes two Either's and adds their "Right" values together.
addEither :: Either String Integer -> Either String Integer -> Either String Integer
addEither x y = do
  x' <- x
  y' <- y
  Right (x' + y')

-- readsEither takes a string and parses it into some datatype 'a'. If the
-- parsing fails then a string description of the error is returned in Left.
readsEither :: (Read a) => String -> Either String a
readsEither x =
  case reads x of
    [(x', "")] -> Right x'
    _ -> Left x
