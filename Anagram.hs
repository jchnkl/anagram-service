import Control.Monad ((<=<), join, forever)
import Data.HashMap.Lazy (HashMap)
import Data.Maybe (fromMaybe)
import qualified Data.Char as C
import qualified Data.DList as D
import qualified Data.HashMap.Lazy as H
import qualified Data.List as L

type Key = String
type Word = String

toKey :: String -> Key
toKey = L.sort . map C.toLower

buildMap :: [Word] -> HashMap Key [Word]
buildMap = H.map D.toList . H.fromListWith D.append . map toTuple
    where toTuple w = (toKey w, D.singleton w)

findAnagrams :: Word -> HashMap Key [Word] -> [Word]
findAnagrams w = L.filter (/= w) . fromMaybe [] . H.lookup (toKey w)

showWords :: [Word] -> String
showWords = ("=> " ++) . join . L.intersperse ", "

dictFile :: FilePath
dictFile = "/usr/share/dict/cracklib-small"

main :: IO ()
main = forever . solver . buildMap <=< fmap words $ readFile dictFile
    where solver m = fmap (flip findAnagrams m) getLine >>= putStrLn . showWords
