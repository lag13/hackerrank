-- https://www.hackerrank.com/challenges/plus-minus
import Numeric (showFFloat)

main :: IO ()
main =
  getLine >> -- First line for this one doesn't really matter
  (fmap (sequence . map readsEither . words) getLine) >>= \eitherStringArr ->
  case eitherStringArr of
    Left err -> print ("error parsing input: " ++ err)
    Right arr ->
      let numElems = (lengthNum arr)
          numPos = (lengthNum (filter (> 0) arr))
          numNeg = (lengthNum (filter (< 0) arr))
          numZeros = (lengthNum (filter (== 0) arr))
          precision = 6
      in putStrLn (formatFloat (numPos / numElems) precision) >>
         putStrLn (formatFloat (numNeg / numElems) precision) >>
         putStrLn (formatFloat (numZeros / numElems) precision)

-- lengthNum is a utility function which takes the length of list but returns a
-- Num instead of an Int.
lengthNum :: (Num b) => [a] -> b
lengthNum = fromIntegral . length

-- formatFloat formats a fractional number to a certain number of decimal
-- places.
formatFloat :: (RealFloat a) => a -> Int -> String
formatFloat num precision = showFFloat (Just precision) num ""

-- readsEither takes a string and parses it into some datatype 'a'. If the
-- parsing fails then the string that was being parsed is returned in Left.
readsEither :: (Read a) => String -> Either String a
readsEither x = case reads x of
  [(y, "")] -> Right y
  _ -> Left x
