-- https://www.hackerrank.com/challenges/designer-pdf-viewer
import Text.Printf (printf)

main :: IO ()
main =
  getLine >>= \charHeights ->
  case buildHeightLookupTable charHeights of
    Left parseErr -> printf "error: building lookup table: parsing \"%s\" as integer: input was \"%s\"\n" parseErr charHeights
    Right lookupTable ->
      getLine >>= \word ->
      let charsToHeights = map ((flip lookup) lookupTable) in
      case sequence (charsToHeights word) of
        Nothing -> printf "error: could not lookup a char: lookup table \"%s\", word \"%s\"\n" (show lookupTable) word
        Just arr -> print (length word * maximum arr)
  where buildHeightLookupTable :: String -> Either String [(Char, Int)]
        buildHeightLookupTable = fmap (zip ['a'..'z']) . sequence . map readsEither . words
  
-- readsEither takes a string and parses it into some datatype 'a'. If the
-- parsing fails then the string that was being parsed is returned in Left.
readsEither :: (Read a) => String -> Either String a
readsEither x = case reads x of
  [(y, "")] -> Right y
  _ -> Left x
