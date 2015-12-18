require "rails_helper"

describe StyleChecker do
  describe "#review_files" do
    it "returns a collection of file reviews with violations" do
      stylish_commit_file = stub_commit_file("good.rb", "def good; end")
      violated_commit_file = stub_commit_file("bad.rb", "def bad(a ); a; end  ")
      pull_request = stub_pull_request(
        commit_files: [stylish_commit_file, violated_commit_file],
      )

      violation_messages = pull_request_violations(pull_request)

      expect(violation_messages).to include "Trailing whitespace detected."
    end

    it "only fetches content for supported files" do
      ruby_file = double("GithubFile", filename: "ruby.rb", patch: "foo")
      bogus_file = double("GithubFile", filename: "[:facebook]", patch: "bar")
      head_commit = stub_head_commit(ruby_file.filename => "")
      pull_request = PullRequest.new(payload_stub, "anything")
      allow(pull_request).to receive(:head_commit).and_return(head_commit)
      allow(pull_request).to receive(:modified_github_files).
        and_return([bogus_file, ruby_file])

      pull_request_violations(pull_request)

      expect(head_commit).to have_received(:file_content).
        with(ruby_file.filename)
      expect(head_commit).not_to have_received(:file_content).
        with(bogus_file.filename)
    end
  end

  def pull_request_violations(pull_request)
    build = build(:build)
    StyleChecker.new(pull_request, build).review_files

    build.violations.flat_map(&:messages)
  end

  def stub_pull_request(options = {})
    defaults = {
      file_content: "",
      head_commit: stubbed_head_commit,
      commit_files: [],
      repository_owner_name: "some_org"
    }

    double("PullRequest", defaults.merge(options))
  end

  def stubbed_head_commit
    head_commit = double("Commit", file_content: "{}")
    allow(head_commit).to receive(:file_content).with(".hound.yml").
      and_return(raw_hound_config)

    head_commit
  end

  def stub_commit_file(filename, contents, line = nil)
    line ||= Line.new(content: "foo", number: 1, patch_position: 2)
    formatted_contents = "#{contents}\n"
    double(
      "CommitFile",
      filename: filename,
      content: formatted_contents,
      line_at: line,
      sha: "abc123",
      patch: "patch",
      pull_request_number: 123
    )
  end

  def stub_head_commit(options = {})
    default_options = {
      HoundConfig::CONFIG_FILE => raw_hound_config,
    }
    head_commit = double("Commit", file_content: nil)

    default_options.merge(options).each do |filename, file_contents|
      allow(head_commit).to receive(:file_content).
        with(filename).and_return(file_contents)
    end

    head_commit
  end

  def payload_stub
    double(
      "Payload",
      full_repo_name: "foo/bar",
      head_sha: "abc",
      repository_owner_name: "ralph",
    )
  end
end
