module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


-- MODEL


type alias Model =
    { icon_url : String
    , id : String
    , value : String
    }



-- UPDATE


type Msg
    = NewJoke


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewJoke ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Chuck Norris..." ]
        , div [] [ p [] [ text "joke" ] ]
        , button [] [ text "Get Joke" ]
        ]



-- MAIN


init : ( Model, Cmd Msg )
init =
    ( Model "" "" "", Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
