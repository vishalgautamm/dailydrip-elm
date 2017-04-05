module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


type alias Model =
    { topic : String
    , gifUrl : String
    }


type Msg
    = RequestMore
    | NewGif (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestMore ->
            ( model, getRandomGif model.topic )

        NewGif _ ->
            ( model, Cmd.none )


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    Cmd.none


init : String -> ( Model, Cmd Msg )
init topic =
    let
        waitingUrl =
            "https://i.imgur.com/i6eXrfS.gif"
    in
        ( Model topic waitingUrl, getRandomGif topic )


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text model.topic ]
        , div [] [ img [ src model.gifUrl ] [] ]
        , button [ onClick RequestMore ] [ text "More, better..." ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = init "cats"
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
