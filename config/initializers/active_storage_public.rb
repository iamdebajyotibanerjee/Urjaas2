Rails.application.config.to_prepare do
  ActiveStorage::Blobs::ProxyController.skip_before_action :authenticate_user!, raise: false
  ActiveStorage::Representations::ProxyController.skip_before_action :authenticate_user!, raise: false
  ActiveStorage::Blobs::RedirectController.skip_before_action :authenticate_user!, raise: false
  ActiveStorage::Representations::RedirectController.skip_before_action :authenticate_user!, raise: false
  ActiveStorage::DirectUploadsController.skip_before_action :authenticate_user!, raise: false
end
