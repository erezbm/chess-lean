inductive ClientToEngineCommand : Type where
  | uci
  | isready
  | ucinewgame
  | position (position : Array String) (moves : Array String)
  | go (args : Array String)
  | stop
  | quit

def ClientToEngineCommand.parse (line : String) : Option ClientToEngineCommand := do
  let words := ((line.trimAscii.split Char.isWhitespace).filter (· != "".toSlice)).toArray.map toString
  let command ← words[0]?
  let args := words[1:]
  match command with
    | "uci" => pure .uci
    | "isready" => pure .isready
    | "ucinewgame" => pure .ucinewgame
    | "stop" => pure .stop
    | "quit" => pure .quit
    | "go" => pure $ .go args
    | "position" =>
        let (pos, moves) <- match (← args[0]?) with
          | "startpos" => pure (#[], args[1:])
          | "fen" => pure (args[1:7].toArray, args[8:])
          | _ => failure
        if moves.getD 0 "moves" != "moves" then failure
        pure $ .position pos moves[1:].toArray
    | _ => failure

inductive EngineToClientCommand : Type where
  | uciok
  | id (s : String)
  | readyok
  | bestmove (move : String)

instance : ToString EngineToClientCommand where
  toString
    | .uciok => "uciok"
    | .id s => "id " ++ s
    | .readyok  => "readyok"
    | .bestmove move => "bestmove " ++ move
