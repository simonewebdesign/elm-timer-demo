
import Html exposing (..)
import Time
import Timer


-- MODEL

type alias Model =
  { timer1 : Timer.Model
  , timer2 : Timer.Model
  }


initialModel : Model
initialModel =
  { timer1 = Timer.init
  , timer2 = Timer.init' << round <| Time.inSeconds Time.minute * 12
  }


-- UPDATE

type Action
  = Timer1 Timer.Action
  | Timer2 Timer.Action


update : Action -> Model -> Model
update action model =
  case Debug.log "Main" action of
    Timer1 subAction1 ->
      { model | timer1 = Timer.update subAction1 model.timer1 }

    Timer2 subAction2 ->
      { model | timer2 = Timer.update subAction2 model.timer2 }


-- VIEW

view : Model -> Html
view ({timer1, timer2} as model) =
  div []
    [ div []
        [ div [] [ text <| "A regular timer: " ++ (Timer.view timer1) ]
        , div [] [ text <| "Starts at 12:00: " ++ (Timer.view timer2) ]
        ]
    , text <| "Model: " ++ toString model
    ]


-- SIGNALS

main : Signal Html
main =
  Signal.map view model


model : Signal Model
model =
  Signal.foldp update initialModel input


input : Signal Action
input =
  Signal.mergeMany
      [ Signal.map Timer1 Timer.tick
      , Signal.map Timer2 Timer.tick
      ]
