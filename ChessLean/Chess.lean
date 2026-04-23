inductive Piece
  | pawn
  | bishop
  | rook
  | knight
  | queen
  | king

inductive Player
  | black
  | white

@[simp]
def Player.opponent : Player → Player
  | black => .white
  | white => .black

@[simp]
theorem player_opponent_differs (p : Player) : p.opponent ≠ p := by
  cases p <;> simp

@[simp]
theorem opponent_of_opponent_is_self (p: Player) : p.opponent.opponent = p := by
  cases p <;> simp

def Tile := Option (Player × Piece)


abbrev rankLength := 8
abbrev fileLength := 8

def Board := Vector Tile (rankLength * fileLength)


def backRank : Vector Piece rankLength :=
  #v[.rook, .knight, .bishop, .queen, .king, .bishop, .knight, .rook]

def pawnRank : Vector Piece rankLength :=
  Vector.replicate _ .pawn

def emptyRank : Vector Tile rankLength :=
  Vector.replicate _ none

def playerRank (p : Player) (pieces : Vector Piece rankLength) : Vector Tile rankLength :=
  pieces.map (pure ∘ (p, ·))

def initialBoard : Board :=
  playerRank .white backRank ++
  playerRank .white pawnRank ++
  emptyRank ++
  emptyRank ++
  emptyRank ++
  emptyRank ++
  playerRank .black pawnRank ++
  playerRank .black backRank



structure GameState where
  board: Board
  turn: Player


def initialGameState : GameState := ⟨initialBoard, .white⟩
