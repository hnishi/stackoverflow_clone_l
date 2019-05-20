# defmodule StackoverflowCloneL.Controller.Question.UpdateTest do
#   use StackoverflowCloneL.CommonCase

#   @api_prefix "/v1/question/question_id"
#   @header     %{}
#   @body       %{"title" => "new title", "body" => "new body"}

#   test "update/1 should update question" do
#     :meck.expect(StackoverflowCloneL.Plug.FetchMe, :fetch, fn(conn, _) ->
#         Antikythera.Conn.assign(conn, :me, StackoverflowCloneL.TestData.UserData.dodai())
#     end)

#     :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
#       IO.inspect req
#       case req do
#         %Dodai.RetrieveDedicatedDataEntityRequest{} = retrieve_req ->
#           IO.inspect "RETRIEVE!!!"
#           IO.inspect retrieve_req
#           # retrieve_reqについて必要に応じてassertする
#           #assert retrieve_req.id == "question_id"
#           %Dodai.RetrieveDedicatedDataEntitySuccess{body: StackoverflowCloneL.TestData.QuestionData.dodai()}
#         %Dodai.UpdateDedicatedDataEntityRequest{}   = update_req   ->
#           IO.inspect "UPDATE!!!"
#           #IO.inspect update_req
#           # update_reqについての必要に応じてassertする
#           IO.inspect update_req
#           # assert update_req.body ==  %Dodai.UpdateDedicatedDataEntityRequestBody{
#           #   data: %{"$set" => %{title: "new title"}},
#           #   owner: nil,
#           #   sectionsOnInsert: nil,
#           #   upsert: nil,
#           #   version: nil
#           # }
#           %Dodai.UpdateDedicatedDataEntitySuccess{body: StackoverflowCloneL.TestData.QuestionData.dodai()}
#       end
#     end)

#     res = Req.put_json(@api_prefix, @body, @header)
#     IO.inspect res.body
#     assert res.status               == 200
#     assert Poison.decode!(res.body) == StackoverflowCloneL.TestData.QuestionData.dodai()["data"]
#   end
# end


defmodule StackoverflowCloneL.Controller.Question.UpdateTest do
 use StackoverflowCloneL.CommonCase
 test "update/1 " do
   # Implement me
 end
end
