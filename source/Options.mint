module OptionsModal {
  fun openOptions (e : Html.Event) {
    sequence {
      modal = <Ui.Modal.Content title=<{"Options"}> icon={Ui.Icons:GEAR} content={<Options/>} />
      Ui.Modal.show(modal)
      Promise.never()
    } catch {
      Promise.never()
    }
  }

  fun showJson (e : Html.Event) {
    sequence {
      modal = <Ui.Modal.Content title=<{"Json is here"}>
        actions=<{
          <Ui.Button label="???"/>
          <Ui.Button onClick={OptionsModal.openOptions()} label="Back"/>
        }>
        icon={Ui.Icons:BEAKER} content={<OptionsJson/>} />
      Ui.Modal.show(modal)
      Promise.never()
    } catch {
      Promise.never()
    }
  }
}

component Options {
  connect App exposing { saveStatus }

  state link = "(the link here, soon)"

  fun copyLink (e : Html.Event) {
    sequence {
      Clipboard.set(link)
      Ui.Notifications.notify(<{"Copied!"}>, 1500)
    }
  }

  fun render {
    <Ui.Column>
      <Ui.Row justify="space-between" align="center">
        <span>"Auto save? (local storage) (not ready)"</span>
        <Ui.Toggle
          onLabel="yes"
          offLabel="no"/>
      </Ui.Row>
      <Ui.Row justify="space-between" align="center">
        <span>"Want to activate dice set feature ? (not ready)"</span>
        <Ui.Toggle
          offLabel="no"/>
      </Ui.Row>
      <p>
        "If you want to share you config, use this link:"<br/>
        <input class="opt-path" disabled={true} value={link}/>
        <span class="opt-copy"><Ui.Button onClick={copyLink()} iconBefore={Ui.Icons:CLIPPY}/></span>
      </p>
      <Ui.Row justify="center">
        <Ui.Button label="Let me see Json!" onClick={OptionsModal.showJson()}/>
      </Ui.Row>
      <Ui.Row>
        "(Clear config)"
      </Ui.Row>
    </Ui.Column>
  }
}

component OptionsJson {
  fun render {
    <p>"Not ready yet"</p>
  }
}