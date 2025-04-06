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

            metrics = Statistics.generate_metrics(users_data)

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
