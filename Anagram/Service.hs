{-# LANGUAGE OverloadedStrings #-}

module Anagram.Service (service) where

import Web.Scotty
import Data.Text.Lazy (unpack)
import Control.Applicative
import Anagram.Config
import Anagram.Types
import Anagram.Solver
import Network.Wai.Middleware.Cors
import Network.Wai.Handler.Warp (Port)

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
