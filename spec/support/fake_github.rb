class FakeGithub
  Comment = Struct.new(:repo, :pull_id, :body, :commit_id, :path, :position)
  Content = Struct.new(:content)
  File = Struct.new(:filename, :patch, :status)
  Hook = Struct.new(:id)

  cattr_accessor :comments
  self.comments = []

  def initialize(_)

  end

  def add_collaborator(*args)
    true
  end

  def create_hook(*args)
    Hook.new(1)
  end

  def create_status(*args)
    {}
  end

  def contents(*args)
    Content.new("U3RyaW5nTGl0ZXJhbHM6CiAgRW5hYmxlZDogZmFsc2UK\n")
  end

  def create_pull_request_comment(*args)
    self.class.comments << Comment.new(*args)
  end

  def pull_request_comments(repo, number)
    [
      Comment.new(
        repo,
        number,
        "Line is too long.",
        "81ee93414c230f71603265bd791bff5fbb8dba3e",
        "spec/models/style_guide_spec.rb",
        5,
      ),
    ]
  end

  def pull_request_files(*args)
    [
      File.new("spec/models/style_guide_spec.rb", <<-PATCH, "added")
@@ -0,0 +1,22 @@
+worker_processes Integer(ENV[\"WEB_CONCURRENCY\"] || 3)
+timeout 15
+preload_app true
+
+before_fork do |server, worker|
+  Signal.trap 'TERM' do
+    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
+    Process.kill 'QUIT', Process.pid
+  end
+
+  defined?(ActiveRecord::Base) and
+    ActiveRecord::Base.connection.disconnect!
+end
+
+after_fork do |server, worker|
+  Signal.trap 'TERM' do
+    puts 'Wait for master to send QUIT'
+  end
+
+  defined?(ActiveRecord::Base) and
+    ActiveRecord::Base.establish_connection
+end
      PATCH
    ]
  end

  def remove_collaborator(*args)
    true
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
