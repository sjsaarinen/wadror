class CreateAndAddStyleToBeers < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description
    end

    styles = Beer.select(:style).distinct
    styles.each do |s|
      Style.create(name: s.style)
    end

    rename_column :beers, :style, :old_style
    add_foreign_key :beers, :styles

    Beer.all.each do |b|
      b.style = Style.find_by name: b.old_style
    end

    remove_column :beers, :old_style
  end
end
