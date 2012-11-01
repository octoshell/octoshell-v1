class CreateCriticalTechnologiesSureties < ActiveRecord::Migration
  def up
    create_table :critical_technologies_sureties do |t|
      t.integer :critical_technology_id
      t.integer :surety_id
    end
    
    add_index :critical_technologies_sureties, [:critical_technology_id, :surety_id], unique: true, name: 'uniq'
  end

  def down
    drop_table :critical_technologies_sureties
  end
end
