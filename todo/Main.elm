module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, keyCode, onInput, onCheck, onClick)
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
    | Uncomplete Todo
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
                , todo = { newTodo | id = model.nextId }
                , nextId = model.nextId + 1
            }

        UpdateField title ->
            { model | todo = Todo title False False model.todo.id }

        Complete todo ->
            let
                updateTodo thisTodo =
                    if thisTodo.id == todo.id then
                        { todo | completed = True }
                    else
                        thisTodo
            in
                { model | todos = List.map updateTodo model.todos }

        Uncomplete todo ->
            let
                updateTodo thisTodo =
                    if thisTodo.id == todo.id then
                        { todo | completed = False }
                    else
                        thisTodo
            in
                { model | todos = List.map updateTodo model.todos }

        Delete todo ->
            model

        Filter filterState ->
            { model | filter = filterState }



-- VIEW


view : Model -> Html Msg
view model =
    section [ class "todoapp" ]
        [ header [ class "header" ]
            [ h1 [] [ text "todos" ] ]
        , newTodoInput model
        , section [ class "main" ]
            [ ul [ class "todo-list" ]
                (List.map todoView (filteredTodos model))
            ]
        , footer [ class "footer " ]
            [ span [ class "todo-count" ]
                [ strong [] [ text (toString (List.length (filteredTodos model))) ]
                , text " items left"
                ]
            , ul [ class "filters" ]
                [ filterItemView model All
                , filterItemView model Active
                , filterItemView model Completed
                ]
            , button [ class "clear-completed" ] [ text "Clear completed" ]
            ]
        ]


filteredTodos : Model -> List Todo
filteredTodos model =
    let
        matchesFilter =
            case model.filter of
                All ->
                    (\_ -> True)

                Active ->
                    (\todo -> todo.completed == False)

                Completed ->
                    (\todo -> todo.completed == True)
    in
        List.filter matchesFilter model.todos


filterItemView : Model -> FilterState -> Html Msg
filterItemView model filterState =
    li []
        [ a [ classList [ ( "selected", (model.filter == filterState) ) ], href "#", onClick (Filter filterState) ]
            [ text (toString filterState) ]
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
    let
        handleComplete =
            case todo.completed of
                True ->
                    (\_ -> Uncomplete todo)

                False ->
                    (\_ -> Complete todo)
    in
        li [ classList [ ( "completed", todo.completed ) ] ]
            [ div [ class "view" ]
                [ input
                    [ class "toggle"
                    , type_ "checkbox"
                    , checked todo.completed
                    , onCheck handleComplete
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
