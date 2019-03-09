require 'rails_helper'

RSpec.describe GraphBuilderService, :type => :service do
  describe '#build' do
    subject { GraphBuilderService.new(team, date).build }
    let(:team) { FactoryBot.create(:team) }
    let!(:monthly_target) { FactoryBot.create(:monthly_target, team: team, value: 1000) }
    let!(:weekly_performance_1) { FactoryBot.create(:weekly_performance, monthly_target: monthly_target, start_on: Date.new(2019, 3, 4), value: 1) }
    let!(:weekly_performance_2) { FactoryBot.create(:weekly_performance, monthly_target: monthly_target, start_on: Date.new(2019, 3, 11), value: 2) }
    let!(:weekly_performance_3) { FactoryBot.create(:weekly_performance, monthly_target: monthly_target, start_on: Date.new(2019, 3, 18), value: 3) }
    let!(:weekly_performance_4) { FactoryBot.create(:weekly_performance, monthly_target: monthly_target, start_on: Date.new(2019, 3, 25), value: 4) }
    let(:date) { Date.new(2019, 3, 1) }

    it 'xAxis' do
      expect(subject.options.dig(:xAxis, :categories)).to eq ["03/04 から 03/10", "03/11 から 03/17", "03/18 から 03/24", "03/25 から 03/31"]
    end

    it 'series_performance_values' do
      expect(subject.series_data[0][:data]).to eq [1, 1, 1, 1]
      expect(subject.series_data[1][:data]).to eq [nil, 2, 2, 2]
      expect(subject.series_data[2][:data]).to eq [nil, nil, 3, 3]
      expect(subject.series_data[3][:data]).to eq [nil, nil, nil, 4]
    end

    it 'series_target_values' do
      expect(subject.series_data[4][:data]).to eq [[0, 1000], [3, 1000]]
    end
  end
end
