{-# LANGUAGE OverloadedStrings #-}

module Anagram.Service (service) where

import Anagram.Config
import Anagram.Types
import Control.Applicative
import Data.Text.Lazy (unpack)
import Network.Wai.Handler.Warp (Port)
import Network.Wai.Middleware.Cors
import Web.Scotty

import Anagram.Solver (WordSet, WordGraph)
import qualified Anagram.Solver as A

service :: Port -> IO ()
service p = do
    dict <- words <$> readFile defaultDictionary
    runScotty p (A.buildWordSet dict) (A.buildWordGraph dict)

runScotty :: Port -> WordSet -> WordGraph -> IO ()
runScotty port w g = scotty port $ do
    middleware simpleCors
    get (capture "/anagram") $ A.solver w g . firstParam <$> params >>= json
    notFound                 $ json $ Error 400 "service not found" Nothing
    where
    firstParam []        = ""
    firstParam ((x,_):_) = unpack x
