inductive ClientToEngineCommand : Type where
  | uci
  | isready
  | ucinewgame
  | go (s : String)
  | stop
  | quit

def ClientToEngineCommand.parse : (line : String) → Option ClientToEngineCommand
  | "uci" => pure .uci
  | "isready" => pure .isready
  | "ucinewgame" => pure .ucinewgame
  | "stop" => pure .stop
  | "quit" => pure .quit
  | s => if s.startsWith "go" then pure (.go (s.dropPrefix "go").trimAscii.toString) else none


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
