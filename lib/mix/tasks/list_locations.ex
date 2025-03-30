defmodule Mix.Tasks.ListLocations do
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

            locations = Statistics.location_frequencies(users_data)

            csv_data =
              ["Location, Frequency\n"] ++
                Enum.map(locations, fn {location, frequency} ->
                  "#{location}, #{frequency}\n"
                end)

            IO.puts(csv_data)
        end

      _ ->
        IO.puts("Uso: mix list_locations <arquivo.json>")
    end
  end
end
