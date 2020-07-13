module Hello.PureScript
       ( app
       , handler
       ) where

import Prelude
import Control.Monad.Except (runExcept)
import Data.Maybe (Maybe (..), fromMaybe)
import Data.Either (Either (..))
import Data.Int (decimal, fromStringAs)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (error)
import Foreign (F, renderForeignError)
import Data.Argonaut.Encode (encodeJson, class EncodeJson)
import Data.Argonaut.Core (stringify)
import Node.Encoding (Encoding(..))
import Node.Express.App (App, get, post, use)
import Node.Express.Handler (Handler, HandlerM)
import Node.Express.Request (getBody, getRequestHeader)
import Node.Express.Response (render, setStatus)
import Node.Net.Socket as Socket
import Node.Process (lookupEnv)
import Hello.Lambda as Lambda
import Hello.Middlewares as Middlewares

helloHandler :: Handler
helloHandler = do
  setStatus 200
  render "hello" unit

timeHandler :: Handler
timeHandler = do
  setStatus 200
  render "time" unit

app :: App
app = do
  use Middlewares.jsonParser
  use Middlewares.urlencodedParser

  post "/hello" helloHandler
  get  "/time"  timeHandler

  use Middlewares.notFoundHandler

handler :: Lambda.HttpHandler
handler = Lambda.makeHandler app
