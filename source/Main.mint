routes {
  * {
    Debug.log("TODO : handle share path")
  }
}

component Main {
  connect App exposing { diceSet, init, lines, mode, order, setList }

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
    Map.get(setList, order)
      |> Maybe.withDefault([])
      |> Array.mapWithIndex((key : String, id : Number) { case (Map.get(key, lines)) {
        Maybe::Nothing => <></>
        Maybe::Just v => <RollLine info={LineInfo(key, id, v)} />
      }})
  }

  fun componentDidMount : Promise(Never, Void) { init() }

  /* ############################# */

  fun render : Html {
    <Ui.Theme.Root
      fontConfiguration={Ui:DEFAULT_FONT_CONFIGURATION}
      tokens={Ui:DEFAULT_TOKENS}>
      <Ui.Column justify="center" align="center" gap={Ui.Size::Px(10)}>
        <h1>"Dicey"</h1>
        if (diceSet) {
          <Ui.Tabs items={[
            {label = "tab 1", content = <{"the tab 1"}>, key = "tab1", iconBefore=<></>, iconAfter=<></>},
            {label = "tab 2", content = <{"the tab 2"}>, key = "tab2", iconBefore=<></>, iconAfter=<></>},
            {label = "tab 3", content = <{"the tab 3"}>, key = "tab3", iconBefore=<></>, iconAfter=<></>},
            {label = "tab 4", content = <{"the tab 4"}>, key = "tab4", iconBefore=<></>, iconAfter=<></>},
            {label = "tab 5", content = <{"the tab 5"}>, key = "tab5", iconBefore=<></>, iconAfter=<></>},
            {label = "tab 6", content = <{"the tab 6"}>, key = "tab6", iconBefore=<></>, iconAfter=<></>},
            {label = "tab 7", content = <{"the tab 7"}>, key = "tab7", iconBefore=<></>, iconAfter=<></>}
          ]}
            onChange={(tab : String) { next { seltab = tab } }}
            breakpoint={500} active={seltab}/>
        }
        <table class={currClass}><{ rows }></table>
        <Ui.Row align="center">
          <Ui.DarkModeToggle size={Ui.Size::Px(13)} />
          <span>"v0.2.0"</span>
          <Ui.Toggle
            onChange={App.changeMode()}
            checked={currMode} width={Ui.Size::Px(140)}
            disabled={false} onLabel="Edit" offLabel="Classic"/>
          <Ui.Button
            onClick={OptionsModal.openOptions()}
            size={Ui.Size::Px(14)}
            label="Options" />
        </Ui.Row>

        if (treing) { <Ui.Button
          onClick={toTest()}
          label="test" /> }

      </Ui.Column>
    </Ui.Theme.Root>
  }


  state seltab = "tab1"

  state treing = false

  fun toTest (e : Html.Event) {
    sequence {
      Debug.log(order)
      Debug.log(setList)
      Debug.log(Map.get(setList, order))
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
