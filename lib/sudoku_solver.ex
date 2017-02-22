defmodule Sudoku.Solver do
  @moduledoc """
  A module that solves Sudoku puzzles.
  """

  alias Sudoku.Board

  @doc """
  Attempts to solve the given Sudoku puzzle and if
  successful will return the string representation of the
  solved puzzle as read from left ro right, top to bottom.

  ## Parameters

    - `str`: The string representation of the Sudoku puzzle.

  ## Examples

      iex(1)> str = "0,0,0,0,9,7,0,0,6,...,9,0,0,6,4,0,0,0,0"
      iex(2)> Sudoku.Solver.solve(str)
      "1,8,4,3,9,7,2,5,6,...,9,3,1,6,4,2,7,8,5"

  """
  def solve(str) do
    board = Board.new(str)

    case do_solve(board) do
      {:solved, board} ->
        Board.get_str_from_board(board)
      {:err, message} ->
        {:err, message}
    end
  end

  @doc """
  Begins the attempt to solve the Sudoku puzzle by first
  ensuring that the board is valid. If the board is invalid
  and contains no history, that is an indicator that the
  board the user entered is invalid. Otherwise, the current
  attempted solution is invalid and should be backtraced.

  ## Parameters

    - `board`: The Sudoku Board.
    - `history`: The solve attempt history.

  """
  def do_solve(board, history \\ []) do
    unless Board.valid?(board) do
      if Enum.empty?(history) do
        {:err, :invalid_board}
      else
        board
        |> backtrace(history)
      end
    else
      board
      |> solve_next(history)
    end
  end

  @doc """
  Gets the coordinates of the next empty cell on the board
  and attempts to solve it. If there are no remaining empty
  cells, then congratulations! The puzzle is solved.

  ## Parameters

    - `board`: The Sudoku Board.
    - `history`: The solve attempt history.

  """
  def solve_next(board, history) do
    case Board.get_next_empty_cell(board) do
      {:no_empty} ->
        {:solved, board}
      {:ok, coords} ->
        board
        |> solve_cell_for_all_values([{coords, []}] ++ history)
    end
  end

  @doc """
  Gets all legal values for the current cell and attempts
  to solve the puzzle using each value recursively. If no
  legal values exist, then we must backtrace.

  ## Parameters

    - `board`: The Sudoku Board.
    - `history`: The solve attempt history.

  """
  def solve_cell_for_all_values(board, [{coords, _} | tail] = history) do
    case Board.get_legal_values(board, coords) do
      [] ->
        # No legal values exist.
        board
        |> backtrace(history)
      candidates ->
        # Try these values.
        board
        |> solve_for_next_legal_value([{coords, candidates}] ++ tail)
    end
  end

  @doc """
  Attempts to solve the puzzle using the next legal value
  stored in history. If no more legal values exist, then
  we must backtrace.

  ## Parameters

    - `board`: The Sudoku Board.
    - `history`: The solve attempt history.

  """
  def solve_for_next_legal_value(board, history) do
    case history do
      [{coords, [candidate | candidates]} | tail] ->
        # Try the next legal value.
        board
        |> Board.set_cell(coords, candidate)
        |> do_solve([{coords, candidates}] ++ tail)
      [{_coords, []} | _tail] ->
        # No more legal values remain.
        board
        |> backtrace(history)
    end
  end

  @doc """
  Clears the current cell and backtraces up the call tree.

  ## Parameters

    - `board`: The Sudoku Board.
    - `history`: The solve attempt history.

  """
  def backtrace(board, [{coords, _} | tail]) do
    board
    |> Board.clear_cell(coords)
    |> solve_for_next_legal_value(tail)
  end
end
