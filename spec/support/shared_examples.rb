shared_examples "require sign in" do
  it "redirects unauthenticated user to front page" do
    clear_current_user
    action
    expect(response).to redirect_to root_path
  end
end