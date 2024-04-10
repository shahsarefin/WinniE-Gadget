// app/javascript/controllers/stripe_checkout_controller.js
import { Controller } from "@hotwired/stimulus";
import { loadStripe } from "@stripe/stripe-js";

export default class extends Controller {
  static values = {
    publishableKey: String
  }

  connect() {
    this.initializeStripe();
  }

  async initializeStripe() {
    const stripe = await loadStripe(this.publishableKeyValue);

    if (!stripe) {
      console.error("Stripe failed to initialize.");
      return;
    }

    const elements = stripe.elements();
    const card = elements.create("card");
    card.mount("#card-element");

    this.setupFormSubmission(stripe, card);
  }

  setupFormSubmission(stripe, card) {
    const form = document.getElementById('payment-form');
    form.addEventListener('submit', async (event) => {
      event.preventDefault();

      const { token, error } = await stripe.createToken(card);

      if (error) {
        console.log(error);
      } else {
        console.log('Token:', token);
        // Here you would handle form submission and token sending to your server.
        // Inside your Stimulus controller's setupFormSubmission method
setupFormSubmission(stripe, card) {
  const form = document.getElementById('payment-form');
  form.addEventListener('submit', async (event) => {
    event.preventDefault();

    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const country = document.getElementById('country').value;

    const { token, error } = await stripe.createToken(card, {
      name,
      email,
    });

    if (error) {
      console.error(error);
    } else {
      console.log('Token:', token);
      // Here you would handle form submission to your server including the token and other form data.
    }
  });
}

      }
    });
  }
}
