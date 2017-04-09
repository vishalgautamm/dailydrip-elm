port module Main exposing (..)

import Html exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    Int


initialModel : Model
initialModel =
    0



-- UPDATE


type Msg
    = Click Int
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click x ->
            ( model + 1, setResult (x * x) )

        NoOp ->
            ( model, Cmd.none )



-- PORTS


port setResult : Int -> Cmd msg


port click : (Int -> msg) -> Sub msg



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ p []
            [ text ("Clicked " ++ (toString model) ++ " times") ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    click Click
