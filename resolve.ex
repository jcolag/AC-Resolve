defmodule Resolve do
# NB: run :random.seed(:os.timestamp) before using
  def one_die(sides \\ 10) do
    round(:random.uniform * sides + 0.5)
  end

  def dice(recurse \\ -1) do
    left = one_die()
    right = one_die()
    doubles = 0
    if recurse != 0 and left == right do
      doubles = dice(recurse - 1)
    end
    left + right + doubles
  end

  def action(aim, force, evade, defend) do
    t = target(aim, evade, true)
    if t do
      damage(force, defend, t)
    else
      0
    end
  end

  def action(aim, force, evade, defend, outcomes) do
    points = action(aim, force, evade, defend)
    cond do
      points <= 0 -> outcomes.none
      points < defend / 2 -> outcomes.minor
      points < defend -> outcomes.half
      true -> outcomes.full
    end 
  end

  def target(aim, evade, want \\ false) do
    t = aim + dice - evade + 11
    cond do
      !want -> t > 0
      t >= 0 -> round(:math.sqrt(t) - 0.5)
      true -> nil
    end
  end

  def damage(force, defend, critical \\ 0) do
    if defend > force do
      0
    else
      force + critical - defend
    end
  end
end

