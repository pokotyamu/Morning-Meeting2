require 'rails_helper'

RSpec.describe GraphBuilderService, :type => :service do
  describe '#build' do
    subject { GraphBuilderService.new(team, date).build }
    let(:team) { FactoryBot.create(:team) }
    let!(:monthly_target) { FactoryBot.create(:monthly_target, team: team) }
    let!(:weekly_performance_1) { FactoryBot.create(:weekly_performance, monthly_target: monthly_target, start_on: Date.new(2019, 3, 4)) }
    let!(:weekly_performance_2) { FactoryBot.create(:weekly_performance, monthly_target: monthly_target, start_on: Date.new(2019, 3, 11)) }
    let!(:weekly_performance_3) { FactoryBot.create(:weekly_performance, monthly_target: monthly_target, start_on: Date.new(2019, 3, 18)) }
    let!(:weekly_performance_4) { FactoryBot.create(:weekly_performance, monthly_target: monthly_target, start_on: Date.new(2019, 3, 25)) }
    let(:date) { Date.new(2019, 3, 1) }

    it 'xAxis' do
      expect(subject.options.dig(:xAxis, :categories)).to eq ["03/04 から 03/10", "03/11 から 03/17", "03/18 から 03/24", "03/25 から 03/31"]
    end
  end
end
