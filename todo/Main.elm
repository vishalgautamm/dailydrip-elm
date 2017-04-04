module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, keyCode, onInput)
import Json.Decode as Json


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
    | Update String


initialModel : Model
initialModel =
    { todos = [ fakeTodo ]
    , todo = Todo "" False False
    , filter = All
    }


fakeTodo : Todo
fakeTodo =
    { title = "A fake todo"
    , completed = False
    , editing = False
    }



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        Add todo ->
            -- refactor: todo param no longer necessary
            { model
                | todos = model.todo :: model.todos
                , todo = Todo "" False False
            }

        Update title ->
            { model | todo = Todo title False False }

        Complete todo ->
            model

        Delete todo ->
            model

        Filter filterState ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    section [ class "todoapp" ]
        [ header [ class "header" ]
            [ h1 [] [ text "todos" ] ]
        , newTodoInput model
        , section [ class "main" ]
            [ ul [ class "todo-list" ]
                (List.map todoView model.todos)
            ]
        ]


newTodoInput : Model -> Html Msg
newTodoInput model =
    input
        [ class "new-todo"
        , placeholder "What needs done?"
        , autofocus True
        , onEnter (Add model.todo)
        , onInput Update
        , value model.todo.title
        ]
        []


todoView : Todo -> Html Msg
todoView todo =
    li [ classList [ ( "completed", todo.completed ) ] ]
        [ div [ class "view" ]
            [ input [ class "toggle", type_ "checkbox", checked todo.completed ] []
            , label [] [ text todo.title ]
            , button [ class "destroy" ] []
            ]
        ]


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "Ignored key"
    in
        on "keydown" (Json.andThen isEnter keyCode)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }
