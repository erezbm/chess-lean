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

def main : IO Unit := do
    let stdin ← IO.getStdin
    let stdout ← IO.getStdout
    repeat do
      let cmd ← stdin.getLine
      match parseClientToEngineCommand cmd.trimAscii.toString with
      | some clientCmd =>
        match handleClientToEngineCommand clientCmd with
        | some engineCmd =>
          let responses := generateEngineResponse engineCmd
          for response in responses do
            stdout.putStrLn response
        | none => pure ()
      | none => pure ()
