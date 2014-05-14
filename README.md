pretty_id
=======

Add random, unique "pretty" ids to your ActiveRecord models.

## Usage

#### 1. Install the gem
```ruby
gem 'pretty_id'
```

#### 2. Add a `pretty_id` column (and index!) to your model
```ruby
add_column :books, :pretty_id, :string
add_index :books, :pretty_id
```

#### 3. Add `has_pretty_id` to your model
```ruby
class Book < ActiveRecord::Base
  has_pretty_id
end
```

## Options
```ruby
class Book < ActiveRecord::Base
  has_pretty_id column: :another_string_column,   # default: :pretty_id
                length: 12                        # default: 8
end
```

## Warnings

Pretty IDs are generated using the [Bignum#to_s](http://www.ruby-doc.org/core-2.1.1/Bignum.html#method-i-to_s) method, and since we're seeding with a random value, there's no guarantee that they'll always be 8 characters long. However, the IDs are always checked against existing values in the database to ensure uniqueness.