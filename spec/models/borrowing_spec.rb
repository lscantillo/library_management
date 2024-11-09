# == Schema Information
#
# Table name: borrowings
#
#  id          :bigint           not null, primary key
#  user_id     :bigint           not null
#  book_id     :bigint           not null
#  borrowed_at :datetime
#  due_date    :datetime
#  returned_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
