require 'spec_helper'

describe Tomodachi do
  describe '.setup' do
    before { stub_const('ARGV', argv) }

    context 'given ARGV: auth' do
      let(:argv) { ['auth'] }
      let!(:auth) { double(Tomodachi::Auth) }

      before do
        Tomodachi::Auth.stub(:new).and_return(auth)
      end

      it 'starts twitter account authentication' do
        auth.should_receive(:create)
        Tomodachi.setup
      end
    end

    context 'given ARGV: accounts' do
      let(:argv) { ['accounts'] }

      it 'shows authenticated accout list' do
        Tomodachi::Auth.should_receive(:list)
        Tomodachi.setup
      end
    end

    context 'given ARGV: start' do
      context 'when ARGV is start [screen_name]' do
        let(:screen_name) { 'tkkbn' }
        let(:argv) { ['start', screen_name] }

        it 'starts to follow back for an account of given screen_name' do
          Tomodachi::Client.should_receive(:start).with(screen_name)
          Tomodachi.setup
        end
      end

      context 'when ARGV is start only' do
        let(:argv) { ['start'] }

        it 'shows correct command usage' do
          Tomodachi.should_receive(:puts).with('Usage: tomodachi start [screen_name]')
          Tomodachi.setup
        end
      end
    end

    context 'given ARGV: diff' do
      context 'when ARGV is diff [screen_name]' do
        let(:screen_name) { 'tkkbn' }
        let(:argv) { ['diff', screen_name] }

        it 'shows diff of following and follower' do
        end
      end

      context 'when ARGV is diff only' do
        let(:argv) { ['diff'] }

        it 'shows correct command usage' do
          Tomodachi.should_receive(:puts).with('Usage: tomodachi diff [screen_name]')
          Tomodachi.setup
        end
      end
    end

    context 'given invalid ARGV' do
      let(:argv) { %w(invalid argument) }

      it 'shows command examples of tomodachi' do
        Tomodachi.should_receive(:puts).with(<<-EOS)
tomodachi auth                # add account
tomodachi accounts            # authenticated account list
tomodachi start [screen_name] # follow back automatically
tomodachi diff [screen_name]  # show your diff between following and follower
        EOS
        Tomodachi.setup
      end
    end
  end
end
