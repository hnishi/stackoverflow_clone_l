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

      [type_vote_req, type_vote_opp] = case Enum.at(conn.request.path_info, 4) do
        "like_vote"    -> ["like_voter_ids", "dislike_voter_ids"]
        "dislike_vote" -> ["dislike_voter_ids", "like_voter_ids"]
        end

      # ユーザーが既に vote している場合はエラーを返す。
      list_db_req = question["data"][type_vote_req]
      list_db_opp = question["data"][type_vote_opp]
      case Enum.any?(list_db_req , fn(x) -> x==conn.assigns.me["_id"] end) do
      true -> ErrorJson.json_by_error(conn,BadRequestError.new())
      false ->
        list_db_opp = if Enum.any?(list_db_opp , fn(x) -> x==conn.assigns.me["_id"] end),
          do: List.delete(list_db_opp, conn.assigns.me["_id"])
        list_db_req = list_db_req ++ [conn.assigns.me["_id"]]

      # 1. Requestの構築
      req_body =
        %Dodai.UpdateDedicatedDataEntityRequestBody{data:
          %{"$set" => %{
            type_vote_req => list_db_req,
            type_vote_opp => list_db_opp,
            }
          }
        }

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
