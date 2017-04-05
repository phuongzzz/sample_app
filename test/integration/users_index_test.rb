require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users :phuonge
    @non_admin = users :archer
  end

  test "index including pagination" do
    log_in_as @admin
    get users_path
    assert_template "users/index"
    assert_select "div.pagination"
    User.paginate(page: 1,
      per_page: 5).each do |user|
    assert_select "a[href=?]", user_path(user), text: user.name
    end
  end

  test "admin index (have delete links)" do
     log_in_as @admin
     get users_path
     assert_template "users/index"
     assert_select "div.pagination"
     first_page_of_users = User.paginate page: 1, per_page: 5
     first_page_of_users.each do |user|
       assert_select "a[href=?]", user_path(user), text: user.name
       unless user == @admin
         assert_select "a[href=?]", user_path(user), text: "delete"
       end
     end
     assert_difference "User.count", -1 do
       delete user_path @non_admin
     end
   end

   test "regular index" do
     log_in_as @non_admin
     get users_path
     assert_select "a", text: "delete", count: 0
   end
end
