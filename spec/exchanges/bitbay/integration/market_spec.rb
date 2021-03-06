require 'spec_helper'

RSpec.describe 'Bitbay integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:btc_usd_pair) { Cryptoexchange::Models::MarketPair.new(base: 'btc', target: 'usd', market: 'bitbay') }

  it 'fetch pairs' do
    pairs = client.pairs('bitbay')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to eq 'BCC'
    expect(pair.target).to eq 'USD'
    expect(pair.market).to eq 'bitbay'
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url btc_usd_pair.market
    expect(trade_page_url).to eq "https://bitbay.net/en/exchange-rate"
  end

  it 'fetch ticker' do
    ticker = client.ticker(btc_usd_pair)

    expect(ticker.base).to eq 'BTC'
    expect(ticker.target).to eq 'USD'
    expect(ticker.market).to eq 'bitbay'
    expect(ticker.last).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be_a Numeric
    expect(2000..Date.today.year).to include(Time.at(ticker.timestamp).year)
    expect(ticker.payload).to_not be nil
  end
end
