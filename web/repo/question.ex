use Croma

defmodule StackoverflowCloneL.Repo.Question do
  use AntikytheraAcs.Dodai.Repo.Datastore, [
    datastore_models: [StackoverflowCloneL.Model.Question],
  ]
end
