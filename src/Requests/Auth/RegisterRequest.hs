{-# LANGUAGE OverloadedStrings #-}

module Requests.Auth.RegisterRequest where

import Data.Aeson.Types
import Data.Text (Text)

data RegisterRequest = RegisterRequest {getName :: Text, getEmail :: Text, getPassword :: Text, getPasswordConfirmation :: Text}

instance FromJSON RegisterRequest where
  parseJSON = withObject "RegisterRequest" $ \v -> RegisterRequest <$> v .: "name" <*> v .: "email" <*> v .: "password" <*> v .: "password_confirmation"