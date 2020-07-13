{ name = "reflabs-purescript-lambda-starter"
, dependencies =
  [ "argonaut-codecs"
  , "console"
  , "effect"
  , "express"
  , "foreign-generic"
  , "node-buffer"
  , "node-net"
  , "node-process"
  , "prelude"
  , "psci-support"
  , "stringutils"
  ]
, sources = [ "src/**/*.purs" ]
, packages = ./packages.dhall
}
