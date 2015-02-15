class CreateStylesAndAddToBeers < ActiveRecord::Migration
  def change
    rename_column :beers, :style, :old_style
    add_column :beers, :style_id, :integer

    create_table :styles do |t|
      t.string :name
      t.text :description
      #t.integer :beer_id
    end

    Beer.reset_column_information

    styles = Beer.select(:old_style).distinct
    styles.each do |s|
      Style.create(name: s.old_style)
    end

    Beer.all.each do |b|
      b.style = Style.find_by(name: b.old_style)
      b.save
    end

    remove_column :beers, :old_style
  end
end
