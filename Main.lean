import ChessLean
import ChessLean.Chess

def handleClientToEngineCommand : ClientToEngineCommand → Array EngineToClientCommand
  | .uci => #[.id "name Chess Lean", .id "author Erez and Tamir", .uciok]
  | .isready => #[.readyok]
  | .go _ => #[.bestmove "e2e4"]
  | _ => #[]

def main : IO Unit := do
  let mut gameState := initialGameState
  repeat
    let line ← (← IO.getStdin).getLine
    let some clientCmd := ClientToEngineCommand.parse line.trimAscii.toString | continue
    let engineCmds := handleClientToEngineCommand clientCmd
    for engineCmd in engineCmds do
      IO.println engineCmd
