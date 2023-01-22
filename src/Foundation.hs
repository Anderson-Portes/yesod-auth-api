{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE ViewPatterns #-}

module Foundation where

import Data.Maybe (isJust)
import Data.Text (Text)
import Database.Persist.Postgresql (ConnectionPool, PersistUniqueRead (getBy), SqlBackend, runSqlPool)
import Yesod (Value, YesodPersist (YesodPersistBackend, runDB), lookupBearerAuth, mkMigrate, mkPersist, persistLowerCase, share, sqlSettings)
import Yesod.Core
  ( RenderRoute (renderRoute),
    Yesod,
    getYesod,
    mkYesodData,
    parseRoutesFile,
  )

share
  [mkPersist sqlSettings, mkMigrate "migrateAll"]
  [persistLowerCase|
  User
    name Text
    email Text
    isAdmin Bool
    isActived Bool
    password Text
    token Text
    UniqueEmail email
    UniqueToken token
    deriving Show
  |]

data Auth = Authenticated | Unauthenticated deriving (Eq)

newtype App = App {connPool :: ConnectionPool}

mkYesodData "App" $(parseRoutesFile "routes.yesodroutes")

userIsLogged :: Handler Auth
userIsLogged = do
  token <- lookupBearerAuth
  case token of
    Just authToken -> do
      userExists <- runDB $ getBy (UniqueToken authToken)
      return $ if isJust userExists then Authenticated else Unauthenticated
    _ -> return Unauthenticated

instance Yesod App

instance YesodPersist App where
  type YesodPersistBackend App = SqlBackend
  runDB f = do
    master <- getYesod
    let pool = connPool master
    runSqlPool f pool
