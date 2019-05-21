defmodule StackoverflowCloneL.Controller.Vote.Create do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Error.BadRequestError

  plug StackoverflowCloneL.Plug.FetchMe, :fetch, []

  def create(conn) do
    # Implement me
    #IO.inspect conn
    with_question(conn, fn question ->
      #IO.inspect question

      # ユーザーが既に vote している場合はエラーを返す。
      list1 = question["data"]["like_voter_ids"] ++ question["data"]["dislike_voter_ids"]
      case Enum.any?(list1 , fn(x) -> x==conn.assigns.me["_id"] end) do
      true -> ErrorJson.json_by_error(conn,BadRequestError.new())
      false ->

      # 1. Requestの構築
      req_body = case Enum.at(conn.request.path_info, 4) do
        "like_vote" ->
          %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => %{"like_voter_ids" => question["data"]["like_voter_ids"] ++ [conn.assigns.me["_id"]]}}}
        "dislike_vote" ->
          %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => %{"dislike_voter_ids" => question["data"]["dislike_voter_ids"] ++ [conn.assigns.me["_id"]]}}}
        _ ->
          ErrorJson.json_by_error(conn,BadRequestError.new())
        end

      req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), "Question", Enum.at(conn.request.path_info, 2),SD.root_key(),req_body)

      # 2. G2G通信を実行する
      res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)

      # 3. レスポンスをハンドリングする
      %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = res
      #IO.inspect res_body
      out_body = %{
        "like_voter_ids" => res_body["data"]["like_voter_ids"],
        "dislike_voter_ids" => res_body["data"]["dislike_voter_ids"],
      }
      Conn.json(conn, 200, out_body)
      end
    end)
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
