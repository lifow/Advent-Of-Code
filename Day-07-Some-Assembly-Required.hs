-- Part 1
import Data.Bits
import Data.Char
import Data.Function.Memoize
import Data.Word
import qualified Data.Map as Map

type Signal = Word16
type Wire = String
type Instructions = Map.Map Wire (Wire, String, Wire)

calculate :: Instructions -> Wire -> Signal
calculate booklet = calcMemo
  where
    calcMemo = memoize calc
    calc wire
        | isInteger wire = read wire
        | op == "IN"     = calcMemo r
        | op == "NOT"    = complement $ calcMemo r
        | op == "AND"    = calcMemo l .&. calcMemo r
        | op == "OR"     = calcMemo l .|. calcMemo r
        | op == "LSHIFT" = shiftL (calcMemo l) (read r)
        | op == "RSHIFT" = shiftR (calcMemo l) (read r)
      where
        isInteger  = and . map isDigit
        (l, op, r) = booklet Map.! wire

-- Part 2
-- Just use the same function before with the output of part a in place of the input of part b.
