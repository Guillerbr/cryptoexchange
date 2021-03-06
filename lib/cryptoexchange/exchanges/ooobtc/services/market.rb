module Cryptoexchange::Exchanges
  module Ooobtc
    module Services
      class Market < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            false
          end
        end

        def fetch
          output = super ticker_url
          adapt_all(output)
        end

        def ticker_url
          "#{Cryptoexchange::Exchanges::Ooobtc::Market::API_URL}/getallticker"
        end

        def adapt_all(output)
          output['data'].map do |ticker|
            base, target = ticker['tickername'].split('_')
            market_pair  = Cryptoexchange::Models::MarketPair.new(
              base:   base,
              target: target,
              market: Ooobtc::Market::NAME
            )
            adapt(ticker, market_pair)
          end
        end

        def adapt(output, market_pair)
          ticker           = Cryptoexchange::Models::Ticker.new
          ticker.base      = market_pair.base
          ticker.target    = market_pair.target
          ticker.market    = Ooobtc::Market::NAME
          ticker.bid       = NumericHelper.to_d(output['bid'])
          ticker.ask       = NumericHelper.to_d(output['ask'])
          ticker.last      = NumericHelper.to_d(output['lastprice'])
          ticker.volume    = NumericHelper.to_d(output['volume'])
          ticker.timestamp = NumericHelper.to_d(output['timestamp'])
          ticker.payload   = output
          ticker
        end
      end
    end
  end
end
