defmodule StackoverflowCloneL.Controller.Question.UpdateTest do
  use StackoverflowCloneL.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneL.Helper.ErrorJson
  alias StackoverflowCloneL.Error.CredentialError

  @api_prefix "/v1/question/question_id"
  @header     %{}
  @body       %{"title" => "new title", "body" => "new body"}

  test "update/1 should update question" do
    :meck.expect(StackoverflowCloneL.Plug.FetchMe, :fetch, fn(conn, _) ->
        Antikythera.Conn.assign(conn, :me, StackoverflowCloneL.TestData.UserData.dodai())
    end)

    :meck.expect(G2gClient, :send, fn(_, _, req) ->
      #IO.inspect req
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} = retrieve_req ->
          #IO.inspect "RETRIEVE!!!"
          #IO.inspect retrieve_req
          #retrieve_reqについて必要に応じてassertする
          assert retrieve_req.id == "question_id"
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: StackoverflowCloneL.TestData.QuestionData.dodai()}
        %Dodai.UpdateDedicatedDataEntityRequest{}   = update_req   ->
          #IO.inspect "UPDATE!!!"
          #IO.inspect update_req
          # update_reqについての必要に応じてassertする
          #IO.inspect update_req
          assert update_req.body ==  %Dodai.UpdateDedicatedDataEntityRequestBody{
            data: %{"$set" =>  %{body: "new body", title: "new title"}},
            owner: nil,
            sectionsOnInsert: nil,
            upsert: nil,
            version: nil
          }
          %Dodai.UpdateDedicatedDataEntitySuccess{body: StackoverflowCloneL.TestData.QuestionData.dodai()}
      end
    end)


    res = Req.put_json(@api_prefix, @body, @header)
    #IO.inspect res.body
    assert res.status               == 200
    assert Poison.decode!(res.body) == Map.merge(StackoverflowCloneL.TestData.QuestionData.dodai()["data"], %{
      "id"         => StackoverflowCloneL.TestData.QuestionData.dodai()["_id"],
      "created_at" => StackoverflowCloneL.TestData.QuestionData.dodai()["createdAt"],
    })
  end

  test "update/1 when specified question is not found it returns ResourceNotFoundError" do
    :meck.expect(StackoverflowCloneL.Plug.FetchMe, :fetch, fn(conn, _) ->
      Antikythera.Conn.assign(conn, :me, StackoverflowCloneL.TestData.UserData.dodai())
    end)

    :meck.expect(G2gClient, :send, fn(_, _, _) -> %Dodai.ResourceNotFound{} end)

    res = Req.put_json(@api_prefix, @body, @header)
    assert res.status               == 404
    assert Poison.decode!(res.body) == %{
      "code"        => "404-04",
      "description" => "The resource does not exist in the database.",
      "error"       => "ResourceNotFound",
    }
  end

  test "update/1 when Credential is invalid or missing. Or poster of this Question is different of login user" do
    :meck.expect(StackoverflowCloneL.Plug.FetchMe, :fetch, fn(conn, _) ->
      ErrorJson.json_by_error(conn, CredentialError.new()) end)

    res = Req.put_json(@api_prefix, @body, @header)
    assert res.status               == 401
    assert Poison.decode!(res.body) == %{
      "code"        => "401-00",
      "description" => "The given credential is invalid.",
      "error"       => "InvalidCredential",
    }
  end
end


# defmodule StackoverflowCloneL.Controller.Question.UpdateTest do
#  use StackoverflowCloneL.CommonCase
#  test "update/1 " do
#    # Implement me
#  end
# end
