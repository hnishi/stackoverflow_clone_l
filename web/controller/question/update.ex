defmodule StackoverflowCloneL.Controller.Question.Update do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Controller.Question.{Helper, CreateRequestBody}
  alias StackoverflowCloneL.Error.BadRequestError

  plug StackoverflowCloneL.Plug.FetchMe, :fetch, []

  def update(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: my_id}}} = conn) do
    # Implement me
    #IO.inspect conn
    in_param = conn.request.body

    #IO.inspect "1"
    case CreateRequestBody.new(conn.request.body) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn,BadRequestError.new())
      {:ok, validated} ->
        # 1. Requestの構築
        in_param = Map.from_struct(validated)
        data = %{
          "comments"        => [],
          "like_voter_ids"    => [],
          "dislike_voter_ids" => [],
          "title"           => in_param[:title],
          "body"            => in_param[:body],
          "user_id"         => conn.assigns.me["_id"],
        }
        Dodai.UpdateDedicatedDataEntityRequestBody
        req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: data}
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
