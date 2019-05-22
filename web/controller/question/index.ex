use Croma

defmodule StackoverflowCloneL.Controller.Question.IndexRequestParams do
  use Croma.Struct, fields: [
    user_id:  Croma.TypeGen.nilable(Croma.String),
    limit: Croma.TypeGen.nilable(Croma.NonNegInteger),
    skip: Croma.TypeGen.nilable(Croma.NonNegInteger),
  ]
end

defmodule StackoverflowCloneL.Controller.Question.Index do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Error.BadRequestError
  alias StackoverflowCloneL.Controller.Question.{Helper, IndexRequestParams}

  def index(conn) do
    #IO.inspect conn.request.query_params, label: "start"
    queries = conn.request.query_params
    queries = Enum.map( queries, fn {key, value} ->
      {key,
        case key do
        "limit" -> String.to_integer(value)
        "skip" -> String.to_integer(value)
        _ -> value
        end} end)
    #IO.inspect queries, label: "queries"
    #case IndexRequestParams.new(conn.request.query_params) do
    case IndexRequestParams.new(queries) do
        {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequestError.new())
      {:ok, validated} ->
        #IO.inspect validated
        query = convert_to_dodai_req_query(validated)
        #IO.inspect query
        req = Dodai.RetrieveDedicatedDataEntityListRequest.new(SD.default_group_id(), Helper.collection_name(), SD.root_key(), query)
        %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
        Conn.json(conn, 200, Enum.map(docs, &Helper.to_response_body(&1)))
    end
  end

  defunpt convert_to_dodai_req_query(params :: v[IndexRequestParams.t]) :: Dodai.RetrieveDedicatedDataEntityListRequestQuery.t do
    #IO.inspect params, label: "conv!!!"
    query = Map.from_struct(params)
    |> Enum.reject(fn {_, value} -> is_nil(value) end)
    |> Enum.map(fn {k, v} -> {"data.#{k}", v} end)
    |> Enum.reject(fn {key, _} -> "data.limit" == key end)
    |> Enum.reject(fn {key, _} -> "data.skip" == key end)
    |> Map.new()
    #IO.inspect query, label: "query"

    params = Map.from_struct(params)
    #IO.inspect params #["limit"], label: "limit!!!"
    %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
      query: query,
      sort:  %{"_id" => 1},
      #limit: 3,
      limit: params[:limit],
      skip: params[:skip],
    }
  end
end
