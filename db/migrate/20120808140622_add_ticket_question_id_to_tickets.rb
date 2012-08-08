class AddTicketQuestionIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :ticket_question_id, :integer
  end
end
