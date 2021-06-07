component Main {
  connect App exposing { init, lines, mode, order }

  state btnSize = Ui.Size::Px(13)

  get currClass { case (mode) {
    AppMode::Classic => "showroll classic"
    AppMode::Expert => "showroll expert"
  }}

  get currMode { case (mode) {
    AppMode::Classic => false
    AppMode::Expert => true
  }}

  get rows {
    Array.mapWithIndex((key : String, id : Number) { case (Map.get(key, lines)) {
      Maybe::Nothing => <></>
      Maybe::Just v => <RollLine info={LineInfo(key, id, v)} />
    }}, order)
  }

  fun componentDidMount : Promise(Never, Void) { init() }

  fun modalContent {
    <p>"Not ready yet"</p>
  }

  fun openOptions (e : Html.Event) {
    sequence {
      modal = <Ui.Modal.Content title=<{"Options"}> icon={Ui.Icons:GEAR} content={modalContent()} />
      Ui.Modal.show(modal)
      Promise.never()
    } catch {
      Promise.never()
    }
  }

  /* ############################# */

  fun render : Html {
    <Ui.Theme.Root
      fontConfiguration={Ui:DEFAULT_FONT_CONFIGURATION}
      tokens={Ui:DEFAULT_TOKENS}>
      <Ui.Column justify="center" align="center" gap={Ui.Size::Px(10)}>
        <h1>"Dicey"</h1>
        <table class={currClass}><{ rows }></table>
        <Ui.Row align="center">
          <Ui.DarkModeToggle size={Ui.Size::Px(13)} />
          <span>"v0.2.0"</span>
          <Ui.Toggle
            onChange={App.changeMode()}
            checked={currMode} width={Ui.Size::Px(140)}
            disabled={false} onLabel="Edit" offLabel="Classic"/>
          <Ui.Button
            onClick={openOptions()}
            size={Ui.Size::Px(14)}
            label="Options" />
        </Ui.Row>

        if (treing) { <Ui.Button
          onClick={toTest()}
          label="test" /> }

      </Ui.Column>
    </Ui.Theme.Root>
  }


  state treing = false

  fun toTest (e : Html.Event) {
    sequence {
      /* Debug.log(Randomizer.newKey()) */
      /* Debug.log("toTest") */
      /* Debug.log(Uid.generate()) */
      ks = Storage.Local.keys()
      Debug.log(ks)
      /* case (ks.toMaybe()) {
        Maybe::Nothing => Debug.log("nothing")
        Maybe::Just v => Debug.log(Array.size(v))
      } */
      Promise.never()
    } catch Storage.Error => storageError { sequence {
      Debug.log("storage error:")
      Debug.log(storageError)
      Promise.never()
    }}
  }

}
