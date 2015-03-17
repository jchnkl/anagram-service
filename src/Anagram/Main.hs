import qualified Anagram.Config as Anagram
import qualified Anagram.Service as Anagram

main :: IO ()
main = Anagram.service Anagram.defaultPort
