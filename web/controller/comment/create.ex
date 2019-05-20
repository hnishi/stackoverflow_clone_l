use Croma

defmodule StackoverflowCloneL.Controller.Comment.CreateRequestBody do
  use Croma.Struct, fields: [
    body:  Croma.TypeGen.nilable(Croma.String),
  ]
end

defmodule StackoverflowCloneL.Controller.Comment.Create do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Controller.Comment.CreateRequestBody
  alias StackoverflowCloneL.Error.BadRequestError

  plug StackoverflowCloneL.Plug.FetchMe, :fetch, []

  def create(conn) do
    # Implement me
    case CreateRequestBody.new(conn.request.body) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn,BadRequestError.new())
      {:ok, _validated} ->
        #IO.inspect Enum.at( conn.request.path_info, 1 )

        name_collection = case Enum.at(conn.request.path_info, 1) do
          "question" -> "Question"
          "answer" -> "Answer"
          end

        with_comment(conn, name_collection, fn comment ->
          #IO.inspect comment["data"]["comments"]

          # 1. Requestの構築
          data_comment = %{
            "id" => RandomString.stream(:alphanumeric) |> Enum.take(20) |> List.to_string,
            "user_id" => conn.assigns.me["_id"],
            "body" => conn.request.body["body"],
            "created_at" =>  Antikythera.Time.to_iso_timestamp(Antikythera.Time.now()),
          }
          updated_data_comment = comment["data"]["comments"] ++ [data_comment]
          #IO.inspect updated_data_comment
          req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => %{"comments" => updated_data_comment}}}
          req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), name_collection, Enum.at(conn.request.path_info, 2),SD.root_key(),req_body)

          # 2. G2G通信を実行する
          res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)

          # 3. レスポンスをハンドリングする
          %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = res
          out_body = Enum.at(Enum.take(res_body["data"]["comments"],-1),0)
          Conn.json(conn, 200, out_body)
        end)
    end
  end

  def with_comment(conn, name_collection, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), name_collection, Enum.at(conn.request.path_info, 2), SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, StackoverflowCloneL.Error.ResourceNotFoundError.new())
    end
  end
end
