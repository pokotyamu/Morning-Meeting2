require 'rails_helper'

RSpec.describe SlidesController, :type => :controller do
  describe '#business_weeks' do
    context '2月' do
      it "aaa" do
        expected = [4, 4, 4, 5, 4, 4, 5, 4, 5, 4, 4, 5]
        (1..12).each do |i|
          start_on = Date.new(2019, i)
          expect(SlidesController.new.business_weeks(start_on)).to eq expected[i - 1]
        end
      end
    end
  end
end
