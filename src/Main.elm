port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Auth0
import Authentication

main : Program (Maybe Auth0.LoggedInUser) Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

type alias Model =
  { authModel : Authentication.Model
  }

-- INIT
init : Maybe Auth0.LoggedInUser -> ( Model, Cmd Msg )
init initialUser =
  ( Model (Authentication.init auth0authorize auth0logout initialUser), Cmd.none )

-- MESSAGES
type Msg
  = AuthenticationMsg Authentication.Msg

-- PORTS
port auth0authorize : Auth0.Options -> Cmd msg
port auth0authResult : (Auth0.RawAuthenticationResult -> msg) -> Sub msg
port auth0logout : () -> Cmd msg

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AuthenticationMsg authMsg ->
      let
          ( authModel, cmd ) =
            Authentication.update authMsg model.authModel
      in
        ( { model | authModel = authModel }, Cmd.map AuthenticationMsg cmd )

-- SUBSCRIPTIONS
subscriptions : a -> Sub Msg
subscriptions model =
  auth0authResult (Authentication.handleAuthResult >> AuthenticationMsg)

-- VIEW
view : Model -> Html Msg
view model =
  div [ class "container" ]
      [ div [ class "jumbotron text-center" ]
          [ div []
              (case Authentication.tryGetUserProfile model.authModel of
                Nothing ->
                  [ p [] [ text "Please log in" ] ]

                Just user ->
                  [ p [] [ text ("Hello, " ++ user.email ++ "!") ] ]
              )
          , p []
              [ button
                  [ class "btn btn-primary"
                  , onClick
                      (AuthenticationMsg
                          (if Authentication.isLoggedIn model.authModel then
                              Authentication.LogOut
                            else
                              Authentication.ShowLogIn
                          )
                      )
                  ]
                  [ text
                      (if Authentication.isLoggedIn model.authModel then
                          "Log out"
                       else
                          "Log in"
                      )
                  ]
              ]
          ]
      ]
