{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}

module Middlewares.AuthMiddleware where

import Data.Aeson (object)
import Data.Text (pack)
import Foundation (Auth (Authenticated, Unauthenticated), Handler, userIsLogged)
import Utils.Api (jsonErrors)
import Yesod.Core (Value, (.=))

renderRouteByAuthState :: Auth -> Handler Value -> Handler Value
renderRouteByAuthState needAuth route = do
  isLogged <- userIsLogged
  let msg = "You " ++ (if needAuth == Authenticated then "need to be" else "are already") ++ " authenticated"
  if needAuth == isLogged then route else jsonErrors [msg]

authRoute :: Handler Value -> Handler Value
authRoute = renderRouteByAuthState Authenticated

guestRoute :: Handler Value -> Handler Value
guestRoute = renderRouteByAuthState Unauthenticated