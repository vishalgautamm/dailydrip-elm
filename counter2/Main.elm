port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    { counter : Int
    , decrements : Int
    , increments : Int
    }


initialModel : Model
initialModel =
    Model 0 0 0


type Msg
    = Increment
    | Decrement
    | Set Int
    | NoOp


port jsMsgs : (Int -> msg) -> Sub msg


port storageInput : (Int -> msg) -> Sub msg


port increment : () -> Cmd msg


port storage : Int -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            let
                newModel =
                    { model
                        | counter = model.counter + 1
                        , increments = model.increments + 1
                    }
            in
                ( newModel
                , Cmd.batch
                    [ increment ()
                    , storage newModel.counter
                    ]
                )

        Decrement ->
            let
                newModel =
                    { model
                        | counter = model.counter - 1
                        , decrements = model.decrements + 1
                    }
            in
                ( newModel
                , storage newModel.counter
                )

        Set newCount ->
            ( { model | counter = newCount }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


mapJsMsg : Int -> Msg
mapJsMsg int =
    case int of
        1 ->
            Increment

        _ ->
            NoOp


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (toString model.counter) ]
        , button [ onClick Increment ] [ text "+" ]
        , h3 [] [ text ("# of increments: " ++ (toString model.increments)) ]
        , h3 [] [ text ("# of decrements: " ++ (toString model.decrements)) ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ jsMsgs mapJsMsg
        , storageInput Set
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
