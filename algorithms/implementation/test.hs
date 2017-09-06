import Text.ParserCombinators.ReadP as ReadP
import Text.ParserCombinators.ReadPrec as ReadPrec

testRead = do
  x <- readPrec
  ReadPrec.lift ReadP.skipSpaces
  return x
