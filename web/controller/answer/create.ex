use Croma

defmodule StackoverflowCloneL.Controller.Answer.CreateRequestBody do
  alias StackoverflowCloneL.Controller.Answer.Helper.Params

  use Croma.Struct, fields: [
    body: Params.Body,
  ]
end


defmodule StackoverflowCloneL.Controller.Answer.Create do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Error.ResourceNotFoundError
  alias StackoverflowCloneL.Controller.Answer.{Helper, CreateRequestBody}
  alias StackoverflowCloneL.Error.BadRequestError


  plug StackoverflowCloneL.Plug.FetchMe, :fetch, []

  def create(%Conn{request: %Request{body: body}, context: context} = conn) do
    question_id = body["question_id"]
    #IO.inspect(context)
    #IO.inspect(conn)

    #question_idがあるかチェック
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(),"Question",question_id,SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    #IO.inspect(res)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{} ->
        #DONE: bodyのvalidation処理
        case CreateRequestBody.new(body) do
          {:error, _}       ->
            ErrorJson.json_by_error(conn,BadRequestError.new())
          {:ok, validated}  ->
            #1. Requestの構築
            in_param = Map.from_struct(validated)#conn.request.body
            data = %{
              "user_id"     => conn.assigns.me["_id"],
              "question_id" => question_id,
              "body"        => in_param[:body],
              "comments"    => [],
            }
            req_body = %Dodai.CreateDedicatedDataEntityRequestBody{data: data}
            req = Dodai.CreateDedicatedDataEntityRequest.new(SD.default_group_id(),"Answer",SD.root_key(),req_body)

            # 2. G2G通信を実行する
            res = Sazabi.G2gClient.send(context, SD.app_id(), req)

            # 3. レスポンスをハンドリングする
            %Dodai.CreateDedicatedDataEntitySuccess{body: res_body} = res
            Conn.json(conn, 200, Helper.to_response_body2(res_body))
        end

      %Dodai.ResourceNotFound{}                            ->
        ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end
end
