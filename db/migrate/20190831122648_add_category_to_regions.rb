class AddCategoryToRegions < ActiveRecord::Migration[5.2]
  def change
    add_column :regions, :category, :string
    Region.all.each do |region|
      category = Region::REGIONAL
      if ['Australia' 'New Zealand'].include? region.name
        category = Region::NATIONAL
      elsif region.name.include? 'International'
        category = Region::INTERNATIONAL
      end
      region.category = category
      region.save validate: false
    end
  end
end
