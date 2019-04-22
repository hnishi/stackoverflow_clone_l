use Croma

defmodule StackoverflowCloneL.Comment do
  defmodule Body do
    use Croma.SubtypeOfString, pattern: ~r/\A[\s\S]{1,1000}\z/u
  end
  use Croma.Struct, recursive_new?: true, fields: [
    id:         StackoverflowCloneL.DodaiId,
    body:       Body,
    user_id:    StackoverflowCloneL.DodaiId,
    created_at: Croma.String,
  ]
end

defmodule StackoverflowCloneL.CommentList do
  use Croma.SubtypeOfList, elem_module: StackoverflowCloneL.Comment
end
