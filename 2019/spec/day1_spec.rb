require "rspec"
require_relative "../day1"

describe "day1" do
  it "finds the correct fuel for a mass" do
    expect(fuel(12)).to eq(2)
    expect(fuel(14)).to eq(2)
    expect(fuel(1969)).to eq(654)
    expect(fuel(100756)).to eq(33583)
  end

  it "finds all fuels for a list of masses and adds them" do
    expect(fuels_for_all([12, 12, 14])).to eq(6)
  end

  it "converts an array of strings and newlines to integer" do
    expect(read_masses(%w(1\n 2\n 3\n 8\n))).to eq([1, 2, 3, 8])
  end

  it "removes empty lines" do
    lines = [
      "12\n",
      "13\n",
      ""
    ]

    expect(read_masses(lines)).to eq([12, 13])
  end
end

