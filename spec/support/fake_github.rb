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

  def remove_hook(*args)
    true
  end

  def repos
    [
      {
        full_name: "jimtom/My-Private-Repo",
        id: 1296269,
        owner: { id: 1, login: "jimtom" },
        permissions: { admin: true },
        private: false,
      },
    ]
  end

  def scopes(_)
    ["public_repo", "user:email"]
  end
end
