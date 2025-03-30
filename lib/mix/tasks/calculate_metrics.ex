defmodule Mix.Tasks.CalculateMetrics do
  use Mix.Task

  def run(args) do
    case args do
      [file] ->
        case Statistics.read_json(file) do
          {:error, reason} ->
            IO.puts("Error reading file: #{inspect(reason)}")
            System.halt(1)

          {:ok, users_data} ->
            if Enum.empty?(users_data) do
              IO.puts("No users_data found in the file.")
              System.halt(1)
            end

            followers = Enum.map(users_data, fn user -> user["followers_count"] end)
            followings = Enum.map(users_data, fn user -> user["following_count"] end)

            account_ages =
              users_data
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

            metrics = [
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

            csv_data =
              ["Metric, min, max, avg, median, std\n"] ++
                Enum.map(metrics, fn {name, min, max, avg, median, stddev} ->
                  "#{name}, #{min}, #{max}, #{avg}, #{median}, #{stddev}\n"
                end)

            IO.puts(csv_data)
        end

      _ ->
        IO.puts("Uso: mix calculate_metrics <arquivo.json>")
    end
  end
end
