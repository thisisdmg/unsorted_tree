# unsorted_tree
unsorted_tree is a thin gem to abstract unsorted trees through single nodes.

## Requirements
- Ruby >= 1.9.3

## Installation
Add this line to your application's Gemfile:
```ruby
gem 'unsorted_tree', github: 'thisisdmg/unsorted_tree'
```

And then execute:
```shell
$ bundle install
```
## Usage
### Creating a root node
```ruby
node = UnsortedTree::Node.new

# with content
node = UnsortedTree::Node.new(Object.new)
node.content # => #<Object>
```

### Adding children to a node
```ruby
child = UnsortedTree::Node.new
node.add(child)

# or
child = node.add(UnsortedTree::Node.new)

# or
child = node.add
```

### Getting the parent and children
```ruby
root = UnsortedTree::Node.new
child = root.add

root.children # => #<Set: {child}>
node.parent # => root
```

### Getting the tree's root node
```ruby
root = UnsortedTree::Node.new
child = root.add

child.root # => root
```

### Getting a node's siblings
```ruby
root = UnsortedTree::Node.new
child_1 = root.add
child_2 = root.add

child_1.siblings # => #<Set: {child_2}>
```

### Getting a node's ancestors
```ruby
root = UnsortedTree::Node.new
child = root.add
grand_child = child.add

grand_child.ancestors # => [root, child], ordered by depth, root node first
```

### Checking if a node is an ancestor of another node
```ruby
root = UnsortedTree::Node.new
child = root.add

root.ancestor_of?(child) # => true
child.ancestor_of?(root) # => false
```

### Gettings a node's descendants
```ruby
root = UnsortedTree::Node.new
child = root.add
grand_child = child.add

root.descendants # => #<Set: {child, grand_child}>
```

### Iterating over a node's descendants
`Node` includes the `Enumerable` module so you can iterate over a node and its descendants using
any of `Enumerable`'s methods.

```ruby
root = UnsortedTree::Node.new
child = root.add
grand_child = child.add

# This will collect all object_ids of a tree.
root.map do |descendant|
  descendant.object_id
end
```

### Checking for a root node or leaf
```ruby
root = UnsortedTree::Node.new
child = root.add

root.root?  # => true
child.leaf? # => false

node.root?  # => false
child.leaf? # => true
```

### Getting all leaves below a node
```ruby
root = UnsortedTree::Node.new
child_1 = root.add
child_2 = root.add
grand_child = child_1.add

root.leaves    # => #<Set: {child_2, grand_child}>
child_1.leaves # => #<Set: {grand_child}>
child_2.leaves # => #<Set: {}>
```

### Depth of a node
```ruby
root = UnsortedTree::Node.new
child = root.add
grand_child = child.add

root.depth        # => 0
child.depth       # => 1
grand_child.depth # => 2
```

### Print a (sub)tree
Using `node.print` will print a (sub)tree to the console. Example:

```
#<UnsortedTree::Node:0x00000002caa3d0>
  #<UnsortedTree::Node:0x00000002bb7900>
    #<UnsortedTree::Node:0x000000027e5200>
  #<UnsortedTree::Node:0x000000027343b0>
```

You can also change the output of this simple print by providing a block:

```ruby
node.print do |node|
  node.object_id
end
```

will produce:

```
23417320
  22920320
    20916480
  20554200
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
