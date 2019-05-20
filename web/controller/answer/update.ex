use Croma

defmodule StackoverflowCloneL.Controller.Answer.UpdateRequestBody do
  alias StackoverflowCloneL.Controller.Answer.Helper.Params

  use Croma.Struct, fields: [
    body: Params.Body,
  ]
end

defmodule StackoverflowCloneL.Controller.Answer.Update do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Controller.Answer.{Helper, UpdateRequestBody}
  #alias StackoverflowCloneL.Controller.Answer.UpdateRequestBody
  alias StackoverflowCloneL.Error.BadRequestError

  plug StackoverflowCloneL.Plug.FetchMe, :fetch, []

  def update(conn) do
    # Implement me
    #IO.inspect conn
    case UpdateRequestBody.new(conn.request.body) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn,BadRequestError.new())
      {:ok, validated} ->
       # IO.inspect validated

        # answerのuser_idとログインユーザの_idが一致するか確認する
        with_answer(conn, fn answer ->
          id = conn.assigns.me["_id"]
          case answer["data"]["user_id"] do
            ^id ->
              ## 一致した場合
              # 1. Requestの構築
              req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => Enum.reject(Map.from_struct(validated), fn {_k, v} -> is_nil(v) end) |> Map.new()}}
              req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(),"Answer", conn.request.path_matches[:id],SD.root_key(),req_body)
              # 2. G2G通信を実行する
              res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
              # 3. レスポンスをハンドリングする
              %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = res
              Conn.json(conn, 200, Helper.to_response_body2(res_body))
            _ ->
              ## 一致しない場合
              ErrorJson.json_by_error(conn, StackoverflowCloneL.Error.CredentialError.new())
          end
        end)
    end
  end

  def with_answer(%Conn{request: %Request{path_matches: %{id: id}}} = conn, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), "Answer", id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, StackoverflowCloneL.Error.ResourceNotFoundError.new())
    end
  end
end
