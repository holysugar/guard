require 'spec_helper'

describe Guard::Notifier::Blink1 do

  let(:fake_blink1) do
    Class.new do
      attr_accessor :delay_millis
      def open; end
      def set_rgb(*args); end
      def blink(*args); end
      def close; end
    end
  end

  before do
    subject.stub(:require)
    stub_const 'Blink1', fake_blink1
  end

  describe '.available?' do
    context 'without the silent option' do
      it 'shows an error message when the gem cannot be loaded' do
        ::Guard::UI.should_receive(:error).with "Please add \"gem 'rb-blink1'\" to your Gemfile and run Guard with \"bundle exec\"."
        subject.should_receive(:require).with('blink1').and_raise LoadError
        subject.available?
      end
    end
  end

  describe '.notify' do
    context 'with success message type options' do
      it 'blinks green 1 time' do
        fake_blink1.any_instance.should_receive(:blink).with(0, 255, 0, 1)
        subject.notify('success', 'any title', 'any message', 'any image', { })
      end
    end

    context 'with pending message type options' do
      it 'blinks yellow 1 time' do
        fake_blink1.any_instance.should_receive(:blink).with(255, 255, 0, 1)
        subject.notify('pending', 'any title', 'any message', 'any image', { })
      end
    end

    context 'with failed message type options' do
      it 'blinks red 3 times' do
        fake_blink1.any_instance.should_receive(:blink).with(255, 0, 0, 3)
        subject.notify('failed', 'any title', 'any message', 'any image', { })
      end
    end
  end
end
