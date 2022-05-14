# frozen_string_literal: true

class CreateApiTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :api_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token
      t.timestamp :expired_at

      t.timestamps
    end
  end
end
