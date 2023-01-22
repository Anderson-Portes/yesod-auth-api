{-# LANGUAGE OverloadedStrings #-}

module Routes.Auth.Register where

import Data.Text (Text, pack)
import Foundation (Handler, Unique (UniqueEmail), User (User))
import Middlewares.AuthMiddleware (guestRoute)
import Requests.Auth.RegisterRequest (RegisterRequest (RegisterRequest, getEmail, getName, getPassword, getPasswordConfirmation))
import Utils.Api (jsonError, jsonErrors)
import Utils.String (sha1Text)
import Yesod (PersistStoreWrite (insert), PersistUniqueRead (getBy), YesodPersist (runDB))
import Yesod.Core (Value, object, requireCheckJsonBody, (.=))

postRegisterR :: Handler Value
postRegisterR = guestRoute $ do
  request <- requireCheckJsonBody :: Handler RegisterRequest
  let name = getName request
  let email = getEmail request
  let password = getPassword request
  let passwordConfirm = getPasswordConfirmation request
  userExists <- (runDB . getBy . UniqueEmail) email
  case userExists of
    Nothing -> if password == passwordConfirm then handleRegister name email password else jsonError "Passwords must be the same!"
    _ -> jsonError "User already exists!"

handleRegister :: Text -> Text -> Text -> Handler Value
handleRegister name email password = do
  let token = sha1Text email
  runDB $ insert (User name email False True (sha1Text password) token)
  return $ object ["access_token" .= token]