module Admin::AdvertisementsHelper
  def advertisement_form_attributes advertisement
    if Advertisement.exists? advertisement.id
      return { url: admin_advertisement_path(advertisement), method: :put }
    else
      return { url: admin_advertisements_path, method: :post }
    end
  end
end
