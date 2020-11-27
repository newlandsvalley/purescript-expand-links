{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "expand-links"
, dependencies =
  [ "console", "effect", "prelude", "strings" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
