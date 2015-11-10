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
    IO.puts "#{command} #{Enum.join(args, " ")}"
    {res, 0} = System.cmd command, args
    IO.inspect res
  end

  @doc """
  Search for an email. Creates the linkdir_path maildir directory,
  where the links to the found emails are stored. This is a normal
  maildir directory.
  """
  def find(db_path, linkdir_path, query \\ "") do
    command = "/usr/bin/mu"
    args = ["find", "--muhome=#{db_path}", "--clearlinks", "--format=links", "--linksdir=#{linkdir_path}", clean_query(query)]
    IO.puts "#{command} #{Enum.join(args, " ")}"
    case System.cmd(command, args) do
      {res, 0} -> :ok # all good, we found search query
      {res, 2} -> :ok # nothing found
      {res, 4} -> :ok # nothing found
    end
  end


  @doc """
  Cleans the query so that no harm can be done.
  """
  defp clean_query(query) do
    query |> String.replace("exec", "")
  end
end
