class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :refreshing_repos
end
