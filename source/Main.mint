record DieLine {
  dieType : DieType,
  curr : Maybe(String)
}

enum MoveDir {
  Up
  Down
}

component Main {
  state lines : Map(String, DieLine) = Map.empty()
  state order : Array(String) = []

  get rows {
    Array.mapWithIndex((key : String, idx : Number) {
      case (Map.get(key, lines)) {
        Maybe::Just v =>
          { key, [
              Ui.Cell::Html(upBtn(idx, key)),
              Ui.Cell::Html(dnBtn(idx, key)),
              Ui.Cell::String(Randomizer.dieToStr(v.dieType)),
              Ui.Cell::String(Maybe.withDefault("", v.curr)),
              Ui.Cell::Html(rollBtn(key))
          ]}
        Maybe::Nothing => {"err", [Ui.Cell::String(key)]}
      }
    }, order)
  } where {
    btnSize = Ui.Size::Px(13)
    upBtn = (idx : Number, key : String) {
      if (idx > 0) {
        <Ui.Button onClick={lineMove(key, MoveDir::Up)} size={btnSize} iconBefore={Ui.Icons:ARROW_UP}/>
      } else { <></> }
    }
    dnBtn = (idx : Number, key : String) {
      if (idx != Array.size(order) - 1) {
        <Ui.Button onClick={lineMove(key, MoveDir::Down)} size={btnSize} iconBefore={Ui.Icons:ARROW_DOWN}/>
      } else { <></> }
    }
    rollBtn = (key : String) {
      <Ui.Button onClick={rollDie(key)} size={btnSize} label="Roll"/>
    }
  }

  fun toTest (e : Html.Event) {
    try {
      f = [1, 4, 3, 2]
      i = Array.indexOf(4, f)
      i2 = i + 1
      e = Maybe.withDefault(0,Array.at(i, f))
      f2 = Array.deleteAt(i, f)
        |> Array.insertAt(e, i + 1)
      Debug.log(f2)
      Promise.never()
    }
  }

  fun componentDidMount : Promise(Never, Void) {
    /* TODO : handle from local storage and/or url */
    sequence {
      b = Map.empty()
        |> Map.set("l1", defDie())
        /* |> Map.set("l2", DieLine(DieType::D8, Maybe::Nothing)) */
        /* |> Map.set("l3", defDie()) */
        /* |> Map.set("l4", DieLine(DieType::D4, Maybe::Nothing)) */
      /* next { lines = Map.set("l1", DieLine("d6", Maybe::Nothing), lines) } */
      next {
        lines = b
      }
      next { order = ["l1"] }
      /* next { order = ["l2", "l1", "l3", "l4"] } */
    }
  }

  fun defDie { DieLine(DieType::D6, Maybe::Nothing) }

  fun lineMove (key : String, dir : MoveDir, e : Html.Event) {
    try {
      i = Array.indexOf(key, order)
      newOrder = order
        |> Array.deleteAt(i)
        |> Array.insertAt(key, i + mov(dir))
      next { order = newOrder }
    }
  } where {
    mov = (dir : MoveDir) { case (dir) {
      MoveDir::Up => -1
      MoveDir::Down => 1
    }}
  }

  fun openOptions (e : Html.Event) {
    sequence {
      content = <p>"Not ready yet"</p>
      modal = <Ui.Modal.Content title=<{"Options"}> icon={Ui.Icons:GEAR} content={content} />
      Ui.Modal.show(modal)
      Promise.never()
    } catch {
      Promise.never()
    }
  }

  fun rollDie (key : String, e : Html.Event) {
    case (Map.get(key, lines)) {
      Maybe::Nothing => Promise.never()
      Maybe::Just v => next { lines = Map.set(key, newCurr(key), lines) }
    }
  } where {
    newCurr = (key : String) { case (Map.get(key, lines)) {
      Maybe::Nothing => defDie()
      Maybe::Just v => { v | curr = Maybe.just(Randomizer.dieToValue(v.dieType)) }
    }}
  }

  /* ############################# */

  fun render : Html {
    <Ui.Theme.Root
      fontConfiguration={Ui:DEFAULT_FONT_CONFIGURATION}
      tokens={Ui:DEFAULT_TOKENS}>
      <Ui.Column justify="center" align="center" gap={Ui.Size::Px(10)}>
        <h1>"Dicey"</h1>
        <div class="diceshow"><Ui.Table breakpoint={0} rows={rows} /></div>
        <Ui.Row align="center">
          <Ui.DarkModeToggle size={Ui.Size::Px(13)} />
          <span>"v0.1.0"</span>
          <Ui.Button
            onClick={openOptions()}
            size={Ui.Size::Px(14)}
            label="Options" />
        </Ui.Row>

        /* <Ui.Button
          onClick={toTest()}
          label="test" /> */

      </Ui.Column>
    </Ui.Theme.Root>
  }
}
