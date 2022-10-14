module Data.Link
  ( expandLinks
  , expandYouTubeWatchLinks) where

import Data.String.Regex

import Data.Either (fromRight')
import Data.String.Regex.Flags (global)
import Data.Array (head, tail)
import Data.String (drop)
import Data.Maybe (Maybe, fromMaybe)
import Partial.Unsafe (unsafeCrashWith)
import Prelude (($), (<>), join)

-- A general URL pattern that has one capture group
urlPattern :: String
urlPattern = """[^'>"](http[s]?:\/\/[^\s]*)"""

urlRegex  :: Regex
urlRegex =
  fromRight' (\_ -> unsafeCrashWith "Unexpected Right") $ regex urlPattern global

safeHeadMaybes :: Array (Maybe String) -> String
safeHeadMaybes xs =
  fromMaybe "" $ join $ head xs

safeTailMaybes :: Array (Maybe String) -> Array (Maybe String)
safeTailMaybes xs =
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
    f :: String -> Array (Maybe String) -> String
    f _match xs =
      " <a href=\"" <> (safeHeadMaybes xs) <> "\" >" <> (safeHeadMaybes xs) <> "</a>"
  in
    -- and drop the leading space after macro-expansion
    drop 1 $ replace' urlRegex f target


-- A youTube watch  URL pattern that has two capture groups and we're
-- interested in the second one
youTubeWatchPattern :: String
youTubeWatchPattern =  """(http[s]?:\/\/www.youtube.com/)watch\?v=(.*)"""

youTubeWatchRegex  :: Regex
youTubeWatchRegex =
   fromRight' (\_ -> unsafeCrashWith "Unexpected Right") $ regex youTubeWatchPattern global

-- | expand a YouTube watch link to an embedded iframe video
expandYouTubeWatchLinks :: String -> String
expandYouTubeWatchLinks s =
  let
    -- pad with leading space to allow matches at the start of the string
    target = " " <> s
    f :: String -> Array (Maybe String) -> String
    -- we must use the second capture group as a parameter to build the iframe
    f _match xs =
      iframe (safeHeadMaybes $ safeTailMaybes xs)
  in
    -- and drop the leading space after macro-expansion
    drop 1 $ replace' youTubeWatchRegex f target

-- | template for an iframe reference to the embedded video
iframe :: String -> String
iframe videoId =
    "<iframe width='420' height='315' src='//www.youtube.com/embed/" <>
    videoId <>
    "' frameborder='0' allowfullscreen='true'></iframe>"
