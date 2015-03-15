{-# LANGUAGE OverloadedStrings #-}

module Anagram.Service (service) where

import Anagram.Config
import Anagram.Solver
import Anagram.Types
import Control.Applicative
import Data.Text.Lazy (unpack)
import Network.Wai.Handler.Warp (Port)
import Network.Wai.Middleware.Cors
import Web.Scotty

service :: Port -> IO ()
service p = buildTable . words <$> readFile defaultDictionary >>= runScotty p

runScotty :: Port -> AnagramTable -> IO ()
runScotty port table = scotty port $ do
    middleware simpleCors
    get (capture "/anagram") $ flip findAnagrams table . firstParam <$> params >>= json
    notFound                 $ json $ Error 400 "service not found" Nothing
    where
    firstParam []        = ""
    firstParam ((x,_):_) = unpack x
