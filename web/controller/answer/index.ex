use Croma

defmodule StackoverflowCloneL.Controller.Answer.IndexRequestParams do
  use Croma.Struct, fields: [
    user_id:  Croma.TypeGen.nilable(Croma.String),
    question_id: Croma.TypeGen.nilable(Croma.String),
  ]
end

defmodule StackoverflowCloneL.Controller.Answer.Index do
  use StackoverflowCloneL.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Controller.Answer.{Helper, IndexRequestParams}
  alias StackoverflowCloneL.Error.BadRequestError

  def index(%Conn{request: %Request{query_params: query_params}, context: context} = conn) do
    # Implement me
    case IndexRequestParams.new(query_params) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn,BadRequestError.new())
      {:ok, validated} ->
        query = convert_to_dodai_req_query(validated)
        req = Dodai.RetrieveDedicatedDataEntityListRequest.new(SD.default_group_id(), Helper.collection_name(), SD.root_key(), query)
        %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = G2gClient.send(context, SD.app_id(), req)
        Conn.json(conn, 200, Enum.map(docs, &Helper.to_response_body(&1)))
    end
  end
  defunpt convert_to_dodai_req_query(params :: v[IndexRequestParams.t]) :: Dodai.RetrieveDedicatedDataEntityListRequestQuery.t do
    query = Map.from_struct(params)
    |> Enum.reject(fn {_, value} -> is_nil(value) end)
    |> Enum.map(fn {k, v} -> {"data.#{k}", v} end)
    |> Map.new()

    %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
      query: query,
      sort:  %{"_id" => 1}
    }
  end
end
