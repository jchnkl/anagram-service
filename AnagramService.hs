{-# LANGUAGE OverloadedStrings #-}

module AnagramService (service) where

import Web.Scotty
import Control.Applicative
import AnagramConfig
import AnagramTypes
import AnagramSolver
import Network.Wai.Handler.Warp (Port)

service :: Port -> IO ()
service p = buildTable . words <$> readFile defaultDictionary >>= runScotty p

runScotty :: Port -> AnagramTable -> IO ()
runScotty port table = scotty port $ do
    get (capture "/:word") $ flip findAnagrams table <$> param "word" >>= json
    notFound               $ json $ Error 400 "service not found" Nothing
