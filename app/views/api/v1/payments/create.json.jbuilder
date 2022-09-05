json.partial! 'payment', payment: @payment
json.client_secret @payment_intent['client_secret']
