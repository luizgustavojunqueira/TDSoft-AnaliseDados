defmodule Statistics do
  def read_json(filename) do
    with {:ok, data} <- File.read(filename),
         {:ok, json} <- JSON.decode(data) do
      if is_list(json) do
        {:ok, json}
      else
        {:error, "Expected a list of users, got: #{inspect(json)}"}
      end
    else
      {:error, reason} ->
        {:error, "Error reading or decoding the file: #{inspect(reason)}"}
    end
  end

  def account_age_in_days(date) do
    with {:ok, parsed_date, _} <- DateTime.from_iso8601(date),
         diff <- DateTime.diff(DateTime.utc_now(), parsed_date, :second) do
      {:ok, diff / 86400}
    else
      {:error, reason} ->
        {:error, "Error parsing date: #{date}, because: #{inspect(reason)}"}
    end
  end

  def max([]), do: nil
  def max(values), do: Enum.max(values)

  def min([]), do: nil
  def min(values), do: Enum.min(values)

  def average([]), do: nil
  def average(values), do: Enum.sum(values) / length(values)

  def median([]), do: nil

  def median(values) do
    sorted_values = Enum.sort(values)
    count = length(sorted_values)

    if rem(count, 2) == 1 do
      Enum.at(sorted_values, div(count, 2))
    else
      middle1 = Enum.at(sorted_values, div(count, 2) - 1)
      middle2 = Enum.at(sorted_values, div(count, 2))
      (middle1 + middle2) / 2
    end
  end

  def standard_deviation([]), do: nil

  def standard_deviation(values) do
    mean = average(values)
    squared_diffs = Enum.map(values, fn x -> :math.pow(x - mean, 2) end)
    variance = Enum.sum(squared_diffs) / length(values)
    :math.sqrt(variance)
  end

  def location_frequencies([]), do: []

  def location_frequencies(values) do
    values
    |> Enum.map(fn v -> v["location"] end)
    |> Enum.filter(&(&1 != nil))
    |> Enum.map(&String.downcase/1)
    |> Enum.frequencies()
    |> Enum.sort_by(fn {location, freq} -> {-freq, location} end)
  end

  def generate_metrics(values) do
    followers = Enum.map(values, fn user -> user["followers_count"] end)
    followings = Enum.map(values, fn user -> user["following_count"] end)

    account_ages =
      values
      |> Enum.map(fn user ->
        case Statistics.account_age_in_days(user["created_at"]) do
          {:ok, age} ->
            age

          {:error, reason} ->
            IO.puts("Error calculating account age: #{inspect(reason)}")
            nil
        end
      end)
      |> Enum.filter(fn age -> is_number(age) end)

    [
      {"Followers", Statistics.min(followers), Statistics.max(followers),
       Statistics.average(followers), Statistics.median(followers),
       Statistics.standard_deviation(followers)},
      {"Following", Statistics.min(followings), Statistics.max(followings),
       Statistics.average(followings), Statistics.median(followings),
       Statistics.standard_deviation(followings)},
      {"Account Age", Statistics.min(account_ages), Statistics.max(account_ages),
       Statistics.average(account_ages), Statistics.median(account_ages),
       Statistics.standard_deviation(account_ages)}
    ]
  end
end
