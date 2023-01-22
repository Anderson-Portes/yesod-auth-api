{-# LANGUAGE OverloadedStrings #-}

module Utils.Api where

import Data.Text (Text, pack)
import Foundation (Handler)
import Yesod (Value, object, (.=))

stringListToText :: [String] -> [Text]
stringListToText = fmap pack

jsonErrors :: [String] -> Handler Value
jsonErrors errors = return $ object ["errors" .= stringListToText errors]

jsonError :: String -> Handler Value
jsonError message = return $ object ["errors" .= pack message]