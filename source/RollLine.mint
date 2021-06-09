record LineInfo {
  key : String,
  id : Number,
  die : DieLine
}

component RollLine {
  connect App exposing { btnSize, mode, order, setList }

  property info : LineInfo

  get orderSize {
    Map.get(setList, order)
      |> Maybe.withDefault([])
      |> Array.size()
  }

  fun rollin (e : Html.Event) {
    sequence {
      `
      (() => {
        var l1 = document.getElementById("line" + #{info.key});
        l1.className = "";
        void l1.offsetWidth;
        l1.className = "new-res";
      })()
      `
      App.rollDie(info.key)
      Promise.never()
    }
  }

  fun render {
    <tr id={"line" + info.key}>
      if (mode == AppMode::Expert) {
        <>
          <td class="updn-btn"> if (info.id > 0) {
            <Ui.Button onClick={App.lineMove(info.id, MoveDir::Up)}
              size={btnSize} iconBefore={Ui.Icons:ARROW_UP}/>
          } </td>
          <td class="updn-btn"> if (info.id != (orderSize - 1)) {
            <Ui.Button onClick={App.lineMove(info.id, MoveDir::Down)}
              size={btnSize} iconBefore={Ui.Icons:ARROW_DOWN}/>
          } </td>
        </>
      }
      <td class="label"><{ Randomizer.dieToStr(info.die.dieType) }></td>
      <td><{ Maybe.withDefault("", info.die.curr) }></td>
      <td class="roll-btn">
        <Ui.Button onClick={rollin()} size={btnSize} label="Roll"/>
      </td>
      /* if (mode == AppMode::Expert) {
        <>
          <td class="updn-btn"><Ui.Button
            size={btnSize} iconBefore={Ui.Icons:TRASHCAN}/></td>
        </>
      } */
    </tr>
  }
}
