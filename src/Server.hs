{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

module Server (
  launchServer
              ) where

import Web.Scotty
import Data.Text.Lazy (Text)
import qualified Data.Text.Lazy as T

launchServer :: IO ()
launchServer = scotty 50000 $ do
  get "/" $ do
    html "Smart query redirect engine"

  get "/search/:query" handleQuery


bingQ = "https://www.bing.com/search?q="
bing = "https://www.bing.com/"
duckduckgoQ = "https://duckduckgo.com/?q="
duckduckgo = "https://duckduckgo.com/"


handleQuery :: ActionM ()
handleQuery = do
  query <- param "query" `rescue` (\_ -> return "Sure.. what do you want to search for")
  parse query


redirectDuckDuckGo :: Maybe Text -> ActionM ()
redirectDuckDuckGo q = redirectTo q (duckduckgoQ, duckduckgo)

redirectBing :: Maybe Text -> ActionM ()
redirectBing q = redirectTo q (bingQ, bing)

redirectTo :: Maybe Text -> (Text, Text) -> ActionM ()
redirectTo (Just q) (u, _) = redirect $ u <> q
redirectTo Nothing  (_, u) = redirect $ u


parse :: Text -> ActionM ()
parse query = do
  let (cmd, q) = split query
  case cmd of
    "duck" -> redirectDuckDuckGo q
    "bing" -> redirectBing q
    _      -> redirect $ duckduckgo


split :: Text -> (Text, Maybe Text)
split (T.words -> (f:r)) = (f, Just $ T.intercalate " " r)
split (T.words -> [f])   = (f, Nothing)
