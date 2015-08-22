defmodule Game1 do
  defp parse_int(name) do
    { i, _ } = :string.to_integer(to_char_list(name))
    i
  end

  defp update(profile, which, number) do
    {value, _} = :string.to_integer(to_char_list(number))
    orig = parse_int(Dict.fetch!(profile, which))
    orig + parse_int(value)
  end

  defp sum(who, hand) do
    Enum.reduce hand, who, fn card, acc ->
      left_tag = Enum.fetch!(card, 1)
      right_tag = Enum.fetch!(card, 3)
      left_value = update(acc, left_tag, Enum.fetch!(card, 2))
      right_value = update(acc, right_tag, Enum.fetch!(card, 4))
      x = Map.put(acc, left_tag, left_value)
      Map.put(x, right_tag, right_value)
    end
  end

  defp strike(attacker, defender) do
    Resolve.action(attacker["Aim"], attacker["Force"], defender["Evade"], defender["Defend"])
  end

  defp fight(first, _ = %{hp: hps}, _)
    when hps <= 0 do
    first.name
  end

  defp fight(first = %{"Aim": aim, "Force": force}, _, _)
    when aim <= 0 or force <= 0 do
    first.name
  end

  defp fight(_, _, 0) do
    "Draw"
  end

  defp fight(first, second = %{hp: hps}, rounds) do
    hps = hps - strike(first, second)
    second = Map.put(second, :hp, hps)
    fight(second, first, rounds - 1)
  end

  defp deal(_, []) do
    []
  end

  defp deal(empty, [head|tail]) do
    [first, second] = head
    fchar = sum(empty, first)
    fchar = Map.put_new(fchar, :hp, fchar["Defend"])
    fchar = Map.put_new(fchar, :name, "First")
    schar = sum(empty, second)
    schar = Map.put_new(schar, :hp, schar["Defend"])
    schar = Map.put_new(schar, :name, "Second")
    result = fight(fchar, schar, 30)
    history = deal(empty, tail)
    [result] ++ history
  end

  def go() do
    :random.seed(:os.timestamp)
    {:ok, body} = File.read "cards.csv"
    lines = String.split(body, "\n")
    lines = Enum.map(lines, fn(x) -> String.split(x, ",") end)
    lines = List.delete_at(lines, 0)
    lines = List.delete(lines, [""])
    lines = Enum.shuffle(lines)
    hands = Enum.chunk(Enum.chunk(lines, 3), 2)
    empty = %{"Aim" => 0, "Force" => 0, "Evade" => 0, "Defend" => 0}
    deal(empty, hands)
  end

end

