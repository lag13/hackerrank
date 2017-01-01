-- https://www.hackerrank.com/challenges/diagonal-difference
main :: IO ()
main = do
  numRows <- fmap readsEither getLine
  case numRows of
    Left err -> print ("error converting number of rows to integer: " ++ err)
    Right n -> do
      inputMatrix <- getLines n
      case toSquareMatrix inputMatrix of
        Left err -> print ("error converting input to matrix: " ++ err)
        Right matrix -> print (calcDiagonalDifference matrix)

-- calcDiagonalDifference does the actual work required of this problem namely
-- calculating the diagonal difference of the matrix. Amazing how little "core"
-- logic there is when compared with the work involved with validating the
-- input.
calcDiagonalDifference :: (Num a) => Matrix a -> a
calcDiagonalDifference (Matrix matrix) =
  let primaryDiagonal = getPrimaryDiagonalSum matrix
      secondaryDiagonal = getPrimaryDiagonalSum (map reverse matrix)
  in abs (primaryDiagonal - secondaryDiagonal)
  where getPrimaryDiagonalSum :: (Num a) => [[a]] -> a
        getPrimaryDiagonalSum [] = 0
        getPrimaryDiagonalSum (x:xs) = head x + getPrimaryDiagonalSum (map tail xs)

newtype Matrix a = Matrix [[a]] deriving (Show)

-- toSquareMatrix takes a list of strings and converts it into a square matrix
-- of some type 'a'.
toSquareMatrix :: (Read a) => [String] -> Either String (Matrix a)
toSquareMatrix xs = let matrixOfEithers = map (map (readsEither)) (map words xs)
                        eitherStringMatrix = sequence (map sequence matrixOfEithers)
              in do
                matrix <- eitherStringMatrix
                if isSquareMatrix matrix
                then return (Matrix matrix)
                else Left "the matrix is not a square"
                where isSquareMatrix :: [[a]] -> Bool
                      isSquareMatrix [] = True
                      isSquareMatrix m = all (== (length m)) (map length m)

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
