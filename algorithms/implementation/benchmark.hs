import Criterion.Main

numBeautifulDays :: Integer -> Integer -> Integer -> Integer
numBeautifulDays i j k = foldr (\a b -> b + if mod (abs (a - reverseInt a)) k == 0 then 1 else 0) 0 [i..j]

numBeautifulDays' :: Integer -> Integer -> Integer -> Integer
numBeautifulDays' i j k
  | i > j = 0
  | mod (abs (i - reverseInt i)) k == 0 = 1 + numBeautifulDays' (i+1) j k
  | otherwise = numBeautifulDays' (i+1) j k

numBeautifulDays'' :: Integer -> Integer -> Integer -> Integer
numBeautifulDays'' i j k = go 0 i j k
  where go count i j k
          | i > j = count
          | mod (abs (i - reverseInt i)) k == 0 = go (count+1) (i+1) j k
          | otherwise = go count (i+1) j k


