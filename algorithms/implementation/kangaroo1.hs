-- https://www.hackerrank.com/challenges/kangaroo

-- This solution does not do any error handling, if bad input is given the
-- program will crash.
main :: IO ()
main = do
  (l1, l2) <- fmap parse2LinearEquations getLine
  case solve l1 l2 of
    Nothing -> putStrLn "NO"
    Just x -> putStrLn (if x >= 0 then "YES" else "NO")

-- LinearEquation represents a linear equation in the form: mx + b
data LinearEquation a = LinearEquation a a

-- solve takes two linear equations, sets those equations equal to eachother,
-- and solves for an integer solution for 'x'. If there is no integer solution
-- then Nothing is returned. If the two linear equations are identical then 0 is
-- returned.
solve :: LinearEquation Integer -> LinearEquation Integer -> Maybe Integer
solve (LinearEquation x b) (LinearEquation x' b') = go (x - x') (b' - b)
  where go _ 0 = Just 0
        go 0 _ = Nothing
        go x b = if mod b x == 0 then Just (div b x) else Nothing

-- parse2LinearEquations expects a string containing 4 integers and parses it
-- into a 2-tuple of linear equations.
parse2LinearEquations :: (Read a) => String -> (LinearEquation a, LinearEquation a)
parse2LinearEquations s = let arr = map read (words s) in
 (LinearEquation (arr !! 1) (arr !! 0), LinearEquation (arr !! 3) (arr !! 2))
