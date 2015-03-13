{-# LANGUAGE OverloadedStrings #-}

module Anagram.Service (service) where

import Web.Scotty
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
    get (capture "/:word") $ flip findAnagrams table <$> param "word" >>= json
    notFound               $ json $ Error 400 "service not found" Nothing
