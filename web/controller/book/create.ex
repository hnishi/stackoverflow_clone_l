use Croma

defmodule StackoverflowCloneL.Controller.Book.CreateRequestBody do
  alias StackoverflowCloneL.Controller.Book.Helper.Params

  use Croma.Struct, fields: [
    title:  Params.Title,
    author: Params.Author,
  ]
end

defmodule StackoverflowCloneL.Controller.Book.Create do
  use StackoverflowCloneL.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Error.BadRequestError
  alias StackoverflowCloneL.Controller.Book.{Helper, CreateRequestBody}

  defun create(%Conn{request: %Request{body: body}, context: context} = conn) :: Conn.t do
    case CreateRequestBody.new(body) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequestError.new())
      {:ok, validated} ->
        req_body = %Dodai.CreateDedicatedDataEntityRequestBody{data: Map.from_struct(validated)}
        req = Dodai.CreateDedicatedDataEntityRequest.new(SD.default_group_id(), Helper.collection_name(), SD.root_key(), req_body)
        %Dodai.CreateDedicatedDataEntitySuccess{body: res_body} = G2gClient.send(context, SD.app_id(), req)
        Conn.json(conn, 201, Helper.to_response_body(res_body))
    end
  end
end
