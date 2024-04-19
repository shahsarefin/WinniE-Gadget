// app/javascript/packs/application.js
import "bootstrap"
import './stripe_integration'
import Rails from "@rails/ujs"

Rails.start()

document.addEventListener('turbolinks:load', () => {
    // This code will run on each visit
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl)
    })
  });