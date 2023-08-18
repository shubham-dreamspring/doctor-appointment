module UserSession
  def logout
    session.delete('user_id')
  end

  def login?
    !session['user_id'].nil?
  end

  def login(user_id)
    session['user_id'] = user_id
  end

  def logged_in_user
    return User.find(session['user_id']) if login?
    nil
  end
end