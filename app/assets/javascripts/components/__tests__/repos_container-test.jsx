import ReposContainer from '../repos_container.js';

it('renders appropriately', () => {
  const wrapper = shallow(
    <ReposContainer
      authenticity_token={"csrf_token"}
      has_private_access={false}
      userHasCard={false}
    />
  );
  expect(wrapper).toMatchSnapshot();
});

it('sets the filterTerm appropriately on text input', () => {
  const wrapper = mount(
    <ReposContainer
      authenticity_token={"csrf_token"}
      has_private_access={false}
      userHasCard={false}
    />
  );
  const textInput = wrapper.find('.repo-search-tools-input');
  textInput.simulate('change', {target: {value: "new text"}});

  expect(wrapper.state('filterTerm')).toBe('new text');
});
