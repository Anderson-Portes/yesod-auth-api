{-# LANGUAGE OverloadedStrings #-}

module Routes.Home where

import Data.Text (pack)
import Foundation (Handler)
import Middlewares.AuthMiddleware (authRoute)
import Yesod.Core (Value, object, (.=))

getHomeR :: Handler Value
getHomeR = authRoute $ do
  return $ object ["message" .= pack "Hello World"]
