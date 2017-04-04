module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, keyCode, onInput, onCheck)
import Json.Decode as Json


-- MODEL


type alias Model =
    { todos : List Todo
    , todo : Todo
    , filter : FilterState
    , nextId : Int
    }


type alias Todo =
    { title : String
    , completed : Bool
    , editing : Bool
    , id : Int
    }


type FilterState
    = All
    | Active
    | Completed


type Msg
    = Add
    | Complete Todo
    | Delete Todo
    | UpdateField String
    | Filter FilterState


newTodo : Todo
newTodo =
    { title = ""
    , completed = False
    , editing = False
    , id = 0
    }


initialModel : Model
initialModel =
    { todos = [ Todo "The first todo" False False 1 ]
    , todo = { newTodo | id = 2 }
    , filter = All
    , nextId = 3
    }



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        Add ->
            { model
                | todos = model.todo :: model.todos
                , todo = newTodo
                , nextId = model.nextId + 1
            }

        UpdateField title ->
            { model | todo = Todo title False False 0 }

        Complete todo ->
            let
                updateTodo thisTodo =
                    if thisTodo.id == todo.id then
                        { todo | completed = True }
                    else
                        thisTodo
            in
                { model | todos = List.map updateTodo model.todos }

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
        , onEnter Add
        , onInput UpdateField
        , value model.todo.title
        ]
        []


todoView : Todo -> Html Msg
todoView todo =
    li [ classList [ ( "completed", todo.completed ) ] ]
        [ div [ class "view" ]
            [ input
                [ class "toggle"
                , type_ "checkbox"
                , checked todo.completed
                , onCheck (\_ -> Complete todo)
                ]
                []
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
