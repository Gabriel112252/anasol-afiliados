import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submit", "cpfInput", "cpfError", "emailInput", "emailError"]

  connect() {
    this.validate()
  }

  validate() {
    const fields = this.element.querySelectorAll(
      "input[required]:not([type='hidden']), select[required], textarea[required]"
    )
    const allFilled = Array.from(fields).every(field =>
      field.type === "checkbox" ? field.checked : field.value.trim() !== ""
    )

    const cpfOk   = this.checkCpf()
    const emailOk = this.checkEmail()

    if (this.hasSubmitTarget) this.submitTarget.disabled = !(allFilled && cpfOk && emailOk)
  }

  checkCpf() {
    if (!this.hasCpfInputTarget) return true
    const digits = this.cpfInputTarget.value.replace(/\D/g, "")

    if (digits.length < 11) {
      this.cpfErrorTarget.classList.add("hidden")
      return false
    }

    const valid = this.isCpfValid(digits)
    this.cpfErrorTarget.classList.toggle("hidden", valid)
    return valid
  }

  checkEmail() {
    if (!this.hasEmailInputTarget) return true
    const value = this.emailInputTarget.value.trim()

    if (value === "") {
      this.emailErrorTarget.classList.add("hidden")
      return false
    }

    const valid = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(value)
    this.emailErrorTarget.classList.toggle("hidden", valid)
    return valid
  }

  isCpfValid(digits) {
    if (/^(\d)\1{10}$/.test(digits)) return false

    for (const len of [9, 10]) {
      let sum = 0
      for (let i = 0; i < len; i++) sum += parseInt(digits[i]) * (len + 1 - i)
      let r = (sum * 10) % 11
      if (r >= 10) r = 0
      if (r !== parseInt(digits[len])) return false
    }
    return true
  }

  maskCpf(event) {
    let v = event.target.value.replace(/\D/g, "").slice(0, 11)
    v = v.replace(/(\d{3})(\d)/, "$1.$2")
    v = v.replace(/(\d{3})(\d)/, "$1.$2")
    v = v.replace(/(\d{3})(\d{1,2})$/, "$1-$2")
    event.target.value = v
  }

  maskWhatsapp(event) {
    let v = event.target.value.replace(/\D/g, "").slice(0, 11)
    if (v.length > 6) {
      v = `(${v.slice(0, 2)}) ${v.slice(2, 7)}-${v.slice(7)}`
    } else if (v.length > 2) {
      v = `(${v.slice(0, 2)}) ${v.slice(2)}`
    } else if (v.length > 0) {
      v = `(${v}`
    }
    event.target.value = v
  }
}
