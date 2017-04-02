module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    { counter : Int
    , decrements : Int
    , increments : Int
    }


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | counter = model.counter + 1, increments = model.increments + 1 }

        Decrement ->
            { model | counter = model.counter - 1, decrements = model.decrements + 1 }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (toString model.counter) ]
        , button [ onClick Increment ] [ text "+" ]
        , h3 [] [ text ("# of increments: " ++ (toString model.increments)) ]
        , h3 [] [ text ("# of decrements: " ++ (toString model.decrements)) ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = Model 0 0 0
        , view = view
        , update = update
        }
