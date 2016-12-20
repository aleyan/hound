class FakeGithub
  Hook = Struct.new(:id)

  def initialize(_)

  end

  def add_collaborator(*args)
    true
  end

  def create_hook(*args)
    Hook.new(1)
  end

  def repos
    []
  end

  def scopes(_)
    ["public_repo", "user:email"]
  end
end
