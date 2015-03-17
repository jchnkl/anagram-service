module Anagram.Config where

import Data.Char (ord)
import Network.Wai.Handler.Warp (Port)

defaultPort :: Port
defaultPort = foldr1 (+) $ map ord "anagram-service" -- 1525

defaultDictionary :: FilePath
defaultDictionary = "/usr/share/dict/cracklib-small"
