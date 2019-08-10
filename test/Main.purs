module Test.Main where

import Control.Monad.Free (Free)
import Data.Link (expandLinks)
import Effect (Effect)
import Prelude (Unit, discard, ($), (<>))
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

main :: Effect Unit
main = runTest do
  urlExpansionSuite

urlExpansionSuite :: Free TestF Unit
urlExpansionSuite =
  suite "URL expansion" do
    test "global replace single URL" do
      Assert.equal sample1Expanded $ expandLinks sample1
    test "global replace multiple URLs" do
      Assert.equal sample2Expanded $ expandLinks sample2
    test "replace URL at start" do
      Assert.equal sample3Expanded $expandLinks sample3
    test "ignore URLs already embedded as HTML double-quoted attributes" do
      Assert.equal sample4 $ expandLinks sample4
    test "ignore URLs already embedded as HTML single-quoted attributes" do
      Assert.equal sample5 $ expandLinks sample5

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
