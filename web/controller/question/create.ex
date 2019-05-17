use Croma

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

  plug StackoverflowCloneL.Plug.FetchMe, :fetch, []

  def create(%Conn{request: %Request{body: body}, context: context} = conn) do
    #IO.inspect conn
    # Implement me
    case CreateRequestBody.new(body) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn,BadRequestError.new())
      {:ok, validated} ->
        #IO.inspect validated
        in_param = conn.request.body
        #IO.inspect in_param
        #%StackoverflowCloneL.Controller.Question.CreateRequestBody%{title : title}=validated
        #IO.inspect title
        Conn.json(conn, 200, %{"TITLE" => in_param["title"],"BODY" => in_param["body"]})

        # 1. Requestの構築
        in_param = Map.from_struct(validated)
        #IO.inspect in_param
        data = %{
          "comments"        => [],
          "like_voter_ids"    => [],
          "dislike_voter_ids" => [],
          "title"           => in_param[:title],
          "body"            => in_param[:body],
          "user_id"         => conn.assigns.me["_id"],
        }
        #IO.inspect data
        req_body = %Dodai.CreateDedicatedDataEntityRequestBody{data: data}
        req = Dodai.CreateDedicatedDataEntityRequest.new(SD.default_group_id(),"Question",SD.root_key(),req_body)

        # 2. G2G通信を実行する
        res = Sazabi.G2gClient.send(context, SD.app_id(), req)
        #IO.inspect res

        # 3. レスポンスをハンドリングする
        %Dodai.CreateDedicatedDataEntitySuccess{body: res_body} = res
        Conn.json(conn, 200, Helper.to_response_body2(res_body))
   end
  end
end
