# frozen_string_literal: true

class DispatchAdmin::AccountSettingsController < DispatchAdminApplicationController
  def edit
    @user = current_user
  end

  def update
    result = Users::Update.call(
      user: current_user,
      user_params: user_params
    )

    if result.success?
      redirect_to dispatch_admin_account_setting_path, notice: result.payload[:message]
    else
      @user = result.error[:user]

      render :edit, status: :unprocessable_entity
    end
  end

  def change_password
    @user = current_user

    if password_params[:current_password].blank?
      @user.errors.add(:current_password, "can't be blank")
      return render :edit, status: :unprocessable_entity
    end

    unless @user.authenticate(password_params[:current_password])
      @user.errors.add(:current_password, 'is incorrect')
      return render :edit, status: :unprocessable_entity
    end

    if password_params[:password].blank?
      @user.errors.add(:password, "can't be blank")
      return render :edit, status: :unprocessable_entity
    end

    if password_params[:password_confirmation].blank?
      @user.errors.add(:password_confirmation, "can't be blank")
      return render :edit, status: :unprocessable_entity
    end

    result = Users::ChangePassword.call(
      user: @user,
      password_params: password_params.except(:current_password)
    )

    if result.success?
      redirect_to dispatch_admin_account_setting_path,
                  notice: result.payload[:message]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :username)
  end

  def password_params
    params.require(:user)
          .permit(:current_password, :password, :password_confirmation)
  end
end
