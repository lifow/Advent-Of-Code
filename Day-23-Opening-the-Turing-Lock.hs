-- Part 1
import Data.Array

type Address = Int
data Register = A | B deriving (Eq, Read, Show)
data Instruction = Hlf Register | Tpl Register | Inc Register | Jmp Int |
    Jie Register Int | Jio Register Int deriving (Eq, Read, Show)

execute :: Instruction -> (Int, Int, Address) -> (Int, Int, Address)
execute (Hlf A  ) (a, b, i) = (div a 2,       b, succ i)
execute (Hlf B  ) (a, b, i) = (      a, div b 2, succ i)
execute (Tpl A  ) (a, b, i) = (  3 * a,       b, succ i)
execute (Tpl B  ) (a, b, i) = (      a,   3 * b, succ i)
execute (Inc A  ) (a, b, i) = ( succ a,       b, succ i)
execute (Inc B  ) (a, b, i) = (      a,  succ b, succ i)
execute (Jmp j  ) (a, b, i) = (      a,       b,  i + j)
execute (Jie r j) (a, b, i)
    | r == A && even a || r == B && even b = (a, b,  i + j)
    | otherwise                            = (a, b, succ i)
execute (Jio r j) (a, b, i)
    | r == A && a == 1 || r == B && b == 1 = (a, b,  i + j)
    | otherwise                            = (a, b, succ i)


run :: Array Int Instruction -> (Int, Int, Address) -> (Int, Int, Address)
run instructions (a, b, i)
    | i < bottom || i > top = (a, b, i)
    | otherwise = run instructions $ execute (instructions ! i) (a, b, i)
  where
    (bottom, top) = bounds instructions

-- Part 2
-- Just change the input.
