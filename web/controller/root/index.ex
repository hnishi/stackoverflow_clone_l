use Croma

defmodule StackoverflowCloneL.Controller.Root.Index do
  use StackoverflowCloneL.Controller.Application

  defun index(conn :: Conn.t) :: Conn.t do
    Conn.render(conn, 200, "root/index", [])
  end
end
