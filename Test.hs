module Main where

import Control.Monad
import Database.HDBC
import Database.HDBC.MySQL

connectDatabase :: IO Connection
connectDatabase = connectMySQL defaultMySQLConnectInfo

go :: IO ()
go = do conn <- connectDatabase

        putStrLn $ "driver " ++ (show $ hdbcDriverName conn)
        putStrLn $ "server version " ++ (show $ dbServerVer conn)
        tables <- getTables conn
        forM_ tables $ \t -> do
          putStrLn $ "table " ++ t
          cols <- describeTable conn t
          forM_ cols $ \(name, desc) ->
              putStrLn $ name ++ " " ++ (show desc)
        rows0 <- quickQuery' conn "SELECT a FROM album" []
        rows1 <- quickQuery' conn "SELECT str FROM album" []
        forM_ (zip rows0 rows1) $ \(a, str) -> putStrLn $ "a=" ++ (show a) ++ ", str=" ++ (show str)

        {-
        stmt <- prepare conn "INSERT INTO album VALUES (?, ?)"
        n <- execute stmt [SqlWord32 3000000000, SqlString "hello"]
        commit conn
        -}


main :: IO ()
main = handleSqlError (replicateM_ 1 go)
