use Croma

defmodule StackoverflowCloneL.NonEmptyString do
  use Croma.SubtypeOfString, pattern: ~r"\A.+\Z"
end
