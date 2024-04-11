// Create a Stripe client.
var stripe = Stripe('your_stripe_publishable_key');

// Create an instance of Elements.
var elements = stripe.elements();

// Create an instance of the card Element.
var card = elements.create('card');

// Add an instance of the card Element into the `card-element` div.
card.mount('#card-element');

// Handle form submission.
var form = document.getElementById('payment-form');
form.addEventListener('submit', function(event) {
  event.preventDefault();

  // Disable the submit button to prevent multiple submissions.
  document.getElementById('submit-payment').disabled = true;

  stripe.createToken(card).then(function(result) {
    if (result.error) {
      // Inform the user if there was an error.
      var errorElement = document.getElementById('card-errors');
      errorElement.textContent = result.error.message;

      // Re-enable the submit button.
      document.getElementById('submit-payment').disabled = false;
    } else {
      // Send the token to your server to process the payment.
      stripeTokenHandler(result.token);
    }
  });
});

// Submit the form with the token ID.
function stripeTokenHandler(token) {
  // Insert the token ID into the form so it gets submitted to the server.
  var form = document.getElementById('payment-form');
  var hiddenInput = document.createElement('input');
  hiddenInput.setAttribute('type', 'hidden');
  hiddenInput.setAttribute('name', 'stripeToken');
  hiddenInput.setAttribute('value', token.id);
  form.appendChild(hiddenInput);

  // Submit the form.
  form.submit();
}
