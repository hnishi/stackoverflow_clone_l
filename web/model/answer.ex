use Croma

defmodule StackoverflowCloneL.Model.Answer do
  @moduledoc """
  Answer of StackoverflowCloneL app.
  """

  defmodule Body do
    use Croma.SubtypeOfString, pattern: ~r/\A[\s\S]{1,3000}\z/u
  end

  use AntikytheraAcs.Dodai.Model.Datastore, data_fields: [
    body:        Body,
    user_id:     StackoverflowCloneL.DodaiId,
    question_id: StackoverflowCloneL.DodaiId,
    comments:    StackoverflowCloneL.CommentList,
  ]
end
