# frozen_string_literal: true

User.find_or_create_by(first_name: 'Test', last_name: 'User', email: 'admin@demo.com',
                       encrypted_password: 'password', password: 'password')
