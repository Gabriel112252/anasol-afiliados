import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cep", "street", "neighborhood", "city", "state", "loading"]

  maskCep(event) {
    let v = event.target.value.replace(/\D/g, "").slice(0, 8)
    if (v.length > 5) v = `${v.slice(0, 5)}-${v.slice(5)}`
    event.target.value = v

    if (v.replace(/\D/g, "").length === 8) this.fetchAddress(v.replace(/\D/g, ""))
  }

  async fetchAddress(cep) {
    if (this.hasLoadingTarget) this.loadingTarget.classList.remove("hidden")

    try {
      const res  = await fetch(`https://viacep.com.br/ws/${cep}/json/`)
      const data = await res.json()

      if (!data.erro) {
        const mapping = {
          street:       data.logradouro,
          neighborhood: data.bairro,
          city:         data.localidade,
          state:        data.uf
        }
        Object.entries(mapping).forEach(([key, value]) => {
          const target = this[`${key}Target`]
          target.value = value || ""
          target.dispatchEvent(new Event("input", { bubbles: true }))
        })
      }
    } catch {
      // CEP não encontrado — usuário preenche manualmente
    } finally {
      if (this.hasLoadingTarget) this.loadingTarget.classList.add("hidden")
    }
  }
}
