use Croma

defmodule StackoverflowCloneL.Controller.Book.Show do
  use StackoverflowCloneL.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Error.ResourceNotFoundError
  alias StackoverflowCloneL.Controller.Book.Helper

  defun show(%Conn{request: %Request{path_matches: %{id: id}}, context: context} = conn) :: Conn.t do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), Helper.collection_name(), id, SD.root_key())
    res = G2gClient.send(context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: doc} -> Conn.json(conn, 200, Helper.to_response_body(doc))
      %Dodai.ResourceNotFound{}                            -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end
end
