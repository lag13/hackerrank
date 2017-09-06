-- https://www.hackerrank.com/challenges/apple-and-orange

-- The solution that does have error handling. It's a shame though that dealing
-- with every possible error scenario clouds the program logic. Maybe I'm not
-- handling errors in the best way possible. Perhaps I should look into using
-- exceptions? But I'm really not a huge fan of exceptions.
import Control.Monad.Trans.Either (EitherT(..))
import Control.Monad.Trans.Class (lift)

-- Hackerrank's haskell version does not have "System.Exit.die".
-- import System.Exit (die)
import System.Exit (exitFailure)
import System.IO (stderr, hPutStrLn)
die :: String -> IO a
die err = hPutStrLn stderr err >> exitFailure

main :: IO ()
main = (runEitherT main') >>= \result ->
  case result of
    Left err -> die ("error: " ++ err)
    Right results -> mapM_ print results
  where main' :: EitherT String IO [Int]
        main' = do
          (hleft, hright) <- EitherT (fmap parseTuple getLine)
          (appleTreeLoc, orangeTreeLoc) <- EitherT (fmap parseTuple getLine)
          lift getLine -- We don't need to know the number of apples and oranges because they'll be apparent in the next two lines of input
          appleDistances <- EitherT (fmap parseArray getLine)
          orangeDistances <- EitherT (fmap parseArray getLine)
          return
            [
              numWithinRange hleft hright (map (+appleTreeLoc) appleDistances)
            , numWithinRange hleft hright (map (+orangeTreeLoc) orangeDistances)
            ]

numWithinRange :: (Ord a) => a -> a -> [a] -> Int
numWithinRange lowerBound upperBound xs =
  length (filter (\x -> lowerBound <= x && x <= upperBound) xs)

-- mapLeft lifts a function over the Left data constructor.
mapLeft :: (a -> a) -> Either a b -> Either a b
mapLeft f (Left a) = Left (f a)
mapLeft _ r = r

-- parseTuple parses a string into a 2-tuple.
parseTuple :: (Read a) => String -> Either String (a, a)
parseTuple s = mapLeft
  (\err -> "parsing \"" ++ s ++ "\": " ++ err)
  (parseTuple' (sequence (map readsEither (words s))))
  where parseTuple' (Left badParse) = Left ("converting \"" ++ badParse ++ "\" to an integer")
        parseTuple' (Right tup) = let numInts = 2 in
          if length tup /= numInts
            then Left ("parsed " ++ (show (length tup)) ++ " integers, there should have been " ++ (show numInts))
            else Right (tup !! 0, tup !! 1)

-- parseArray parses a string into an list.
parseArray :: (Read a) => String -> Either String [a]
parseArray s = mapLeft
  (\badParse -> "parsing \"" ++ s ++ "\": converting \"" ++ badParse ++ "\" to an integer")
  ((sequence . map readsEither . words) s)

-- readsEither takes a string and parses it into some datatype 'a'. If the
-- parsing fails then the string that was being parsed is returned in Left.
readsEither :: (Read a) => String -> Either String a
readsEither x = case reads x of
  [(y, "")] -> Right y
  _ -> Left x
