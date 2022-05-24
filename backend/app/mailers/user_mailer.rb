class UserMailer < ApplicationMailer
    def account_activation(user)
        @user = user
        mail to: user.email, subject: "Account activation"
    end

    def password_reset(user)
        @user = user
        @reset_url = ENV['FRONTEND_URL'] + 'users/'+ @user.reset_token + '/resets?email=' + @user.email
        mail to: user.email, subject: "Password reset"
    end
end
