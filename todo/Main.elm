module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- MODEL


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
    { todos = [ Todo "The first todo" False False ]
    , todo = Todo "" False False
    , filter = All
    }



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    model



-- VIEW


todoView : Todo -> Html Msg
todoView todo =
    li [ classList [ ( "completed", todo.completed ) ] ]
        [ div [ class "view" ]
            [ input [ class "toggle", type_ "checkbox", checked todo.completed ] []
            , label [] [ text todo.title ]
            , button [ class "destroy" ] []
            ]
        ]


view : Model -> Html Msg
view model =
    section [ class "todoapp" ]
        [ header [ class "header" ]
            [ h1 [] [ text "todos" ] ]
        , input [ class "new-todo", placeholder "What needs done?", autofocus True ] []
        , section [ class "main" ]
            [ ul [ class "todo-list" ]
                (List.map todoView model.todos)
            ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }
