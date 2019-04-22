use Croma

defmodule StackoverflowCloneL.Plug.FetchMe do
  alias Antikythera.Conn
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Helper.ErrorJson
  alias StackoverflowCloneL.Error.CredentialError

  defun fetch(conn :: v[Conn.t], _opts :: any) :: Conn.t do
    authorization = Conn.get_req_header(conn, "authorization")
    case authorization do
      nil -> ErrorJson.json_by_error(conn, CredentialError.new())
      _   -> fetch_entity(conn, authorization)
    end
  end

  defunp fetch_entity(conn :: v[Conn.t], key :: v[String.t]) :: Conn.t do
    req = Dodai.RetrieveSelfUserRequest.new(SD.default_group_id(), key)
    case Sazabi.G2gClient.send(conn.context, SD.app_id(), req) do
      %Dodai.RetrieveSelfUserSuccess{body: body} -> Conn.assign(conn, :me, body)
      error                                      -> ErrorJson.json_by_error(conn, error)
    end
  end
end
