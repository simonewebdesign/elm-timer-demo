
import Signal exposing (Address, Mailbox)
import Task exposing (Task)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Time
import Timer


main : Signal Html
main =
  Signal.map (view actions.address) model


-- MODEL

type alias Model =

  { timer1 : Timer.Model
  }


initialModel : Model
initialModel =
  { timer1 = Timer.init
  }


-- UPDATE

type Action
  = NoOp
  | Timer1 Timer.Action


update : Action -> Model -> Model
update action model =
  case Debug.log "Main" action of
    NoOp ->
      model

    Timer1 subAction ->
      { model | timer1 = Timer.update subAction model.timer1 }


-- VIEW

view : Address Action -> Model -> Html
view address ({timer1} as model) =
  div []
    [ div []
        [ div [] [ text <| "A regular timer: " ++ (Timer.view timer1) ]
        ]
    , text <| "Model: " ++ toString model
    ]


-- SIGNALS

actions : Mailbox Action
actions =
  Signal.mailbox NoOp


model : Signal Model
model =
  Signal.foldp update initialModel input


input : Signal Action
input =
  Signal.mergeMany
      [ actions.signal
      , Signal.map Timer1 Timer.tick
      ]

--tasksMailbox : Mailbox (Task x ())
--tasksMailbox =
--  Signal.mailbox (Task.succeed ())


--port tasks : Signal (Task x ())
--port tasks =
--  tasksMailbox.signal
