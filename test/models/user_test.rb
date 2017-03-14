require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new name: "Nam_Phuong", email: "phuong@gmail.com",
      password: "namphuong", password_confirmation: "namphuong"
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "user name must be presence" do
    @user.name = ""
    assert @user.invalid?
  end

  test "user email must be presence" do
    @user.email = ""
    assert @user.invalid?
  end

  test "name shouldn't be too long" do
    @user.name = "a" * 100
    assert @user.invalid?
  end

  test "email shoudn't be too long" do
    @user.email = "a" * 300
    assert @user.invalid?
  end

  test "email validation should accept these emails" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_addr|
      @user.email = valid_addr
      assert @user.valid?, "#{valid_addr.inspect} should be valid"
    end
  end

  test "email validation should reject these emails " do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com phuong@gmail..com]
    invalid_addresses.each do |invalid_addr|
      @user.email = invalid_addr
      assert @user.invalid?, "#{invalid_addr.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert duplicate_user.invalid?
  end

  test "email should be saved in lower case" do
    mixed_case_email = "PhuonG@examplE.com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should not be too short (longer than 6)" do
    @user.password_confirmation = @user.password = "a" * 5
    assert @user.invalid?
  end

  test "password should not be blank" do
    @user.password_confirmation = @user.password = "" * 5
    assert @user.invalid?
  end
end
