defmodule Sudoku do
  @moduledoc """
  A module that solves Sudoku puzzles of any size.
  """

  alias Sudoku.Solver

  @doc """
  Solves the Sudoku puzzle given its string representation.

  ## Parameters

    - `puzzle`: The string representation of the Sudoku puzzle.

  ## Examples

      iex(1)> puzzle = "0,0,0,0,9,7,0,0,6,...,9,0,0,6,4,0,0,0,0"
      iex(2)> Sudoku.solve(puzzle)
      "1,8,4,3,9,7,2,5,6,...,9,3,1,6,4,2,7,8,5"

  """
  def solve(puzzle) do
    puzzle |> Solver.solve
  end
end
