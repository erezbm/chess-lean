


inductive ClientToEngineCommand : Type where
  | uci
  | isready
  | ucinewgame
  | go
  | stop
  | quit

inductive EngineToClientCommand : Type where
  | uciok
  | readyok
  | bestmove
