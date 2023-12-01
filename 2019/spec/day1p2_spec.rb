require "rspec"
require_relative "../day1p2"

describe "day1p2" do
  it "finds the correct cumulative fuel for a mass" do
    expect(fuel_cumulative(12)).to eq(2)
    expect(fuel_cumulative(14)).to eq(2)
    expect(fuel_cumulative(1969)).to eq(966)
    expect(fuel_cumulative(100756)).to eq(50346)
  end
end
