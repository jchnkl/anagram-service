{-# LANGUAGE CPP #-}

module AnagramSolver
    ( Key
    , Word
    , AnagramTable
    , buildTable
    , findAnagrams
#ifdef GHC_INTERACTIVE_STANDALONE
    , main
#endif
    ) where

#ifdef GHC_INTERACTIVE_STANDALONE
import Control.Monad ((<=<), join, forever)
import AnagramConfig (defaultDictionary)
#endif

import Data.HashMap.Lazy (HashMap)
import Data.Maybe (fromMaybe)
import qualified Data.Char as C
import qualified Data.DList as D
import qualified Data.HashMap.Lazy as H
import qualified Data.List as L

type Key = String
type Word = String
type AnagramTable = HashMap Key [Word]

toKey :: String -> Key
toKey = L.sort . map C.toLower

buildTable :: [Word] -> AnagramTable
buildTable = H.map D.toList . H.fromListWith D.append . map toTuple
    where toTuple w = (toKey w, D.singleton w)

findAnagrams :: Word -> AnagramTable -> [Word]
findAnagrams w = L.filter (/= w) . fromMaybe [] . H.lookup (toKey w)

#ifdef GHC_INTERACTIVE_STANDALONE
showWords :: [Word] -> String
showWords = ("=> " ++) . join . L.intersperse ", "

main :: IO ()
main = forever . solver . buildTable <=< fmap words $ readFile defaultDictionary
    where solver m = fmap (flip findAnagrams m) getLine >>= putStrLn . showWords

-- GHC_INTERACTIVE_STANDALONE
#endif
