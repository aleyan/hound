import RepoTools from '../repo_tools.js';

it('renders appropriately without Show Private button (not syncing)', () => {
  const has_private_access = true;

  const onSearchInput = jest.fn();
  const onRefreshClicked = jest.fn();
  const onPrivateClicked = jest.fn();

  const wrapper = shallow(
    <RepoTools
      showPrivateButton={!has_private_access}
      onSearchInput={(event) => onSearchInput}
      onRefreshClicked={(event) => onRefreshClicked}
      onPrivateClicked={(event) => onPrivateClicked}
      isSyncing={false}
    />
  );
  expect(wrapper).toMatchSnapshot();
});
