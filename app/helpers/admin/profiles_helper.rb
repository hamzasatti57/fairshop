module Admin::ProfilesHelper

  def profile_form_attributes profile
    if Profile.exists? profile.id
      return { url:  admin_profile_path(profile), method: :put }
    else
      return { url:  admin_profile_path, method: :post }
    end
  end
  def date_of_birth profile
    profile.dob.present? ? profile.dob.strftime("%m/%d/%Y") : "--"
  end

end
