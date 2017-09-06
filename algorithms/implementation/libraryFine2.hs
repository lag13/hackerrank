-- https://www.hackerrank.com/challenges/library-fine
-- No error handling.
main :: IO ()
main = do
  returnedDate <- fmap (read . ("Date " ++)) getLine
  dueDate <- fmap (read . ("Date " ++)) getLine
  print (calculateFine returnedDate dueDate)

-- Date represents a date comprising of a (day, month, year)
data Date = Date Int Int Int deriving (Read)

-- calculateFine calculates the money that is owed given the returned and due
-- dates.
calculateFine :: Date -> Date -> Int
calculateFine (Date retDay retMonth retYear) (Date dueDay dueMonth dueYear)
  | retYear < dueYear || (retYear == dueYear && retMonth < dueMonth) || (retYear == dueYear && retMonth == dueMonth && retDay <= dueDay) = 0
  | retDay > dueDay && retMonth == dueMonth && retYear == dueYear = 15 * (retDay - dueDay)
  | retMonth > dueMonth && retYear == dueYear = 500 * (retMonth - dueMonth)
  | otherwise = 10000
