namespace :fixes do
  task :update_tickets_states => :environment do
    Ticket.update_all answer_state: 'pending'
    Ticket.where(:state => 'answered').update_all(answer_state: 'answered')
  end
end
