class FakeGithub
  def initialize(_)

  end

  def repos
    []
  end

  def scopes(_)
    ["public_repo", "user:email"]
  end
end
