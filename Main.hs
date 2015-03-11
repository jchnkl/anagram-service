import qualified AnagramConfig as Anagram
import qualified AnagramService as Anagram

main :: IO ()
main = Anagram.service Anagram.defaultPort
