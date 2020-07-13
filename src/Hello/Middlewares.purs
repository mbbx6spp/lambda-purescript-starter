module Hello.Middlewares
       ( corsHandler
       , jsonParser
       , errorHandler
       , notFoundHandler
       , setCORSHeaders
       , urlencodedParser
       ) where

import Prelude (bind, discard, (<$>), (<>))
import Data.Foldable (any)
import Data.Function (($), identity)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Maybe (fromMaybe)
import Data.String.Utils (includes)
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Exception (Error, message)
import Effect.Console (log)
import Node.Express.Handler (Handler, HandlerM(..))
import Node.Express.Request (getMethod, getRequestHeader)
import Node.Express.Response (sendJson, setResponseHeader, setStatus)
import Node.Express.Types (Method (..), Request, Response)
import Node.Process (lookupEnv)

foreign import _jsonParser       :: Fn3 Request Response (Effect Unit) (Effect Unit)
foreign import _urlencodedParser :: Fn3 Request Response (Effect Unit) (Effect Unit)

allowableOrigins :: Array String
allowableOrigins = [ "m", "www" ]

jsonParser :: Handler
jsonParser = HandlerM $
  \req res nxt -> liftEffect $ runFn3 _jsonParser req res nxt

urlencodedParser :: Handler
urlencodedParser = HandlerM $
  \req res next -> liftEffect $ runFn3 _urlencodedParser req res next

notFoundHandler :: Handler
notFoundHandler = do
  setStatus 404
  sendJson { error: "Resource not found" }

errorHandler :: Error -> Handler
errorHandler err = do
  setStatus 400
  sendJson { error: message err }

corsHandler :: Handler
corsHandler = do
  method  <- getMethod
  origin  <- fromMaybe "" <$> getRequestHeader "Origin"
  mdomain <- liftEffect $ lookupEnv "DOMAIN"
  let domain = fromMaybe "example.com" mdomain
  case method of
    OPTIONS -> originMatchHandler origin domain
    _ -> notFoundHandler

generateAllowedOrigins :: String -> Array String -> Array String
generateAllowedOrigins domain subdomains = (\s -> "https://" <> s <> "." <> domain) <$> subdomains

originMatchHandler :: String -> String -> Handler
originMatchHandler origin domain =
  if isAllowableOrigin then do
    setCORSHeaders origin
    setStatus 200
    sendJson {}
  else notFoundHandler
  where
    isAllowableOrigin
      = any identity $ includes origin
                    <$> generateAllowedOrigins domain allowableOrigins

setCORSHeaders :: String -> Handler
setCORSHeaders origin = do
  setResponseHeader "Access-Control-Allow-Origin" origin
  setResponseHeader "Access-Control-Allow-Methods" "POST,OPTIONS"
  setResponseHeader "Access-Control-Allow-Headers" "content-type"
  setResponseHeader "Access-Control-Allow-Credentials" "true"
