defmodule StackoverflowCloneL.Controller.Question.Update do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Controller.Question.Helper

  plug StackoverflowCloneL.Plug.FetchMe, :fetch, []

  def update(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: my_id}}} = conn) do
    # Implement me
    in_param = conn.request.body
    #IO.inspect(conn)
    #IO.inspect(my_id)
    IO.inspect "1"

    # 1. Requestの構築
    #data = %{"title" => in_param["title"], "body" => in_param["body"]}
    data = %{"title" => in_param["title"]}

    IO.inspect "2"
    Dodai.UpdateDedicatedDataEntityRequestBody
    req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: data}
    req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(),"Question", my_id,SD.root_key(),req_body)
    IO.inspect "3"
    # 2. G2G通信を実行する
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    IO.inspect "4"
    IO.inspect res

    # 3. レスポンスをハンドリングする
    %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = res
    Conn.json(conn, 200, Helper.to_response_body2(res_body))
    #Conn.json(conn, 200, %{a: 1})
  end
end
