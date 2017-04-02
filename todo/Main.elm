module Main exposing (..)

import Html exposing (..)


type alias Model =
    { todos : List Todo
    , todo : Todo
    , filter : FilterState
    }


type alias Todo =
    { title : String
    , completed : Bool
    , editing : Bool
    }


type FilterState
    = All
    | Active
    | Completed


type Msg
    = Add Todo
    | Complete Todo
    | Delete Todo
    | Filter FilterState


initialModel : Model
initialModel =
    { todos = []
    , todo = Todo "" False False
    , filter = All
    }


update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html Msg
view model =
    div [] [ text "todos" ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }
