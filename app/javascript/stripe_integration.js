document.addEventListener('turbolinks:load', function() {
    if (document.getElementById("card-element")) {
      var stripe = Stripe(pk_test_51Oys1NJCYOsLGkPMGZNUWmBoheGyXdm5R6hcpRfllF6uZSQSzSslu4n7iXPpCZklmyFlWNywj4wj3rGNYnO5jrO400Tvy79pC2); 
      var elements = stripe.elements();
      var card = elements.create('card');
      card.mount('#card-element');
  
      // Add form submission logic to create a payment with the payment intent
      var form = document.getElementById('payment-form'); // Ensure you have a form with this ID
      form.addEventListener('submit', function(event) {
        event.preventDefault();
  
        stripe.confirmCardPayment('{PAYMENT_INTENT_CLIENT_SECRET}', {
          payment_method: {
            card: card,
            billing_details: {
              // Include any billing details here
            }
          }
        }).then(function(result) {
          if (result.error) {
            // Display error.message in your UI.
            console.log(result.error.message);
          } else {
            if (result.paymentIntent.status === 'succeeded') {
              // The payment has been processed!
              console.log('Payment success!');
            }
          }
        });
      });
    }
  });
  