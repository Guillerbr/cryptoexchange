module Cryptoexchange::Exchanges
  module Kkcoin
    module Services
      class OrderBook < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            true
          end
        end

        def fetch(market_pair)
          output = super(ticker_url(market_pair))
          adapt(output, market_pair)
        end

        def ticker_url(market_pair)
          "#{Cryptoexchange::Exchanges::Kkcoin::Market::API_URL}/book?symbol=#{market_pair.base_raw}_#{market_pair.target_raw}"
        end

        def adapt(output, market_pair)
          order_book = Cryptoexchange::Models::OrderBook.new
          timestamp = Time.now.to_i

          order_book.base      = market_pair.base
          order_book.target    = market_pair.target
          order_book.market    = Kkcoin::Market::NAME
          order_book.asks      = adapt_orders output['a']
          order_book.bids      = adapt_orders output['b']
          order_book.timestamp = timestamp
          order_book.payload   = output
          order_book
        end

        def adapt_orders(orders)
          orders.collect do |order_entry|
            Cryptoexchange::Models::Order.new(price: order_entry[0],
                                              amount: order_entry[1],
                                              timestamp: nil)
          end
        end
      end
    end
  end
end
