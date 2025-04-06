defmodule StatisticsTest do
  use ExUnit.Case
  doctest Statistics

  test "account_age_in_days calculates the difference of 1 day correctly" do
    yesterday =
      DateTime.utc_now()
      |> DateTime.add(-86400, :second)
      |> DateTime.to_iso8601()

    assert Statistics.account_age_in_days(yesterday) == {:ok, 1}
  end

  test "account_age_in_days calculates the difference of 1 year correctly" do
    yesterday =
      DateTime.utc_now()
      |> DateTime.add(-86400 * 365, :second)
      |> DateTime.to_iso8601()

    assert Statistics.account_age_in_days(yesterday) == {:ok, 365}
  end

  test "account_age_in_days returns error for invalid date" do
    assert Statistics.account_age_in_days("invalid_date") ==
             {:error, "Error parsing date: invalid_date, because: :invalid_format"}
  end

  test "account_age_in_days returns error for invalid date format" do
    assert Statistics.account_age_in_days("2020-01-01") ==
             {:error, "Error parsing date: 2020-01-01, because: :invalid_format"}
  end

  test "account_age_in_days returns error for invalid date format with time" do
    assert Statistics.account_age_in_days("2020-01-01T00:00:00") ==
             {:error, "Error parsing date: 2020-01-01T00:00:00, because: :missing_offset"}
  end

  test "average calculates the average correctly" do
    values = [1, 2, 3, 4, 5]
    assert Statistics.average(values) == 3.0
  end

  test "average calculates the average correctly for empty list" do
    values = []
    assert Statistics.average(values) == nil
  end

  test "average calculates the average correctly for single element" do
    values = [5]
    assert Statistics.average(values) == 5.0
  end

  test "median calculates the median correctly for odd number of elements" do
    values = [1, 3, 5]
    assert Statistics.median(values) == 3
  end

  test "median calculates the median correctly for single element" do
    values = [5]
    assert Statistics.median(values) == 5
  end

  test "median calculates the median correctly for even number of elements" do
    values = [1, 3, 5, 7]
    assert Statistics.median(values) == 4
  end

  test "median calculates the median correctly for empty list" do
    values = []
    assert Statistics.median(values) == nil
  end

  test "standard_deviation calculates correctly" do
    values = [1, 2, 3, 4, 5]
    assert Statistics.standard_deviation(values) == 1.4142135623730951
  end

  test "standard_deviation calculates correctly for empty list" do
    values = []
    assert Statistics.standard_deviation(values) == nil
  end

  test "max returns the maximum value correctly" do
    values = [1, 2, 3, 4, 5]
    assert Statistics.max(values) == 5
  end

  test "max returns 0 for empty list" do
    values = []
    assert Statistics.max(values) == nil
  end

  test "min returns the minimum value correctly" do
    values = [1, 2, 3, 4, 5]
    assert Statistics.min(values) == 1
  end

  test "min returns 0 for empty list" do
    values = []
    assert Statistics.min(values) == nil
  end

  test "read invalid json file" do
    # Simulando um arquivo que não existe
    assert Statistics.read_json("file") == {:error, "Error reading or decoding the file: :enoent"}
  end

  test "read valid json file" do
    filename = "./test.json"

    fake_data = [
      %{
        "followers_count" => 100,
        "following_count" => 50,
        "created_at" => "2020-01-01T00:00:00Z"
      },
      %{
        "followers_count" => 200,
        "following_count" => 100,
        "created_at" => "2021-01-01T00:00:00Z"
      }
    ]

    json_data = JSON.encode!(fake_data)

    File.write!(filename, json_data)

    assert Statistics.read_json(filename) == {:ok, fake_data}

    File.rm!(filename)
  end

  test "location_frequencies returns the correct frequencies" do
    values = [
      %{"location" => "New York"},
      %{"location" => "Los Angeles"},
      %{"location" => "New York"},
      %{"location" => "Chicago"},
      %{"location" => "Los Angeles"}
    ]

    expected = [
      # Sort by frequency (descending) and then by location (ascending)
      {"los angeles", 2},
      {"new york", 2},
      {"chicago", 1}
    ]

    assert Statistics.location_frequencies(values) == expected
  end

  test "location_frequencies returns empty list for empty input" do
    values = []
    assert Statistics.location_frequencies(values) == []
  end
end
