class AddCatalogDownloadCountToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :catalog_download_count, :integer, default: 0
  end
end
