-- Part 1
import Data.List
import Data.Function

data Character = Player | Boss deriving (Read, Show, Eq)
type Cost      = Integer

data Item = Item {
    cost       :: Integer,
    itemDamage :: Integer,
    itemArmor :: Integer
} deriving (Read, Show)

data Stats = Stats {
    character :: Character,
    hitPoints :: Integer,
    damage    :: Integer,
    armor     :: Integer
} deriving (Read, Show)

generateStats :: [Item] -> [Item] -> [Item] -> [(Cost, Stats)]
generateStats weapons armor rings = sortBy (on compare fst)
    [costAndStats w a rs | w <- weapons, a <- armor, rs <- ringCombinations]
  where
    ringCombinations = filter ((<=2) . length) . subsequences $ rings
    costAndStats w a rs = (sum . map cost $ w:a:rs,
        Stats {
            character = Player,
            hitPoints = 100,
            damage    = sum . map itemDamage $ w:a:rs,
            armor     = sum . map itemArmor $ w:a:rs
        })

fight :: Stats -> Stats -> Character
fight attacker defender@(Stats {hitPoints = h, armor = a})
    | hitPoints defender' <= 0 = character attacker
    | otherwise                = fight defender' attacker
  where
    defender' = defender {hitPoints = h - max 1 (damage attacker - a)}

cheapestWin :: [Item] -> [Item] -> [Item] -> Stats -> Cost
cheapestWin weapons armor rings boss =
    fst . head . filter (\(_, player) -> fight player boss == Player) $
    generateStats weapons armor rings

-- Part 2
mostExpensiveLoss :: [Item] -> [Item] -> [Item] -> Stats -> Cost
mostExpensiveLoss weapons armor rings boss =
    fst . head . filter (\(_, player) -> fight player boss == Boss) . reverse $
    generateStats weapons armor rings
