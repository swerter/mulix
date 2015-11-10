defmodule Mulix do
  @moduledoc """
  Module for working with [mu](https://github.com/djcb/mu) in elixir.
  """

  @doc """
  Initialize and create the mu database for a directory.
  """
  def mu_init(emails_path, db_path) do
    command = "/usr/bin/mu"
    args = ["index", "--muhome=#{db_path}", "--maildir=#{emails_path}"]
    {res, 0} = System.cmd command, args
  end

  @doc """
  Search for an email. Creates the linkdir_path maildir directory,
  where the links to the found emails are stored. This is a normal
  maildir directory.
  """
  def find(db_path, linkdir_path, query \\ "") do
    command = "/usr/bin/mu"
    args = ["find", "--muhome=#{db_path}", "--clearlinks", "--format=links", "--linksdir=#{linkdir_path}", clean_query(query)]
    case System.cmd(command, args) do
      {res, 0} -> :ok # all good, we found search query
      {res, 2} -> :ok # nothing found
      {res, 4} -> :ok # nothing found
    end
  end


  defp clean_query(query) do
    query |> String.replace("exec", "")
  end


  @doc """
  Fetch all email addresses
  """
  def contacts(db_path) do
    IO.puts db_path
    command = "/usr/bin/mu"
    args = ["cfind", "--format=mutt-ab", "--muhome=#{db_path}"]
    IO.puts "#{command} #{Enum.join(args, " ")}"
    {res, _} = System.cmd command, args
    res
    |> String.strip
    |> String.split("\n")
    |> Enum.drop(1)
    |> Enum.map(fn(x) ->
      parts = String.split(x, "\t")
      IO.inspect(parts)
      %{name: Enum.at(parts, 1), email: Enum.at(parts, 0)}
    end)
  end
end
