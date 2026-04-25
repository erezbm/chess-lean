import ChessLean
import ChessLean.Chess

def determineBestMove : GameState → String := fun _ => "e2e4"

def replayFromPosition (position : Array String) (moves: Array String) : GameState := initialGameState

def handleClientToEngineCommand [Monad m]: ClientToEngineCommand → StateT
GameState m (Array EngineToClientCommand)
  | .uci => pure #[.id "name Chess Lean", .id "author Erez and Tamir", .uciok]
  | .ucinewgame => set initialGameState *> pure #[]
  | .isready => pure #[.readyok]
  | .position pos moves => set (replayFromPosition pos moves) *> pure #[]
  | .go _ => do pure #[.bestmove (determineBestMove (← get)) ]
  | _ => pure #[]


def engineLoop : StateT GameState IO Unit := do
  repeat
    let line ← (← IO.getStdin).getLine
    let some clientCmd := ClientToEngineCommand.parse line.trimAscii.toString | continue
    let engineCmds ← handleClientToEngineCommand clientCmd
    for engineCmd in engineCmds do
      IO.println engineCmd

def main: IO Unit := engineLoop.run' initialGameState
