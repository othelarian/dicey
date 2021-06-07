enum AppMode {
  Classic
  Expert
}

record DieLine {
  dieType : DieType,
  curr : Maybe(String)
}

module DieLine {
  fun create (dieType : DieType) { DieLine(dieType, Maybe::Nothing) }
}

enum MoveDir {
  Up
  Down
}

store App {
  state lines : Map(String, DieLine) = Map.empty()
  state mode = AppMode::Classic
  state order : Array(String) = []

  state btnSize = Ui.Size::Px(14)

  fun defDie { DieLine.create(DieType::Dn(6)) }

  fun changeMode (b : Bool) {
    next { mode = newMode }
  } where {
    newMode = case (mode) {
      AppMode::Classic => AppMode::Expert
      AppMode::Expert => AppMode::Classic
    }
  }

  fun init {
    sequence {
      b = Map.empty()
        |> Map.set("l1", DieLine.create(DieType::Dn(4)))
        |> Map.set("l2", defDie())
        |> Map.set("l3", DieLine.create(DieType::Dn(8)))
        |> Map.set("l4", DieLine.create(DieType::Dn(10)))
        |> Map.set("l5", DieLine.create(DieType::Dn(12)))
        |> Map.set("l6", DieLine.create(DieType::Dn(20)))
      next { lines = b }
      /* next { order = ["start"] } */
      next { order = ["l1", "l2", "l3", "l4", "l5", "l6"] }
    }
  }

  fun lineMove (id : Number, dir : MoveDir, e : Html.Event) {
    next { order = Array.swap(id, id + mov(dir), order) }
  } where {
    mov = (dir : MoveDir) { case (dir) {
      MoveDir::Up => -1
      MoveDir::Down => 1
    }}
  }

  fun rollDie (key : String) {
    case (Map.get(key, lines)) {
      Maybe::Nothing => Promise.never()
      Maybe::Just v => next { lines = Map.set(key, newCurr(key), lines) }
    }
  } where {
    newCurr = (key : String) { case (Map.get(key, lines)) {
      Maybe::Nothing => App.defDie()
      Maybe::Just v => { v | curr = Maybe.just(Randomizer.dieToValue(v.dieType)) }
    }}
  }
}