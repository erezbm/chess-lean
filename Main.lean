import ChessLean


def handleClientToEngineCommand : ClientToEngineCommand → Option EngineToClientCommand
  | .uci =>  pure .uciok
  | .isready => pure .readyok
  | .go => pure .bestmove
  | _ => none

def generateEngineResponse : EngineToClientCommand → List String
  | .uciok => ["id name Chess Lean", "id author Erez and Tamir", "uciok"]
  | .readyok  => ["readyok"]
  | .bestmove => ["bestmove e2e4"]

def parseClientToEngineCommand : String → Option ClientToEngineCommand
  | "uci" => pure .uci
  | "isready" => pure .isready
  | "ucinewgame" => pure .ucinewgame
  | "stop" => pure .stop
  | "quit" => pure .quit
  | s => if s.startsWith "go" then pure .go else none

def main : IO Unit := do repeat
  Functor.mapConst () $ OptionT.run do
    let line ← (← IO.getStdin).getLine
    let clientCmd ← liftOption $ parseClientToEngineCommand line.trimAscii.toString
    let engineCmd ← liftOption $ handleClientToEngineCommand clientCmd
    for response in generateEngineResponse engineCmd do
      IO.println response
