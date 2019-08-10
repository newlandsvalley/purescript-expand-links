module Data.Link (expandLinks) where

import Data.String.Regex

import Data.Either (fromRight)
import Data.String.Regex.Flags (global)
import Data.Array (head)
import Data.String (drop)
import Data.Maybe (fromMaybe)
import Partial.Unsafe (unsafePartial)
import Prelude (($), (<>))

urlPattern :: String
urlPattern = """[^'>"](http[s]?:\/\/[^\s]*)"""

urlRegex  :: Regex
urlRegex =
  unsafePartial $ fromRight $ regex urlPattern global

safeHead :: Array String -> String
safeHead xs =
  fromMaybe "" $ head xs

-- | Macro-expand all links in the input string which are of the form:
-- | http:// or https:// whatever - when these links are __not__ embedded
-- | in quote characters (either single ot double).
-- | i.e. don't expand links that are already presented as HTML attributes.
expandLinks :: String -> String
expandLinks s =
  let
    -- pad with leading space to allow matches at the start of the strinng
    target = " " <> s
    f :: String -> Array String -> String
    f match xs =
      " <a href=\"" <> (safeHead xs) <> "\" >" <> (safeHead xs) <> "</a>"
  in
    -- and drop the leading space after macro-expansion
    drop 1 $ replace' urlRegex f target
