require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest

  test "invalid sinup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: {
        user: {
          name: "",
          email: "phuong@invalid",
          password: "a",
          password_confirmation: "aa"
        }
      }
    end
    assert_select "div#error_explanation"
    assert_select "div.alert-danger"
    assert_template "users/new"
  end

  test "valid signup information" do
    get signup_path
    assert_difference "User.count" do
      post users_path, params: {
        user: {
          name: "Nam Phuong",
          email: "yesterdayoncemore23@gmail.com",
          password: "phuongphuong",
          password_confirmation: "phuongphuong"
        }
      }
    end
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
  end
end
