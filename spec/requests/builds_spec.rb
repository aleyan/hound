require "rails_helper"

RSpec.describe "POST /builds" do
  let(:payload) do
    File.read("spec/support/fixtures/pull_request_opened_event.json")
  end
  let(:parsed_payload) { JSON.parse(payload) }
  let(:repo_name) { parsed_payload["repository"]["full_name"] }
  let(:repo_id) { parsed_payload["repository"]["id"] }
  let(:pr_sha) { parsed_payload["pull_request"]["head"]["sha"] }
  let(:pr_number) { parsed_payload["number"] }

  context "with violations" do
    it "makes a new comment and cleans up resolved one" do
      GithubApi.client = FakeGithub
      existing_comment_violation = { line: 5, message: "Line is too long." }
      new_violation = { line: 9, message: "Trailing whitespace detected." }
      violations = [existing_comment_violation, new_violation]
      create(:repo, :active, github_id: repo_id, name: repo_name)
      stub_review_job(RubocopReviewJob, violations: violations)

      post builds_path, payload: payload

      comments = FakeGithub.comments
      comment = comments.first
      expect(comments.length).to eq 1
      expect(comment.repo).to eq repo_name
      expect(comment.pull_id).to eq pr_number
      expect(comment.body).to eq "Trailing whitespace detected."
      expect(comment.commit_id).to eq pr_sha
      expect(comment.path).to eq "spec/models/style_guide_spec.rb"
      expect(comment.position).to eq 9
    end
  end

  context "without violations" do
    it "does not make a comment" do
      create(:repo, github_id: repo_id, name: repo_name)

      post builds_path, payload: payload

      expect(FakeGithub.comments).to be_empty
    end
  end

  def stub_review_job(klass, violations:)
    allow(klass).to receive(:perform) do |attributes|
      CompleteFileReview.run(
        "commit_sha" => attributes.fetch("commit_sha"),
        "filename" => attributes.fetch("filename"),
        "linter_name" => attributes.fetch("linter_name"),
        "patch" => attributes.fetch("patch"),
        "pull_request_number" => attributes.fetch("pull_request_number"),
        "violations" => violations.map(&:stringify_keys),
      )
    end
  end
end
