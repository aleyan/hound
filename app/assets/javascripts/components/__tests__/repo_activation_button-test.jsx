import RepoActivationButton from '../repo_activation_button.js';

it('renders a button appropriately for non-admin repos ', () => {
  const repo = {
    id: 1,
    name: "Test repo",
    owner: {
      id: 1
    }
  }

  const wrapper = shallow(
    <RepoActivationButton
      repo={repo}
      onRepoClicked={jest.fn()}
      isProcessingId={null}
    />
  );
  expect(wrapper).toMatchSnapshot();
});

it('renders a button appropriately for admin repos ', () => {
  const repo = {
    id: 1,
    admin: true,
    name: "Test repo",
    owner: {
      id: 1
    }
  }

  const wrapper = shallow(
    <RepoActivationButton
      repo={repo}
      onRepoClicked={jest.fn()}
      isProcessingId={null}
    />
  );
  expect(wrapper).toMatchSnapshot();
});

it('renders a disabled button appropriately for admin repos', () => {
  const repo = {
    id: 1,
    admin: true,
    name: "Test repo",
    owner: {
      id: 1
    }
  }

  const wrapper = shallow(
    <RepoActivationButton
      repo={repo}
      onRepoClicked={jest.fn()}
      isProcessingId={1}
    />
  );
  expect(wrapper).toMatchSnapshot();
});
