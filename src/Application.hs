{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE ViewPatterns #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Application where

import Foundation
  ( App,
    Route (HomeR, LoginR, RegisterR),
    resourcesApp,
  )
import Routes.Auth.Login (postLoginR)
import Routes.Auth.Register (postRegisterR)
import Routes.Home (getHomeR)
import Yesod.Core (mkYesodDispatch)

mkYesodDispatch "App" resourcesApp
