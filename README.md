## Builded a simple implementation of FactoryBot

RingFactoryBot is able to register a factory and evaluate a default properties.

```ruby
RingFactoryBot.register :user do
  email 'foo@bar.com'
  name  'name'
end

RingFactoryBot.build :user
RingFactoryBot.build :user, name: 'Billy'
```

### Important! You should define corresponding class first or pass it as second parameter, or register will fail

```ruby
class MyClass
  attr_writer :email, :name
end


RingFactoryBot.register :user, MyClass do
  email 'foo@bar.com'
  name  'name'
end

RingFactoryBot.build :user
RingFactoryBot.build :user, name: 'Billy'
```
