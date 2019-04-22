use Croma

defmodule StackoverflowCloneL.Model.Question do
  @moduledoc """
  Question of StackoverflowCloneL app.
  """

  defmodule Title do
    use Croma.SubtypeOfString, pattern: ~r/\A.{1,100}\z/u
  end

  defmodule Body do
    use Croma.SubtypeOfString, pattern: ~r/\A[\s\S]{1,3000}\z/u
  end

  defmodule VoterIdList do
    use Croma.SubtypeOfList, elem_module: StackoverflowCloneL.DodaiId
  end

  use AntikytheraAcs.Dodai.Model.Datastore, data_fields: [
    title:             Title,
    body:              Body,
    user_id:           StackoverflowCloneL.DodaiId,
    like_voter_ids:    VoterIdList,
    dislike_voter_ids: VoterIdList,
    comments:          StackoverflowCloneL.CommentList
  ]
end
