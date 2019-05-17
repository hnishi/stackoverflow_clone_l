use Croma

defmodule StackoverflowCloneL.Controller.Question.UpdateRequestBody do
  alias StackoverflowCloneL.Controller.Question.Helper.Params

  use Croma.Struct, fields: [
    title:  Params.Title,
  ]
end

defmodule StackoverflowCloneL.Controller.Question.Update do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Controller.Question.{Helper, UpdateRequestBody}
  alias StackoverflowCloneL.Error.BadRequestError

  plug StackoverflowCloneL.Plug.FetchMe, :fetch, []

  def update(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: my_id}}} = conn) do
    # Implement me
    #IO.inspect conn
    #IO.inspect "1"
    case UpdateRequestBody.new(conn.request.body) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn,BadRequestError.new())
      {:ok, validated} ->
        # 1. Requestの構築
        Dodai.UpdateDedicatedDataEntityRequestBody
        req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => Map.from_struct(validated)}}
        req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(),"Question", my_id,SD.root_key(),req_body)

        # 2. G2G通信を実行する
        res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)

        # 3. レスポンスをハンドリングする
        %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = res
        Conn.json(conn, 200, Helper.to_response_body2(res_body))
        #Conn.json(conn, 200, %{a: 1})
    end
  end
end
