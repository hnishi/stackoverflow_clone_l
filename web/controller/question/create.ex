use Croma

#　使用予定
defmodule StackoverflowCloneL.Controller.Question.CreateRequesrtBody do
  alias StackoverflowCloneL.Controller.Question.Helper.Params

  use Croma.Struct, fields: [
    title:  Params.Title,
    body: Params.Body,
  ]
end

defmodule StackoverflowCloneL.Controller.Question.Create do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  #alias StackoverflowCloneL.Controller.Question.{Helper, CreateRequestBody}
  alias StackoverflowCloneL.Controller.Question.Helper

  plug StackoverflowCloneL.Plug.FetchMe, :fetch, []

  def create(conn) do
    #IO.inspect conn
    # Implement me
    in_param = conn.request.body
    Conn.json(conn, 200, %{"TITLE" => in_param["title"],"BODY" => in_param["body"]})

    # 1. Requestの構築
    data = %{"title" => in_param["title"], "body" => in_param["body"]}
    req_body = %Dodai.CreateDedicatedDataEntityRequestBody{data: data}
    req = Dodai.CreateDedicatedDataEntityRequest.new(SD.default_group_id(),"Question","rkey_0ywy9jSuXktTvzF",req_body)

    # 2. G2G通信を実行する
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    #IO.inspect res

    # 3. レスポンスをハンドリングする
    %Dodai.CreateDedicatedDataEntitySuccess{body: res_body} = res
    Conn.json(conn, 200, Helper.to_response_body2(res_body))
    #res_body = %{
    #  title:  res.body["data"]["title"],
    #  body:  res.body["data"]["body"],
    #}
    #Conn.json(conn, 200, res_body)
  end
end
