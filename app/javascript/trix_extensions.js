const fontSizes = {
  small: "trix-font-size-small",
  normal: "trix-font-size-normal",
  large: "trix-font-size-large",
  xlarge: "trix-font-size-xlarge"
}

const fontFamilies = {
  roboto: "trix-font-family-roboto",
  serif: "trix-font-family-serif",
  mono: "trix-font-family-mono"
}

Trix.config.blockAttributes.heading2 = { tagName: "h2" }
Trix.config.blockAttributes.heading3 = { tagName: "h3" }

const defaultToolbarHTML = Trix.config.toolbar.getDefaultHTML
Trix.config.toolbar.getDefaultHTML = () => defaultToolbarHTML.call(Trix.config.toolbar)
  .replace(
    /(<button[^>]+data-trix-attribute="heading1"[^>]*>[\s\S]*?<\/button>)/,
    `$1
        <button type="button" class="trix-button trix-button--heading-2" data-trix-attribute="heading2" title="Heading 2" tabindex="-1">H2</button>
        <button type="button" class="trix-button trix-button--heading-3" data-trix-attribute="heading3" title="Heading 3" tabindex="-1">H3</button>`
  )

Object.entries(fontSizes).forEach(([name, value]) => {
  Trix.config.textAttributes[`fontSize${name}`] = {
    tagName: "span",
    className: value,
    inheritable: true
  }
})

Object.entries(fontFamilies).forEach(([name, value]) => {
  Trix.config.textAttributes[`fontFamily${name}`] = {
    tagName: "span",
    className: value,
    inheritable: true
  }
})

document.addEventListener("trix-initialize", (event) => {
  const toolbar = event.target.toolbarElement
  if (!toolbar || toolbar.querySelector(".trix-custom-formatting")) return

  toolbar.querySelector('[data-trix-attribute="heading1"]')?.remove()

  const formattingGroup = document.createElement("div")
  formattingGroup.className = "trix-button-group trix-custom-formatting"

  formattingGroup.append(
    createSelect("Font", [
      ["Roboto", "fontFamilyroboto"],
      ["Merriweather", "fontFamilyserif"],
      ["Source Code Pro", "fontFamilymono"]
    ], event.target),
    createSelect("Size", [
      ["Small", "fontSizesmall"],
      ["Normal", "fontSizenormal"],
      ["Large", "fontSizelarge"],
      ["Extra large", "fontSizexlarge"]
    ], event.target)
  )

  toolbar.querySelector(".trix-button-row")?.append(formattingGroup)
})

function createSelect(label, options, editor) {
  const select = document.createElement("select")
  select.className = "trix-format-select"
  select.setAttribute("aria-label", label)
  select.innerHTML = `<option value="">${label}</option>` +
    options.map(([text, value]) => `<option value="${value}">${text}</option>`).join("")

  select.addEventListener("change", () => {
    const attribute = select.value
    if (!attribute) return

    options.forEach(([, option]) => {
      if (option !== attribute) editor.editor.deactivateAttribute(option)
    })
    editor.editor.activateAttribute(attribute)
    select.value = ""
  })

  return select
}