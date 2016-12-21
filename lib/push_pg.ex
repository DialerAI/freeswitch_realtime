defmodule PusherPG do
  use GenServer
  require Logger

  alias Ecto.Adapters.SQL
  alias FreeswitchRealtime.Repo
  alias FreeswitchRealtime.CampaignRT

  @moduledoc """
  GenServer Module to push Channels info to PostgreSQL.
  """

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Update Campaign Channels information

  ## Examples

      iex> PusherPG.raw_update_campaign_rt([count: 3, campaign_id: 1, leg_type: 1])
      :ok
  """
  def raw_update_campaign_rt(channel_info) do
    Logger.debug "Raw update Campaign RT..."
    querystring = case channel_info[:leg_type] do
        1 ->
          "UPDATE dialer_campaign_rtinfo SET current_channels_aleg=$1, updated_date=NOW() WHERE campaign_id=$2"
        2 ->
          "UPDATE dialer_campaign_rtinfo SET current_channels_bleg=$1, updated_date=NOW() WHERE campaign_id=$2"
      end
    result = SQL.query(Repo, querystring , [channel_info[:count], channel_info[:campaign_id]])
  end

  @doc """
  Update Campaign Channels information

  ## Examples

      iex> PusherPG.update_campaign_rt({:ok, [[count: 3, campaign_id: 1, leg_type: 1], [count: 3, campaign_id: 2, leg_type: 1]]})
      :ok
  """
  def update_campaign_rt(result) do
    case result do
      {:ok, aggr_channel} ->
        # res = reduce_channels_map(aggr_channel)
        Enum.map(aggr_channel, &raw_update_campaign_rt/1)
    end
  end

  @doc """
  Reduce Campaign Channels information

  !!! Not used at the moment - Not working...

  ## Examples

      iex> PusherPG.reduce_channels_map([[count: 3, campaign_id: 1, leg_type: 1], [count: 2, campaign_id: 2, leg_type: 1], [count: 1, campaign_id: 2, leg_type: 2]])
      %{1 => [total_count: 3, aleg_count: 3, aleg_count: 3],
        2 => [total_count: 2, aleg_count: 3, bleg_count: 1]}

  """
  def reduce_channels_map(channels) do
    # IO.inspect channels
    reduce_channels = %{}
    reduce_channels = Enum.map(channels, fn x -> x[:campaign_id] end) |> Enum.uniq |> Enum.reduce(%{}, fn(x, acc) -> Map.merge(acc, %{x => [total_count: 0, aleg_count: 0, bleg_count: 0]}) end)
    for val <- channels do
      # Map.fetch(reduce_channels, val[:campaign_id])//
      IO.inspect reduce_channels[val[:campaign_id]]
      total_count = case reduce_channels[val[:campaign_id]][:total_count] do
        nil -> 0
        x -> x
      end
      total_count = total_count + val[:count]

      aleg_count = case reduce_channels[val[:campaign_id]][:aleg_count] do
        nil -> 0
        x -> x
      end
      bleg_count = case reduce_channels[val[:campaign_id]][:bleg_count] do
        nil -> 0
        x -> x
      end

      # /// Something not working...
      IO.puts "==#{total_count}"
      IO.inspect reduce_channels[val[:campaign_id]]
      [aleg_count, bleg_count] = case val[:leg_type] do
        1 -> [aleg_count + val[:count], bleg_count]
        2 -> [aleg_count, bleg_count + val[:count]]
      end
      IO.inspect "aleg_count:#{aleg_count} - bleg_count:#{bleg_count}"
      IO.inspect [total_count: total_count, aleg_count: aleg_count, bleg_count: bleg_count]
      reduce_channels = Map.put(reduce_channels, val[:campaign_id], [total_count: total_count, aleg_count: aleg_count, bleg_count: bleg_count])
    end
    reduce_channels
  end

  @doc """
  Async update CampaignRT Info (channels)
  """
  def update_campaign_rt(result) do
    GenServer.cast(__MODULE__, {:update_campaign_rt, result})
  end

  def handle_cast({:update_campaign_rt, result}, state) do
    {:ok, _} = update_campaign_rt(result)
    {:noreply, state}
  end

end