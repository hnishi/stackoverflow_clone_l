use Croma

defmodule StackoverflowCloneL.Controller.Question.Helper do
  use StackoverflowCloneL.Controller.Application

  @collection_name "Question"

  defun collection_name() :: String.t do
    @collection_name
  end

  defun to_response_body(doc :: map) :: map do
    Map.merge(doc["data"], %{
      "id"         => doc["_id"],
      "created_at" => doc["createdAt"],
    })
  end

  defun to_response_body2(map :: map) :: map do
    Map.fetch!(map, "data") |> Map.put("user id", map["_id"]) |> Map.put("created at", map["createdAt"])
  end


  defmodule Params do
    defmodule Title do
      use Croma.SubtypeOfString, pattern: ~r/\A.{1,100}\z/u
    end
    defmodule Body do
      use Croma.SubtypeOfString, pattern: ~r/\A.{1,3000}\z/u
    end
  end
end
