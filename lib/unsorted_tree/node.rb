module UnsortedTree
  class Node
    include Enumerable

    attr_accessor :parent
    attr_reader :content, :children

    def initialize(content = nil)
      @content = content
      @parent = nil
      @children = Set.new
    end

    def add(node = self.class.new)
      if node.ancestor_of?(self)
        raise RecursionError, "Cannot add #{node} because it's an ancestor of #{self}."
      end

      node.parent = self
      @children.add(node)
      node
    end

    def root
      node = self
      node = node.parent until node.root?
      node
    end

    def root?
      @parent.nil?
    end

    def leaf?
      @children.empty?
    end

    def leaves
      leaves = Set.new

      if leaf?
        leaves.add(self)
      else
        children.each do |child|
          leaves.merge(child.leaves)
        end
      end

      leaves
    end

    def ancestor_of?(node)
      return false if node == self

      until node.root?
        node = node.parent
        return true if node == self
      end

      false
    end

    def ancestors
      ancestors = []
      node = self

      until node.root?
        node = node.parent
        ancestors.unshift(node)
      end

      ancestors
    end

    def descendants
      descendants = Set.new

      children.each do |child|
        descendants.add(child)
        descendants.merge(child.descendants)
      end

      descendants
    end

    def siblings
      if root?
        Set.new
      else
        @parent.children - Set.new([self])
      end
    end

    def each(&block)
      return to_enum(:each) unless block_given?

      nodes = [self]

      until nodes.empty?
        node = nodes.shift
        yield node
        nodes.unshift(*node.children) if node.children.any?
      end
    end

    def depth
      root? ? 0 : 1 + @parent.depth
    end

    def print(&label_block)
      label_block ||= proc(&:to_s)
      print_level(self, &label_block)
      nil
    end

    def remove(child)
      if @children.include?(child)
        child.parent = nil
        @children.delete(child)
      else
        raise ArgumentError, "#{child} is not a child of #{self}."
      end
    end

    private

    def print_level(node, level = 0, &label_block)
      puts "#{'  '*level}#{label_block.call(node)}"

      node.children.each do |child|
        print_level(child, level + 1, &label_block)
      end
    end
  end

  # def path_to(node)
  #   path = []

  #   until node == self
  #     node = node.parent
  #     path
  #   end

  #   path.reverse
  # end
end
