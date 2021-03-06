defmodule HeyCake.Config do
  @moduledoc """
  Load configuration for the application
  """

  alias HeyCake.Config.Cache
  alias Vapor.Provider.Dotenv
  alias Vapor.Provider.Env

  defdelegate slack_app_id(), to: Cache

  defdelegate slack_client_id(), to: Cache

  defdelegate slack_signing_id(), to: Cache

  @doc """
  Load and parse application configuration
  """
  def application() do
    Vapor.load!(application_providers())
  end

  defp application_providers() do
    [
      %Dotenv{},
      %Env{
        bindings: [
          {:slack_app_id, "SLACK_APP_ID"},
          {:slack_client_id, "SLACK_CLIENT_ID"},
          {:slack_client_secret, "SLACK_CLIENT_SECRET"},
          {:slack_signing_id, "SLACK_SIGNING_ID"}
        ]
      }
    ]
  end

  @doc """
  Load and parse database configuration
  """
  def database() do
    Vapor.load!(database_providers())
  end

  defp database_providers() do
    [
      %Dotenv{},
      %Env{
        bindings: [
          {:database_url, "DATABASE_URL"},
          {:pool_size, "POOL_SIZE", map: &String.to_integer/1}
        ]
      }
    ]
  end

  @doc """
  Load and parse endpoint configuration
  """
  def endpoint() do
    Vapor.load!(endpoint_providers())
  end

  defp endpoint_providers() do
    [
      %Dotenv{},
      %Env{
        bindings: [
          {:http_port, "PORT", map: &String.to_integer/1},
          {:secret_key_base, "SECRET_KEY_BASE"},
          {:url_host, "HOST"},
          {:url_port, "URL_PORT", map: &String.to_integer/1},
          {:url_scheme, "URL_SCHEME"}
        ]
      }
    ]
  end
end

defmodule HeyCake.Config.Cache do
  @moduledoc """
  Create persistent terms for application configuration
  """

  use GenServer

  alias HeyCake.Config

  def slack_app_id(), do: :persistent_term.get({__MODULE__, :slack_app_id})

  def slack_client_id(), do: :persistent_term.get({__MODULE__, :slack_client_id})

  def slack_signing_id(), do: :persistent_term.get({__MODULE__, :slack_signing_id})

  @doc false
  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  @impl true
  def init(_) do
    {:ok, %{}, {:continue, :set}}
  end

  @impl true
  def handle_continue(:set, state) do
    Enum.each(Config.application(), fn {key, value} ->
      :persistent_term.put({__MODULE__, key}, value)
    end)

    {:noreply, state}
  end
end
