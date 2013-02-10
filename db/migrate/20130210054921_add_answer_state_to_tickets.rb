class AddAnswerStateToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :answer_state, :string
  end
end
