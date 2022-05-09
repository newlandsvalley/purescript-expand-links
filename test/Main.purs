module Test.Main where

import Data.Link (expandLinks, expandYouTubeWatchLinks)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Prelude (Unit, discard, ($), (<>))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter (specReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main = launchAff_ $ runSpec [ specReporter] do 
  describe "expand-links" do
    urlExpansionSpec

urlExpansionSpec :: Spec Unit
urlExpansionSpec =
  describe "URL expansion" do
    it "global replace single URL" do
      sample1Expanded `shouldEqual` expandLinks sample1
    it "global replace multiple URLs" do
      sample2Expanded `shouldEqual` expandLinks sample2
    it "replace URL at start" do
      sample3Expanded `shouldEqual` expandLinks sample3
    it "ignore URLs already embedded as HTML double-quoted attributes" do
      sample4 `shouldEqual` expandLinks sample4
    it "ignore URLs already embedded as HTML single-quoted attributes" do
      sample5 `shouldEqual` expandLinks sample5
    it "global replace single You Tube Watch URL" do
      sample6Expanded `shouldEqual` expandYouTubeWatchLinks sample6

sample1 :: String
sample1 =
   " http://www.google.com and then some text"

sample1Expanded :: String
sample1Expanded =
   """ <a href="http://www.google.com" >http://www.google.com</a> and then some text"""

sample2 :: String
sample2 =
   "Google: http://www.google.com and then BBC news: https://www.bbc.co.uk/news"

sample2Expanded :: String
sample2Expanded =
   """Google: <a href="http://www.google.com" >http://www.google.com</a> and then"""  <>
   """ BBC news: <a href="https://www.bbc.co.uk/news" >https://www.bbc.co.uk/news</a>"""

sample3 :: String
sample3 =
   "https://www.bbc.co.uk/news"

sample3Expanded :: String
sample3Expanded =
   """<a href="https://www.bbc.co.uk/news" >https://www.bbc.co.uk/news</a>"""

sample4 :: String
sample4 =
    """already embedded URL: <a href="https://www.bbc.co.uk/news" >https://www.bbc.co.uk/news</a>"""

sample5 :: String
sample5 =
    "already embedded URL: <a href='https://www.bbc.co.uk/news' >https://www.bbc.co.uk/news</a>"

sample6 :: String
sample6 =
  "http://www.youtube.com/watch?v=7fw2eTvYUcE"

sample6Expanded :: String
sample6Expanded =
  "<iframe width='420' height='315' src='//www.youtube.com/embed/7fw2eTvYUcE' frameborder='0' allowfullscreen='true'></iframe>"
