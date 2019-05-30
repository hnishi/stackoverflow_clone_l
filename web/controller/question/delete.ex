defmodule StackoverflowCloneL.Controller.Question.Delete do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  # alias StackoverflowCloneL.Controller.Question.Helper
  alias StackoverflowCloneL.Error.ResourceNotFoundError

  plug StackoverflowCloneL.Plug.FetchMe, :fetch, []

  def delete(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: my_id}}} = conn) do

    with_question(conn, fn question ->
      id = conn.assigns.me["_id"]
      case question["data"]["user_id"] do
        ^id ->
    req = Dodai.DeleteDedicatedDataEntityRequest.new(SD.default_group_id(),"Question",my_id,SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)

    # IO.inspect(res, label: "res")
    # IO.inspect %Dodai.DeleteDedicatedDataEntitySuccess
    case res.status_code do
      204 -> Conn.json(conn, 200, %{"status" => 200})
      _   -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
    _ ->
      ## 一致しない場合、下記のようにエラーを返す
      ErrorJson.json_by_error(conn, StackoverflowCloneL.Error.CredentialError.new())
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


