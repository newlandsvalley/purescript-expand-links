module Data.Link
  ( expandLinks
  , expandYouTubeWatchLinks) where

import Data.String.Regex

import Data.Either (fromRight)
import Data.String.Regex.Flags (global)
import Data.Array (head, tail)
import Data.String (drop)
import Data.Maybe (fromMaybe)
import Partial.Unsafe (unsafePartial)
import Prelude (($), (<>))

-- A general URL pattern that has one capture group
urlPattern :: String
urlPattern = """[^'>"](http[s]?:\/\/[^\s]*)"""

urlRegex  :: Regex
urlRegex =
  unsafePartial $ fromRight $ regex urlPattern global

safeHead :: Array String -> String
safeHead xs =
  fromMaybe "" $ head xs


safeTail :: Array String -> Array String
safeTail xs =
  fromMaybe [] $ tail xs

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


-- A youTube watch  URL pattern that has two capture groups and we're
-- interested in the second one
youTubeWatchPattern :: String
youTubeWatchPattern =  """(http[s]?:\/\/www.youtube.com/)watch\?v=(.*)"""

youTubeWatchRegex  :: Regex
youTubeWatchRegex =
  unsafePartial $ fromRight $ regex youTubeWatchPattern global

-- | expamd a YouTube watch link to an embedded iframe video
expandYouTubeWatchLinks :: String -> String
expandYouTubeWatchLinks s =
  let
    -- pad with leading space to allow matches at the start of the strinng
    target = " " <> s
    f :: String -> Array String -> String
    -- we must use the second capture group as a parameter to build the iframe
    f match xs =
      iframe (safeHead $ safeTail xs)
  in
    -- and drop the leading space after macro-expansion
    drop 1 $ replace' youTubeWatchRegex f target

-- | template for an iframe reference to the embedded video
iframe :: String -> String
iframe videoId =
    "<iframe width='420' height='315' src='//www.youtube.com/embed/" <>
    videoId <>
    "' frameborder='0' allowfullscreen='true'></iframe>"
