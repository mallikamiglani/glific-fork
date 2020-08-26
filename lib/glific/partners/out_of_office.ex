defmodule Glific.Partners.OrganizationSettings.OutOfOffice do
  @moduledoc """
  The Glific abstraction to represent the organization settings of out of office
  """
  alias __MODULE__

  use Ecto.Schema
  import Ecto.Changeset

  alias Glific.Flows.Flow

  @optional_fields [
    :enabled,
    :start_time,
    :end_time,
    :flow_id,
    :enabled_days
  ]

  @type t() :: %__MODULE__{
          enabled: boolean | nil,
          start_time: :time | nil,
          end_time: :time | nil,
          enabled_days: map() | nil,
          flow_id: non_neg_integer | nil
        }

  @primary_key false
  embedded_schema do
    field :enabled, :boolean, default: false
    field :start_time, :time
    field :end_time, :time
    belongs_to :flow, Flow
    field :enabled_days, {:array, :map}
  end

  @doc """
  Standard changeset pattern for embedded schema
  """
  @spec out_of_office_changeset(OutOfOffice.t(), map()) :: Ecto.Changeset.t()
  def out_of_office_changeset(out_of_office, attrs) do
    out_of_office
    |> cast(attrs, @optional_fields)
    |> cast_enabled_days(attrs)
  end

  @spec cast_enabled_days(Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  defp cast_enabled_days(changeset, %{enabled_days: enabled_days}) do
    changeset
    |> put_change(:enabled_days, prepare_enabled_days_list(enabled_days))
  end

  defp cast_enabled_days(changeset, _), do: changeset

  @spec prepare_enabled_days_list(map()) :: map()
  defp prepare_enabled_days_list(enabled_days) do
    enabled_days_default_list = [
      %{enabled: false, id: 1},
      %{enabled: false, id: 2},
      %{enabled: false, id: 3},
      %{enabled: false, id: 4},
      %{enabled: false, id: 5},
      %{enabled: false, id: 6},
      %{enabled: false, id: 7}
    ]

    enabled_days
    |> Enum.reduce(enabled_days_default_list, fn x, acc ->
      acc
      |> Enum.map(fn y ->
        if y.id == x.id do
          %{enabled: x.enabled, id: x.id}
        else
          %{enabled: y.enabled, id: y.id}
        end
      end)
    end)
  end
end
