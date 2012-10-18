class AddIndexOnNumberAndRepositoryIdToBuilds < ActiveRecord::Migration
  def change
    add_index 'builds', ['number', 'repository_id'], :unique => true
  end
end
