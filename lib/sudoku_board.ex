defmodule Sudoku.Board do
  @moduledoc """
  A module containing functions which pertain to working
  with a Sudoku board.
  """

  alias :math, as: Math

  defstruct size: nil, rows: nil

  @doc """
  Returns a new Sudoku board strucy generated from the
  given string representation of the Sudoku puzzle.

  ## Parameters

    - `str`: The string representation of the Sudoku puzzle.

  ## Examples

      iex(1)> str = "0,0,0,0,9,7,0,0,6,...,9,0,0,6,4,0,0,0,0"
      iex(2)> Sudoku.Board.new(str)
      %Sudoku.Board{size: 9, rows: [[0, 0, 0, 0, 9, 7, 0, 0, 6], ..., [9, 0, 0, 6, 4, 0, 0, 0, 0]]}

  """
  def new(str) do
    get_board_from_str(str)
  end

  @doc """
  Returns a `%Sudoku.Board{}` struct containing the size of
  the puzzle and a two-dimensional list of all of its rows
  generated from the given string representation of the
  Sudoku puzzle.

  ## Parameters

    - `str`: The string representation of the Sudoku puzzle.

  ## Examples

      iex(1)> str = "0,0,0,0,9,7,0,0,6,...,9,0,0,6,4,0,0,0,0"
      iex(2)> Sudoku.Board.new(str)
      %Sudoku.Board{size: 9, rows: [[0, 0, 0, 0, 9, 7, 0, 0, 6], ..., [9, 0, 0, 6, 4, 0, 0, 0, 0]]}

  """
  def get_board_from_str(str) do
    size = get_size_from_str(str)
    rows = get_rows_from_str(str)

    %Sudoku.Board{
      size: size,
      rows: rows
    }
  end

  @doc """
  Transforms the `%Sudoku.Board{}` struct back into its
  respective string representation. Good for displaying the
  solved puzzle as a human-readble string.

  ## Parameters

    - `board`: The Sudoku board.

  ## Examples

      iex> Sudoku.Board.get_str_from_board(board)
      "1,8,4,3,9,7,2,5,6,...,9,3,1,6,4,2,7,8,5"

  """
  def get_str_from_board(board) do
    board
    |> get_rows
    |> List.flatten
    |> Enum.join(",")
  end

  @doc """
  Returns the size of the Sudoku board determined from its
  string representation.

  ## Parameters

    - `str`: The string representation of the Sudoku puzzle.

  ## Examples

      iex(1)> str = "0,0,0,0,9,7,0,0,6,...,9,0,0,6,4,0,0,0,0"
      iex(2)> Sudoku.Board.get_size_from_str(str)
      9

  """
  def get_size_from_str(str) do
    str
    |> String.split(",", trim: true)
    |> Enum.count
    |> Math.sqrt
    |> round
  end

  @doc """
  Returns a two-dimensional list of all rows that exist in
  the Sudoku puzzle given its string representation.

  ## Parameters

    - `str`: The string representation of the Sudoku puzzle.

  ## Examples

      iex(1)> str = "0,0,0,0,9,7,0,0,6,...,9,0,0,6,4,0,0,0,0"
      iex(2)> Sudoku.Board.get_rows_from_str(str)
      [[0, 0, 0, 0, 9, 7, 0, 0, 6], ..., [9, 0, 0, 6, 4, 0, 0, 0, 0]]

  """
  def get_rows_from_str(str) do
    size = get_size_from_str(str)

    str
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk(size)
  end

  @doc """
  Returns the size of the board.

  ## Parameters

    - `board`: The Sudoku board.

  ## Examples

      iex> Sudoku.Board.get_size(board)
      9

  """
  def get_size(board) do
    board.size
  end

  @doc """
  Gets the size of a square within the Sudoku board, given
  its size.

  ## Parameters

    - `board`: The Sudoku board.

  ## Examples

      iex> Sudoku.Board.get_square_size(9)
      3

  """
  def get_square_size(board) do
    board
    |> get_size
    |> Math.sqrt
    |> round
  end

  @doc """
  Returns a list of all values within the row at the given
  index.

  ## Parameters

    - `board`: The Sudoku board.
    - `y`: The index of the row to get.

  ## Examples

      iex> Sudoku.Board.get_row(board, 0)
      [0, 0, 0, 0, 9, 7, 0, 0, 6]

  """
  def get_row(board, y) do
    Enum.at(board, y)
  end

  @doc """
  Returns a list of all rows within the given board.

  ## Parameters

    - `board`: The Sudoku board.

  ## Examples

      iex> Sudoku.Board.get_rows(board)
      [[0, 0, 0, 0, 9, 7, 0, 0, 6], ...]

  """
  def get_rows(board) do
    board.rows
  end

  @doc """
  Returns a list of all values within the column at the
  given index.

  ## Parameters

    - `board`: The Sudoku board.
    - `x`: The index of the column.

  ## Examples

      iex> Sudoku.Board.get_col(board, 0)
      [0, 5, 3, 0, 0, 4, 0, 8, 9]

  """
  def get_col(board, x) do
    Enum.map get_rows(board), fn(row) ->
      Enum.at(row, x)
    end
  end

  @doc """
  Returns a list of all columns within the given board.

  ## Parameters

    - `board`: The Sudoku board.

  ## Examples

      iex> Sudoku.Board.get_cols(board)
      [[0, 5, 3, 0, 0, 4, 0, 8, 9], ...]

  """
  def get_cols(board) do
    for x <- 0..get_size(board) - 1 do
      get_col(board, x)
    end
  end

  @doc """
  Returns a list of all values within the square which
  contains the given coordinates.

  ## Parameters

    - `board`: The Sudoku board.
    - `coords`: The `{x, y}` coordinates of a cell that exists within the square we would like to get.

  ## Examples

      iex> Sudoku.Board.get_square(board, {0, 0})
      [0, 0, 0, 5, 0, 0, 3, 0, 0]

  """
  def get_square(board, {x, y}) do
    square_size = get_square_size(board)

    min_x = div(x, square_size) * square_size
    min_y = div(y, square_size) * square_size

    for y <- min_y..min_y + square_size - 1, x <- min_x..min_x + square_size - 1 do
      get_cell(board, {x, y})
    end
  end

  @doc """
  Returns a list of all squares within the given board.

  ## Parameters

    - `board`: The Sudoku board.

  ## Examples

      iex> Sudoku.Board.get_square(board)
      [[0, 0, 0, 5, 0, 0, 3, 0, 0], ...]

  """
  def get_squares(board) do
    square_size = get_square_size(board)

    for y <- 0..square_size - 1, x <- 0..square_size - 1 do
      x_coord = x * square_size
      y_coord = y * square_size

      get_square(board, {x_coord, y_coord})
    end
  end

  @doc """
  Returns the value of the cell at the given coordinates.

  ## Parameters

    - `board`: The Sudoku board.
    - `coords`: The `{x, y}` coordinates of the cell that we would like to get the value of.

  ## Examples

      iex> Sudoku.Board.get_cell(board, {0, 0})
      0

  """
  def get_cell(board, {x, y}) do
    board
    |> get_rows
    |> get_row(y)
    |> Enum.at(x)
  end

  @doc """
  Sets the value of the cell at the given coordinates.

  ## Parameters

    - `board`: The Sudoku board.
    - `coords`: The `{x, y}` coordinates of the cell that we would like to set the value of.
    - `val`: The value to set the cell at the given coordinates to.

  ## Examples

      iex(1)> coords = {0, 0}
      iex(2)> Sudoku.Board.set_cell(board, coords, 1)
      [[1, 0, 0, 5, 0, 0, 3, 0, 0], ...]

  """
  def set_cell(board, {x, y}, val) do
    rows = get_rows(board)

    new_row =
      rows
      |> get_row(y)
      |> List.replace_at(x, val)

    %Sudoku.Board{board | rows: List.replace_at(rows, y, new_row)}
  end

  @doc """
  Clears the value of the cell at the given coordinates.

  ## Parameters

    - `board`: The Sudoku board.
    - `coords`: The `{x, y}` coordinates of the cell that we would like to clear the value of.

  ## Examples

      iex(1)> coords = {0, 3}
      iex(2)> Sudoku.Board.clear_cell(board, coords)
      [[0, 0, 0, 0, 0, 0, 3, 0, 0], ...]

  """
  def clear_cell(board, coords) do
    board
    |> set_cell(coords, 0)
  end

  @doc """
  Returns the first row that contains an empty (`0`) value
  somewhere. If there are no empty rows, return `nil`.

  ## Parameters

    - `board`: The Sudoku board.

  ## Examples

      iex> Sudoku.Board.get_next_empty_row(board)
      0

  """
  def get_next_empty_row(board) do
    rows = get_rows(board)

    Enum.find_index rows, fn(row) ->
      Enum.any? row, fn(cell) ->
        empty?(cell)
      end
    end
  end

  @doc """
  Returns the the index of the first empty column at the
  within the row at the given index. If there are no empty
  columns, return `nil`.

  ## Parameters

    - `board`: The Sudoku board.
    - `row_index`: The index of the row.

  ## Examples

      iex> Sudoku.Board.get_first_empty_col(board, 0)
      0

  """
  def get_first_empty_col(board, row_index) do
    rows = get_rows(board)

    Enum.find_index rows |> get_row(row_index), fn(cell) ->
      empty?(cell)
    end
  end

  @doc """
  Returns the `{x, y}` coordinates of the next empty cell
  in the given board.

  ## Parameters

    - `board`: The Sudoku board.

  ## Examples

      iex> Sudoku.Board.get_next_empty_cell(board)
      {0, 0}

  """
  def get_next_empty_cell(board) do
    case get_next_empty_row(board) do
      nil ->
        {:no_empty}
      row_index ->
        {:ok, {get_first_empty_col(board, row_index), row_index}}
    end
  end

  @doc """
  Returns a list of all legal values for the given `{x, y}`
  coordinate.

  ## Parameters

    - `board`: The Sudoku board.
    - `coords`: The cell we wish to get all legal values for.

  ## Examples

      iex> Sudoku.Board.get_legal_values(board, {0, 0})
      [1, 2]

  """
  def get_legal_values(board, coords) do
    Enum.reduce 1..get_size(board), [], fn(val, acc) ->
      if set_cell(board, coords, val) |> valid? do
        acc ++ [val]
      else
        acc
      end
    end
  end

  @doc """
  Returns a list of all unempty cells within a given
  segment (row, column, square).

  ## Parameters

    - `segment`: A list of values to remove unempty cells from.

  ## Examples

      iex(1)> segment = [0, 1, 2, 0, 3, 6, 0, 0, 0]
      iex(2)> Sudoku.Board.get_unempty_cells(segment)
      [1, 2, 3, 6]

  """
  def get_unempty_cells(segment) do
    Enum.reject segment, fn(x) ->
      empty?(x)
    end
  end

  @doc """
  Returns a list of unique values from within a given
  segment (row, column, square).

  ## Parameters

    - `segment`: A list of values to remove unempty cells from.

  ## Examples

      iex(1)> segment = [1, 1, 2, 3, 6]
      iex(2)> Sudoku.Board.get_unique_cells(segment)
      [1, 2, 3, 6]

  """
  def get_unique_cells(segment) do
    segment |> Enum.uniq
  end

  @doc """
  Returns a boolean indicating if all values within the
  given segment (row, column, square) are valid, which is
  to say it does not contain values which repeat.

  ## Parameters

    - `segment`: A list of values to test for uniqueness.

  ## Examples

      iex(1)> segment = [0, 1, 2, 0, 3, 6, 0, 0, 0]
      iex(2)> Sudoku.Board.segment_valid?(segment)
      true

      iex(1)> segment = [1, 1, 2, 0, 3, 6, 0, 0, 0]
      iex(2)> Sudoku.Board.segment_valid?(segment)
      false

  """
  def segment_valid?(segment) do
    filtered_segment = get_unempty_cells(segment)
    unique_segment = get_unique_cells(filtered_segment)

    Enum.count(filtered_segment) === Enum.count(unique_segment)
  end

  @doc """
  Returns a boolean indicating if all segments (rows,
  columns, squares) are valid, which is to say none contain
  values which repeat.

  ## Parameters

    - `segments`: A list of segments to test for uniqueness.

  ## Examples

      iex(1)> segments = [[0, 1, 2, 0, 3, 6, 0, 0, 0], ...]
      iex(2)> Sudoku.Board.segments_valid?(segments)
      true

  """
  def segments_valid?(segments) do
    Enum.all? segments, fn(segment) ->
      segment_valid?(segment)
    end
  end

  @doc """
  Returns a boolean indicating if all rows within the given
  board are valid, which is to say none contain values
  which repeat.

  ## Parameters

    - `board`: The Sudoku board.

  ## Examples

      iex> Sudoku.Board.rows_valid?(board)
      true

  """
  def rows_valid?(board) do
    board
    |> get_rows
    |> segments_valid?
  end

  @doc """
  Returns a boolean indicating if all columns within the
  given board are valid, which is to say none contain
  values which repeat.

  ## Parameters

    - `board`: The Sudoku board.

  ## Examples

      iex> Sudoku.Board.cols_valid?(board)
      true

  """
  def cols_valid?(board) do
    board
    |> get_cols
    |> segments_valid?
  end

  @doc """
  Returns a boolean indicating if all squares within the
  given board are valid, which is to say none contain
  values which repeat.

  ## Parameters

    - `board`: The Sudoku board.

  ## Examples

      iex> Sudoku.Board.squares_valid?(board)
      true

  """
  def squares_valid?(board) do
    board
    |> get_squares
    |> segments_valid?
  end

  @doc """
  Returns a boolean indicating whether the given board is
  valid, which is to say all row, column, and square
  segments do not contain values which repeat.

  ## Parameters

    - `board`: The Sudoku board.

  ## Examples

      iex> Sudoku.Board.valid?(board)
      true

  """
  def valid?(board) do
    rows_valid?(board)
      and cols_valid?(board)
      and squares_valid?(board)
  end

  @doc """
  Returns a boolean indicating if the given value is empty,
  which is to say that it is equal to `0`.

  ## Parameters

    - `val`: The value to test.

  ## Examples

      iex> board |> get_cell({0, 0}) |> Sudoku.Board.empty?
      true

  """
  def empty?(val) do
    val === 0
  end
end
