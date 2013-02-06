class CreateTicketQuestionsTicketTags < ActiveRecord::Migration
  def change
    create_table :ticket_questions_ticket_tags, id: false do |t|
      t.integer :ticket_question_id
      t.integer :ticket_tag_id
    end
    
    add_index :ticket_questions_ticket_tags, :ticket_question_id
    add_index :ticket_questions_ticket_tags, :ticket_tag_id
    add_index :ticket_questions_ticket_tags, [:ticket_question_id, :ticket_tag_id], unique: true, name: :unique_question_tag_relation
  end
end
