# ActiveDelegator

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'active_delegator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_delegator

## Usage

TODO: Write usage instructions here

## Example

    model = Model.new(id: 123, name: 'Model')

    Mapper.create(model).save # Saves the model to the db

    Mapper.find(123).model do |model|
      model.name = 'New Name'
    end.save




## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
