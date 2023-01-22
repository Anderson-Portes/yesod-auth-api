{-# LANGUAGE OverloadedStrings #-}

module Routes.Auth.Login where

import Data.Text (Text, pack)
import Foundation
import Middlewares.AuthMiddleware (guestRoute)
import Requests.Auth.LoginRequest (LoginRequest (LoginRequest, getEmail, getPassword))
import Utils.Api (jsonError)
import Utils.String (sha1Text)
import Yesod
import Yesod.Core

postLoginR :: Handler Value
postLoginR = guestRoute $ do
  request <- requireCheckJsonBody :: Handler LoginRequest
  let email = getEmail request
  let password = getPassword request
  userExists <- (runDB . getBy . UniqueEmail) email
  case userExists of
    Just (Entity userId userData) -> handleLogin password userData
    _ -> jsonError "Invalid login."

handleLogin :: Text -> User -> Handler Value
handleLogin password user = do
  if userPassword user == sha1Text password
    then return $ object ["access_token" .= userToken user]
    else jsonError "Invalid login."