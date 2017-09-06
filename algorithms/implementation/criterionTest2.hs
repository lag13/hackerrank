import Criterion.Main
import Data.List (foldl')

-- powerSet returns the power set of a set.
powerSet :: [Integer] -> [[Integer]]
powerSet = foldr (\a b -> map (a:) b ++ b) [[]]

-- powerSet' returns the power set of a set.
powerSet' :: [Integer] -> [[Integer]]
powerSet' = foldl' (\b a -> map (a:) b ++ b) [[]]

main = defaultMain [
  bgroup "powerSet" [ bench "[]"  $ nf powerSet []
               , bench "[1..4]"  $ nf powerSet [1..4]
               , bench "[1..8]"  $ nf powerSet [1..8]
               , bench "[1..16]" $ nf powerSet [1..16]
               , bench "[1..20]" $ nf powerSet [1..20]
               ],
  bgroup "powerSet'" [ bench "[]"  $ nf powerSet' []
               , bench "[1..4]"  $ nf powerSet' [1..4]
               , bench "[1..8]"  $ nf powerSet' [1..8]
               , bench "[1..16]" $ nf powerSet' [1..16]
               , bench "[1..20]" $ nf powerSet' [1..20]
               ]
  ]

