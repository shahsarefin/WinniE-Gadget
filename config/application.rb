require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module WinniEGadget
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w(assets tasks))

    # Configure Stripe API keys
    config.stripe_secret_key = "sk_test_51Oys1NJCYOsLGkPMGZNUWmBoheGyXdm5R6hcpRfllF6uZSQSzSslu4n7iXPpCZklmyFlWNywj4wj3rGNYnO5jrO400Tvy79pC2"
    config.stripe_publishable_key = "pk_test_51Oys1NJCYOsLGkPMJzbSFV7jOXP9Ip3jDczYzXW9f7rPK0v7FPuBd86DVE92i76mEnd5SOExCGEyN8dFjuAqwGVT00022538eU"
  end
end
