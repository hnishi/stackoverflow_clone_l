defmodule StackoverflowCloneL.Controller.Question.Index do
  use StackoverflowCloneL.Controller.Application
  alias StackoverflowCloneL.Dodai, as: SD
  alias StackoverflowCloneL.Controller.Question.Helper

  def index(conn) do
    query = %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
      query: %{},
      sort:  %{"_id" => 1},
    }
    req = Dodai.RetrieveDedicatedDataEntityListRequest.new(SD.default_group_id(), Helper.collection_name(), SD.root_key(), query)
    %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    Conn.json(conn, 200, Enum.map(docs, &Helper.to_response_body(&1)))
  end
end
