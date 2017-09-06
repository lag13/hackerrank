-- https://www.hackerrank.com/challenges/kangaroo

-- This solution does have error handling.

-- Hackerrank's haskell version does not have "System.Exit.die".
import System.Exit (exitFailure)
import System.IO (stderr, hPutStrLn)
die :: String -> IO a
die err = hPutStrLn stderr err >> exitFailure

main :: IO ()
main = do
  input <- getLine
  case parse2LinearEquations input of
    Left err -> die ("error: " ++ err)
    Right (l1, l2) -> case solve l1 l2 of
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
parse2LinearEquations :: (Read a) => String -> Either String (LinearEquation a, LinearEquation a)
parse2LinearEquations s = mapLeft
  (\err -> "parsing \"" ++ s ++ "\": " ++ err)
  (go (sequence (map readsEither (words s))))
  where go (Left badParse) = Left ("converting \"" ++ badParse ++ "\" to an integer")
        go (Right arr) = let expectNumInts = 4 in
          if length arr /= expectNumInts
            then Left ("parsed " ++ (show (length arr)) ++ " integers, there should have been " ++ (show expectNumInts))
            else Right (LinearEquation (arr !! 1) (arr !! 0), LinearEquation (arr !! 3) (arr !! 2))

-- mapLeft lifts a function over the Left data constructor.
mapLeft :: (a -> a) -> Either a b -> Either a b
mapLeft f (Left a) = Left (f a)
mapLeft _ r = r

-- readsEither takes a string and parses it into some datatype 'a'. If the
-- parsing fails then the string that was being parsed is returned in Left.
readsEither :: (Read a) => String -> Either String a
readsEither x = case reads x of
  [(y, "")] -> Right y
  _ -> Left x
