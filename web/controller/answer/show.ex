defmodule StackoverflowCloneL.Controller.Answer.Show do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Controller.Answer.Helper
  alias StackoverflowCloneL.Error.ResourceNotFoundError

  def show(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: question_id}}} = conn) do
    # Implement me
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(),"Answer",question_id,SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    #IO.inspect(res)
    Conn.json(conn, 200, %{"hello" => res})
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: doc} -> Conn.json(conn, 200, Helper.to_response_body(doc))
      %Dodai.ResourceNotFound{}                            -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end
end
