use Croma

defmodule StackoverflowCloneL.Controller.Comment.UpdateRequestBody do
  use Croma.Struct, fields: [
    body:  Croma.TypeGen.nilable(Croma.String),
  ]
end

defmodule StackoverflowCloneL.Controller.Comment.Update do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Controller.Comment.UpdateRequestBody
  alias StackoverflowCloneL.Error.BadRequestError

  plug StackoverflowCloneL.Plug.FetchMe, :fetch, []

  def update(conn) do
    case UpdateRequestBody.new(conn.request.body) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn,BadRequestError.new())
      {:ok, validated} ->
        question_id = Enum.at(conn.request.path_info, 2)
        comment_id = Enum.at(conn.request.path_info, 4)
        user_id = conn.assigns.me["_id"]
        name_collection = case Enum.at(conn.request.path_info, 1) do
          "question" -> "Question"
          "answer" -> "Answer"
        end

        with_comment(conn, name_collection, fn question ->
          comments = question["data"]["comments"]
          dedicated_comment_index = Enum.find_index(comments, fn comment -> comment["id"] == comment_id end)
          ## commentが存在するか確認
          case dedicated_comment_index do
            nil ->
              ErrorJson.json_by_error(conn, StackoverflowCloneL.Error.ResourceNotFoundError.new())
            _   ->
              dedicated_comment = Enum.at(comments,dedicated_comment_index)
              ## user_idとcommentのuser_idが一致するか確認する
              case dedicated_comment["user_id"] do
                ^user_id ->
                  ##user_idとcommentのuser_idが一致した場合
                  #1. Requestの構築
                  data_comment = %{
                    "id" => dedicated_comment["id"],
                    "user_id" => dedicated_comment["user_id"],
                    "body" => validated.body,
                    "created_at" =>  dedicated_comment["created_at"],
                  }
                  update_comments = List.replace_at(comments,dedicated_comment_index,data_comment)
                  req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => %{"comments" => update_comments}}}
                  req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(),name_collection, question_id, SD.root_key(), req_body)

                  # 2. G2G通信を実行する
                  res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)

                  # 3. レスポンスをハンドリングする
                  %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = res
                  update_comment = Enum.at(res_body["data"]["comments"],dedicated_comment_index)
                  Conn.json(conn, 200, update_comment)
                _ ->
                  ## user_idとcommentのuser_idが一致しない場合
                  ErrorJson.json_by_error(conn, StackoverflowCloneL.Error.CredentialError.new())
              end
          end
        end)
      end
  end

  def with_comment(conn, name_collection, f) do
    question_id =  Enum.at(conn.request.path_info, 2)
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), name_collection, question_id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, StackoverflowCloneL.Error.ResourceNotFoundError.new())
    end
  end
end
