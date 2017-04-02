module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


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
    section [ class "todoapp" ]
        [ header [ class "header" ]
            [ h1 [] [ text "todos" ] ]
        , input [ class "new-todo", placeholder "What needs done?", autofocus True ] []
        , section [ class "main" ]
            [ ul [ class "todo-list" ]
                [ li [ class "completed" ]
                    [ div [ class "view" ]
                        [ input [ class "toggle", type_ "checkbox", checked True ] []
                        , label [] [ text "First Todo" ]
                        , button [ class "destroy" ] []
                        ]
                    ]
                ]
            ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }
