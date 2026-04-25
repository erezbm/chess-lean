import ChessLean
import ChessLean.Chess


def handleClientToEngineCommand [Monad m]: ClientToEngineCommand → StateT
GameState m (Array EngineToClientCommand)
  | .uci => pure #[.id "name Chess Lean", .id "author Erez and Tamir", .uciok]
  | .ucinewgame => set initialGameState *> pure #[]
  | .isready => pure #[.readyok]
  | .go _ => pure #[.bestmove "e2e4"]
  | _ => pure #[]


def engineLoop : StateT GameState IO Unit := do
  repeat
    let line ← (← IO.getStdin).getLine
    let some clientCmd := ClientToEngineCommand.parse line.trimAscii.toString | continue
    let engineCmds ← handleClientToEngineCommand clientCmd
    for engineCmd in engineCmds do
      IO.println engineCmd

def main: IO Unit := engineLoop.run' initialGameState
