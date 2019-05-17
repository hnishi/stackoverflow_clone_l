use Croma

#　使用予定
defmodule StackoverflowCloneL.Controller.Question.CreateRequestBody do
  alias StackoverflowCloneL.Controller.Question.Helper.Params

  use Croma.Struct, fields: [
    title:  Params.Title,
    body: Params.Body,
  ]
end

defmodule StackoverflowCloneL.Controller.Question.Create do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Controller.Question.{Helper, CreateRequestBody}
  alias StackoverflowCloneL.Error.BadRequestError

  def create(%Conn{request: %Request{body: body}, context: context} = conn) do
    #IO.inspect conn
    # Implement me
    case CreateRequestBody.new(body) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn,BadRequestError.new())
      {:ok, validated} ->
        in_param = conn.request.body
        Conn.json(conn, 200, %{"TITLE" => in_param["title"],"BODY" => in_param["body"]})

        # 1. Requestの構築
        req_body = %Dodai.CreateDedicatedDataEntityRequestBody{data: Map.from_struct(validated)}
        req = Dodai.CreateDedicatedDataEntityRequest.new(SD.default_group_id(),"Question","rkey_0ywy9jSuXktTvzF",req_body)

        # 2. G2G通信を実行する
        res = Sazabi.G2gClient.send(context, SD.app_id(), req)
        #IO.inspect res

        # 3. レスポンスをハンドリングする
        %Dodai.CreateDedicatedDataEntitySuccess{body: res_body} = res
        Conn.json(conn, 200, Helper.to_response_body2(res_body))
  end

  end
end
