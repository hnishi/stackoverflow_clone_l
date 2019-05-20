use Croma

defmodule StackoverflowCloneL.Controller.Question.UpdateRequestBody do
  alias StackoverflowCloneL.Controller.Question.Helper.Params

  use Croma.Struct, fields: [
    title:  Croma.TypeGen.nilable(Params.Title),
    body:  Croma.TypeGen.nilable(Params.Body),
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
        #IO.inspect validated
        # questionのuser_idとログインユーザの_idが一致するか確認する
        with_question(conn, fn question ->
          #IO.inspect question
          #IO.inspect question["data"]["user_id"]
          #IO.inspect conn.assigns.me["_id"]
          id = conn.assigns.me["_id"]
          case question["data"]["user_id"] do
            ^id ->
              ## 一致した場合
              ## 更新処理をする(下記の処理を書いてみましょう)
              ### 1. dodaiに対してrequestするrequest bodyを作成する
              ### 2. dodaiに対してrequestするためのstructを作る
              ### 3. クライアントにレスポンスを返す(dodaiのresponse bodyがいつもと違うことに注意)
              # 1. Requestの構築
              #IO.inspect validated
              #IO.inspect Map.from_struct(validated)
              req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => Enum.reject(Map.from_struct(validated), fn {_k, v} -> is_nil(v) end) |> Map.new()}}
              req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(),"Question", my_id,SD.root_key(),req_body)

              # 2. G2G通信を実行する
              res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)

              # 3. レスポンスをハンドリングする
              %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = res
              Conn.json(conn, 200, Helper.to_response_body2(res_body))
            _ ->
              ## 一致しない場合、下記のようにエラーを返す
              ErrorJson.json_by_error(conn, StackoverflowCloneL.Error.CredentialError.new())
          end
        end)
    end
  end

  def with_question(%Conn{request: %Request{path_matches: %{id: id}}} = conn, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), "Question", id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, StackoverflowCloneL.Error.ResourceNotFoundError.new())
    end
  end
end
