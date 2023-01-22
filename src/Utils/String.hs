module Utils.String where

import Data.ByteString.Lazy.Char8 as BS (pack)
import Data.Digest.Pure.SHA (sha1)
import Data.Text as T (Text, pack)

sha1Text :: Text -> Text
sha1Text txt = (T.pack . show) $ sha1 (BS.pack $ show txt)