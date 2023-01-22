{-# LANGUAGE OverloadedStrings #-}

import Application ()
-- for YesodDispatch instance

import Control.Monad.Logger (runStdoutLoggingT)
import Database.Persist.Postgresql (ConnectionString, runMigration, runSqlPersistMPool, withPostgresqlPool)
import Foundation (App (App), migrateAll)
import Yesod.Core

connStr :: ConnectionString
connStr = "dbname=yesod_auth_api host=localhost user=postgres password=root port=5432"

main :: IO ()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do
  flip runSqlPersistMPool pool $ do
    runMigration migrateAll
  warp 3000 (App pool)