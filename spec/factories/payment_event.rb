FactoryBot.define do
  factory :payment_event do
    association :payment

    trait(:created_intent) do
      event_name { 'payment_intent.created' }
      raw_data do
        {
          'id' => 'evt_3Leos3LUUobuK6Uj1iBvNhkF',
          'object' => 'event',
          'api_version' => '2022-08-01',
          'created' => 1_662_421_108,
          'data' => {
            'object' => {
              'id' => 'pi_3Leos3LUUobuK6Uj1s2JY7yR',
              'object' => 'payment_intent',
              'amount' => 1400,
              'amount_capturable' => 0,
              'amount_details' => {
                'tip' => {
                }
              },
              'amount_received' => 0,
              'application' => nil,
              'application_fee_amount' => nil,
              'automatic_payment_methods' => nil,
              'canceled_at' => nil,
              'cancellation_reason' => nil,
              'capture_method' => 'automatic',
              'charges' => {
                'object' => 'list',
                'data' => [],
                'has_more' => false,
                'total_count' => 0,
                'url' => '/v1/charges?payment_intent=pi_3Leos3LUUobuK6Uj1s2JY7yR'
              },
              'client_secret' => 'pi_3Leos3LUUobuK6Uj1s2JY7yR_secret_fXaWrPPp6Lp1F2vQI0aemsM6y',
              'confirmation_method' => 'automatic',
              'created' => 1_662_421_107,
              'currency' => 'usd',
              'customer' => nil,
              'description' => nil,
              'invoice' => nil,
              'last_payment_error' => nil,
              'livemode' => false,
              'metadata' => {
              },
              'next_action' => nil,
              'on_behalf_of' => nil,
              'payment_method' => nil,
              'payment_method_options' => {
                'card' => {
                  'installments' => nil,
                  'mandate_options' => nil,
                  'network' => nil,
                  'request_three_d_secure' => 'automatic'
                }
              },
              'payment_method_types' => [
                'card'
              ],
              'processing' => nil,
              'receipt_email' => nil,
              'review' => nil,
              'setup_future_usage' => nil,
              'shipping' => nil,
              'source' => nil,
              'statement_descriptor' => nil,
              'statement_descriptor_suffix' => nil,
              'status' => 'requires_payment_method',
              'transfer_data' => nil,
              'transfer_group' => nil
            }
          },
          'livemode' => false,
          'pending_webhooks' => 1,
          'request' => {
            'id' => 'req_HEJBjkhSyKXPBb',
            'idempotency_key' => '9244b198-11e7-4435-8f20-537b29717020'
          },
          'type' => 'payment_intent.created'
        }
      end
    end

    trait(:succeeded_intent) do
      event_name { 'payment_intent.succeeded' }
      raw_data do
        {
          'id' => 'evt_3Leop4LUUobuK6Uj1wEQR3H5',
          'object' => 'event',
          'api_version' => '2022-08-01',
          'created' => 1_662_420_975,
          'data' => {
            'object' => {
              'id' => 'pi_3Leop4LUUobuK6Uj1OfuNFxD',
              'object' => 'payment_intent',
              'amount' => 1400,
              'amount_capturable' => 0,
              'amount_details' => {
                'tip' => {
                }
              },
              'amount_received' => 1400,
              'application' => nil,
              'application_fee_amount' => nil,
              'automatic_payment_methods' => {
                'enabled' => true
              },
              'canceled_at' => nil,
              'cancellation_reason' => nil,
              'capture_method' => 'automatic',
              'charges' => {
                'object' => 'list',
                'data' => [
                  {
                    'id' => 'ch_3Leop4LUUobuK6Uj14PqXB9h',
                    'object' => 'charge',
                    'amount' => 1400,
                    'amount_captured' => 1400,
                    'amount_refunded' => 0,
                    'application' => nil,
                    'application_fee' => nil,
                    'application_fee_amount' => nil,
                    'balance_transaction' => 'txn_3Leop4LUUobuK6Uj1WPnAQMk',
                    'billing_details' => {
                      'address' => {
                        'city' => nil,
                        'country' => 'CO',
                        'line1' => nil,
                        'line2' => nil,
                        'postal_code' => nil,
                        'state' => nil
                      },
                      'email' => nil,
                      'name' => nil,
                      'phone' => nil
                    },
                    'calculated_statement_descriptor' => 'Stripe',
                    'captured' => true,
                    'created' => 1_662_420_974,
                    'currency' => 'usd',
                    'customer' => nil,
                    'description' => nil,
                    'destination' => nil,
                    'dispute' => nil,
                    'disputed' => false,
                    'failure_balance_transaction' => nil,
                    'failure_code' => nil,
                    'failure_message' => nil,
                    'fraud_details' => {
                    },
                    'invoice' => nil,
                    'livemode' => false,
                    'metadata' => {
                    },
                    'on_behalf_of' => nil,
                    'order' => nil,
                    'outcome' => {
                      'network_status' => 'approved_by_network',
                      'reason' => nil,
                      'risk_level' => 'normal',
                      'risk_score' => 47,
                      'seller_message' => 'Payment complete.',
                      'type' => 'authorized'
                    },
                    'paid' => true,
                    'payment_intent' => 'pi_3Leop4LUUobuK6Uj1OfuNFxD',
                    'payment_method' => 'pm_1LeoptLUUobuK6Uj3vcI07Ti',
                    'payment_method_details' => {
                      'card' => {
                        'brand' => 'visa',
                        'checks' => {
                          'address_line1_check' => nil,
                          'address_postal_code_check' => nil,
                          'cvc_check' => 'pass'
                        },
                        'country' => 'US',
                        'exp_month' => 6,
                        'exp_year' => 2027,
                        'fingerprint' => 'YkmER7KexEwEGyqI',
                        'funding' => 'credit',
                        'installments' => nil,
                        'last4' => '4242',
                        'mandate' => nil,
                        'network' => 'visa',
                        'three_d_secure' => nil,
                        'wallet' => nil
                      },
                      'type' => 'card'
                    },
                    'receipt_email' => nil,
                    'receipt_number' => nil,
                    'receipt_url' => 'https=>//pay.stripe.com/receipts/payment/CAcaFwoVYWNjdF8xTDIwR3JMVVVvYnVLNlVqKO-P2pgGMgZ4VPGcywM6LBacuFW2C00m8L4n9vdLwNNKT8_DMvPGPHh8mQDjfuO0kH-U4PBNsKLmWFvO',
                    'refunded' => false,
                    'refunds' => {
                      'object' => 'list',
                      'data' => [],
                      'has_more' => false,
                      'total_count' => 0,
                      'url' => '/v1/charges/ch_3Leop4LUUobuK6Uj14PqXB9h/refunds'
                    },
                    'review' => nil,
                    'shipping' => nil,
                    'source' => nil,
                    'source_transfer' => nil,
                    'statement_descriptor' => nil,
                    'statement_descriptor_suffix' => nil,
                    'status' => 'succeeded',
                    'transfer_data' => nil,
                    'transfer_group' => nil
                  }
                ],
                'has_more' => false,
                'total_count' => 1,
                'url' => '/v1/charges?payment_intent=pi_3Leop4LUUobuK6Uj1OfuNFxD'
              },
              'client_secret' => 'pi_3Leop4LUUobuK6Uj1OfuNFxD_secret_ze5tydMKn1RUUyTBrDoFbrgRV',
              'confirmation_method' => 'automatic',
              'created' => 1_662_420_922,
              'currency' => 'usd',
              'customer' => nil,
              'description' => nil,
              'invoice' => nil,
              'last_payment_error' => nil,
              'livemode' => false,
              'metadata' => {
              },
              'next_action' => nil,
              'on_behalf_of' => nil,
              'payment_method' => 'pm_1LeoptLUUobuK6Uj3vcI07Ti',
              'payment_method_options' => {
                'card' => {
                  'installments' => nil,
                  'mandate_options' => nil,
                  'network' => nil,
                  'request_three_d_secure' => 'automatic'
                },
                'link' => {
                  'persistent_token' => nil
                }
              },
              'payment_method_types' => %w[
                card
                link
              ],
              'processing' => nil,
              'receipt_email' => nil,
              'review' => nil,
              'setup_future_usage' => nil,
              'shipping' => nil,
              'source' => nil,
              'statement_descriptor' => nil,
              'statement_descriptor_suffix' => nil,
              'status' => 'succeeded',
              'transfer_data' => nil,
              'transfer_group' => nil
            }
          },
          'livemode' => false,
          'pending_webhooks' => 1,
          'request' => {
            'id' => 'req_s2i3S8R4P2aNE3',
            'idempotency_key' => 'a04320cc-459d-407a-9cfa-b337891906df'
          },
          'type' => 'payment_intent.succeeded'
        }
      end
    end

    trait(:failed_intent) do
      event_name { 'payment_intent.payment_failed' }
      raw_data do
        {
          'id' => 'evt_3Leop4LUUobuK6Uj1wEQR3H5',
          'object' => 'event',
          'api_version' => '2022-08-01',
          'created' => 1_662_420_975,
          'data' => {
            'object' => {
              'id' => 'pi_3Leop4LUUobuK6Uj1OfuNFxD',
              'object' => 'payment_intent',
              'amount' => 1400,
              'amount_capturable' => 0,
              'amount_details' => {
                'tip' => {
                }
              },
              'amount_received' => 1400,
              'application' => nil,
              'application_fee_amount' => nil,
              'automatic_payment_methods' => {
                'enabled' => true
              },
              'canceled_at' => nil,
              'cancellation_reason' => nil,
              'capture_method' => 'automatic',
              'charges' => {
                'object' => 'list',
                'data' => [
                  {
                    'id' => 'ch_3Leop4LUUobuK6Uj14PqXB9h',
                    'object' => 'charge',
                    'amount' => 1400,
                    'amount_captured' => 1400,
                    'amount_refunded' => 0,
                    'application' => nil,
                    'application_fee' => nil,
                    'application_fee_amount' => nil,
                    'balance_transaction' => 'txn_3Leop4LUUobuK6Uj1WPnAQMk',
                    'billing_details' => {
                      'address' => {
                        'city' => nil,
                        'country' => 'CO',
                        'line1' => nil,
                        'line2' => nil,
                        'postal_code' => nil,
                        'state' => nil
                      },
                      'email' => nil,
                      'name' => nil,
                      'phone' => nil
                    },
                    'calculated_statement_descriptor' => 'Stripe',
                    'captured' => true,
                    'created' => 1_662_420_974,
                    'currency' => 'usd',
                    'customer' => nil,
                    'description' => nil,
                    'destination' => nil,
                    'dispute' => nil,
                    'disputed' => false,
                    'failure_balance_transaction' => nil,
                    'failure_code' => nil,
                    'failure_message' => nil,
                    'fraud_details' => {
                    },
                    'invoice' => nil,
                    'livemode' => false,
                    'metadata' => {
                    },
                    'on_behalf_of' => nil,
                    'order' => nil,
                    'outcome' => {
                      'network_status' => 'approved_by_network',
                      'reason' => nil,
                      'risk_level' => 'normal',
                      'risk_score' => 47,
                      'seller_message' => 'Payment complete.',
                      'type' => 'authorized'
                    },
                    'paid' => true,
                    'payment_intent' => 'pi_3Leop4LUUobuK6Uj1OfuNFxD',
                    'payment_method' => 'pm_1LeoptLUUobuK6Uj3vcI07Ti',
                    'payment_method_details' => {
                      'card' => {
                        'brand' => 'visa',
                        'checks' => {
                          'address_line1_check' => nil,
                          'address_postal_code_check' => nil,
                          'cvc_check' => 'pass'
                        },
                        'country' => 'US',
                        'exp_month' => 6,
                        'exp_year' => 2027,
                        'fingerprint' => 'YkmER7KexEwEGyqI',
                        'funding' => 'credit',
                        'installments' => nil,
                        'last4' => '4242',
                        'mandate' => nil,
                        'network' => 'visa',
                        'three_d_secure' => nil,
                        'wallet' => nil
                      },
                      'type' => 'card'
                    },
                    'receipt_email' => nil,
                    'receipt_number' => nil,
                    'receipt_url' => 'https=>//pay.stripe.com/receipts/payment/CAcaFwoVYWNjdF8xTDIwR3JMVVVvYnVLNlVqKO-P2pgGMgZ4VPGcywM6LBacuFW2C00m8L4n9vdLwNNKT8_DMvPGPHh8mQDjfuO0kH-U4PBNsKLmWFvO',
                    'refunded' => false,
                    'refunds' => {
                      'object' => 'list',
                      'data' => [],
                      'has_more' => false,
                      'total_count' => 0,
                      'url' => '/v1/charges/ch_3Leop4LUUobuK6Uj14PqXB9h/refunds'
                    },
                    'review' => nil,
                    'shipping' => nil,
                    'source' => nil,
                    'source_transfer' => nil,
                    'statement_descriptor' => nil,
                    'statement_descriptor_suffix' => nil,
                    'status' => 'succeeded',
                    'transfer_data' => nil,
                    'transfer_group' => nil
                  }
                ],
                'has_more' => false,
                'total_count' => 1,
                'url' => '/v1/charges?payment_intent=pi_3Leop4LUUobuK6Uj1OfuNFxD'
              },
              'client_secret' => 'pi_3Leop4LUUobuK6Uj1OfuNFxD_secret_ze5tydMKn1RUUyTBrDoFbrgRV',
              'confirmation_method' => 'automatic',
              'created' => 1_662_420_922,
              'currency' => 'usd',
              'customer' => nil,
              'description' => nil,
              'invoice' => nil,
              'last_payment_error' => nil,
              'livemode' => false,
              'metadata' => {
              },
              'next_action' => nil,
              'on_behalf_of' => nil,
              'payment_method' => 'pm_1LeoptLUUobuK6Uj3vcI07Ti',
              'payment_method_options' => {
                'card' => {
                  'installments' => nil,
                  'mandate_options' => nil,
                  'network' => nil,
                  'request_three_d_secure' => 'automatic'
                },
                'link' => {
                  'persistent_token' => nil
                }
              },
              'payment_method_types' => %w[
                card
                link
              ],
              'processing' => nil,
              'receipt_email' => nil,
              'review' => nil,
              'setup_future_usage' => nil,
              'shipping' => nil,
              'source' => nil,
              'statement_descriptor' => nil,
              'statement_descriptor_suffix' => nil,
              'status' => 'succeeded',
              'transfer_data' => nil,
              'transfer_group' => nil
            }
          },
          'livemode' => false,
          'pending_webhooks' => 1,
          'request' => {
            'id' => 'req_s2i3S8R4P2aNE3',
            'idempotency_key' => 'a04320cc-459d-407a-9cfa-b337891906df'
          },
          'type' => 'payment_intent.succeeded'
        }
      end
    end
  end
end
