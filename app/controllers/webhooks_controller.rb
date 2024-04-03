class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    def stripe
      payload = request.body.read
      event = nil
  
      # Verify webhook signature and extract the event
      # See Stripe documentation for details
  
      if event.type == 'payment_intent.succeeded'
        payment_intent = event.data.object
        order = Order.find_by(payment_intent_id: payment_intent.id)
        order.update(status: 'paid') if order.present?
      end
  
      head :no_content
    end
  end
  