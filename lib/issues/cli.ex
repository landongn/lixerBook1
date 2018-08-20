defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Responsible for comman dline parsing and the dispatch to
  the rest of the library, returning either a table
  of recent issues from github or the last n issues of a project
  """
  def run(argv) do
    argv
    |> parse_args
    |> process

  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise, it is a github username, project name, and optionally
  the number of entries to display.

  return a tuple of `{ user, project, count }`, or `:help` if help
  was asked for.
  """
  def parse_args(argv) do
    OptionParser.parse(
      argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> ingest_arguments()

  end

  def ingest_arguments([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def ingest_arguments([user, project]) do
    {user, project, @default_count}
  end

  def ingest_arguments(_) do
    :help
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  def process([user, project, _count]) do
    Issues.GithubIssues.fetch(user, project)
  end

end
