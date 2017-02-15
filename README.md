# Elixir Sudoku

An exploration into complex logic and recursion using Elixir.


***

## Usage

```elixir
iex> Sudoku.solve("0,0,0,0,9,7,0,0,6,...,9,0,0,6,4,0,0,0,0")
"1,8,4,3,9,7,2,5,6,...,9,3,1,6,4,2,7,8,5"
```

## Solving Methodology

1. Start

2. Is board valid?
   - **Yes** Continue to next step
   - **No** Is the solving history empty?
      - **Yes** The board is invalid
      - **No** Go to step 6

3. Get coordinates of the next empty cell on the board. Does one exist?
   - **Yes** Continue to next step
   - **No** Congratulations! You have solved the puzzle! :tada:

4. Get all legal values for this cell. Do any exist?
   - **Yes** Continue to next step
   - **No** Go to step 6

5. Get the next legal value for this cell. Does one exist?
   - **Yes** Set the value of the cell to this value and go to step 1
   - **No** Go to step 3

6. Clear the value of this cell and remove it from the history. Go to step 5.


## TODO

* Make concurrent


***


<small>Copyright (c) 2017 [Nathan Buchar](mailto:hello@nathanbuchar.com). All Rights Reserved.</small>
