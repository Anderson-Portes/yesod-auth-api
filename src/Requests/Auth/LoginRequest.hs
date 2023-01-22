{-# LANGUAGE OverloadedStrings #-}

module Requests.Auth.LoginRequest where

import Data.Aeson.Types
import Data.Text (Text)

data LoginRequest = LoginRequest {getEmail :: Text, getPassword :: Text}

instance FromJSON LoginRequest where
  parseJSON = withObject "LoginRequest" $ \v -> LoginRequest <$> v .: "email" <*> v .: "password"