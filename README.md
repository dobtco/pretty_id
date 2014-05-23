pretty_id
=======

[![Travis][0]](https://travis-ci.org/dobtco/pretty_id)
[![Code Climate][1]](https://codeclimate.com/github/dobtco/pretty_id)
[![Coveralls][2]](https://coveralls.io/r/dobtco/pretty_id)
[![RubyGem][3]](http://rubygems.org/gems/pretty_id)

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

## Generation methods

#### :pretty (default)
```ruby
chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
Array.new(options[:length]) { chars[rand(chars.length)] }.join
```

#### :urlsafe_base64
```ruby
SecureRandom.urlsafe_base64(options[:length] / 1.333)
```

## Options
```ruby
class Book < ActiveRecord::Base
  has_pretty_id method: :urlsafe_base64,          # default: :pretty
                column: :another_string_column,   # default: :pretty_id
                length: 12                        # default: 8
end
```

## Instance methods

#### `#regenerate_#{column_name}`
```ruby
user = User.create
user.pretty_id # => 'a0923sdf'
user.regenerate_pretty_id
user.pretty_id # => 'lf91fs9s'
```

#### `#regenerate_#{column_name}!`
Same as above, but also calls `save` on the record


[0]: https://img.shields.io/travis/dobtco/pretty_id.svg
[1]: https://img.shields.io/codeclimate/github/dobtco/pretty_id.svg
[2]: https://img.shields.io/coveralls/dobtco/pretty_id.svg
[3]: https://img.shields.io/gem/v/pretty_id.svg
