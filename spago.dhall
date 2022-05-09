{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "expand-links"
, dependencies =
  [ "arrays"
  , "either"
  , "maybe"
  , "partial"
  , "prelude"
  , "strings"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT"
, repository = "https://github.com/newlandsvalley/purescript-expand-links"
}
