require 'spec_helper'

describe UnsortedTree::Node do
  describe '#initialize' do
    its(:parent) { should be_nil }
    its(:children) { should be_empty }
  end

  describe '#ancestor_of?' do
    let(:child) { UnsortedTree::Node.new }
    before(:each) { subject.add(child) }

    it 'returns true for an ancestor' do
      expect(subject).to be_ancestor_of(child)
    end

    it 'returns false if not an ancestor' do
      expect(child).not_to be_ancestor_of(subject)
      expect(child).not_to be_ancestor_of(child)
    end
  end

  describe '#add' do
    let(:child) { UnsortedTree::Node.new }
    before(:each) { subject.add(child) }

    it 'sets the parent on the child' do
      expect(child.parent).to be(subject)
    end

    it 'add the child to the children of the parent' do
      expect(subject.children).to have(1).child
      expect(subject.children).to include(child)
    end

    it 'returns the added node' do
      node = UnsortedTree::Node.new

      expect(subject.add(node)).to be(node)
    end

    it 'raises if the node to be added is an ancestor' do
      grand_child = child.add

      expect do
        grand_child.add(child)
      end.to raise_error(UnsortedTree::RecursionError)
    end

    it 'takes a new UnsortedTree::Node instance as default parameter' do
      expect(subject.add).to be_kind_of(UnsortedTree::Node)
    end
  end

  describe '#root?' do
    it 'returns true for a root without parent' do
      expect(subject).to be_root
    end

    it 'returns false for a node with a parent' do
      child = subject.add

      expect(child).not_to be_root
    end
  end

  describe '#leaf?' do
    it 'returns true for nodes without children (leaves)' do
      expect(subject).to be_leaf
    end

    it 'returns false for nodes with children (inner nodes)' do
      child = subject.add

      expect(subject).not_to be_leaf
    end
  end

  # describe '#path_to' do
  #   it 'returns the path as array' do
  #     child = subject.add
  #     grand_child = child.add

  #     expect(subject.path_to(grand_child)).to eq([subject, child, grand_child])
  #     expect(subject.path_to(child)).to eq([subject, child])
  #     expect(child.path_to(grand_child)).to eq([child, grand_child])
  #   end
  # end

  describe '#ancestors' do
    it 'returns an empty array for a root node' do
      expect(subject.ancestors).to be_kind_of(Array)
      expect(subject.ancestors).to be_empty
    end

    it 'returns an array containing nodes representing its ancestors' do
      child = subject.add
      grand_child = child.add

      expect(child.ancestors).to eq([subject])
      expect(grand_child.ancestors).to eq([subject, child])
    end
  end

  describe '#descendants' do
    it 'returns an empty set if the node is a leaf' do
      expect(subject.descendants).to be_kind_of(Set)
      expect(subject.descendants).to be_empty
    end

    it 'returns a set of nodes for an inner node' do
      child = subject.add
      grand_child = child.add
      grand_child_2 = child.add
      grand_grand_child = grand_child.add

      expect(subject.descendants).to eq(Set.new([child, grand_child, grand_child_2, grand_grand_child]))
      expect(grand_child.descendants).to eq(Set.new([grand_grand_child]))
    end
  end

  describe '#siblings' do
    let(:child_1) { subject.add }
    
    it 'returns an empty set for a rood node' do
      expect(subject.siblings).to be_kind_of(Set)
      expect(subject.siblings).to be_empty
    end

    it 'returns an empty set when there are no siblings' do
      expect(child_1.siblings).to be_empty
    end

    it 'returns a set of nodes with siblings when there are siblings' do
      child_2 = subject.add

      expect(child_1.siblings).to eq(Set.new([child_2]))
      expect(child_2.siblings).to eq(Set.new([child_1]))
    end
  end

  describe '#root' do
    let(:child) { subject.add }
    let(:grand_child) { child.add }

    it 'returns self if the node is a root node' do
      expect(subject.root).to be(subject)
    end

    it 'returns the root node for a leaf' do
      expect(child.root).to be(subject)
    end

    it 'returns the root node for an inner node' do
      expect(grand_child.root).to be(subject)
    end
  end

  describe '#leaves' do
    it 'returns a set with just the node if there are no children' do
      expect(subject.leaves).to eq(Set.new([subject]))
    end

    it 'returns a set of nodes when there are leaves below the node' do
      child_1 = subject.add
      child_2 = subject.add
      grand_child = child_2.add

      expect(subject.leaves).to eq(Set.new([child_1, grand_child]))
      expect(child_2.leaves).to eq(Set.new([grand_child]))
    end
  end

  describe '#depth' do
    let(:child) { subject.add }
    let(:grand_child) { child.add }

    it 'returns 0 for a root node' do
      expect(subject.depth).to be(0)
    end

    it 'returns 1 for a child of a root node' do
      expect(child.depth).to be(1)
    end

    it 'returns 2 for a grandchild of a root node' do
      expect(grand_child.depth).to be(2)
    end    
  end

  describe '#each' do
    it 'returns an enumerator if no block is given' do
      expect(subject.each).to be_kind_of(Enumerator)
    end

    it 'maps correctly' do
      child_1 = subject.add
      grand_child = child_1.add
      child_2 = subject.add

      expected = [subject, child_1, grand_child, child_2]
      expect(subject.map { |child| child }).to eq(expected)
    end
  end

  describe '#remove' do
    let(:child) { subject.add}
    before(:each) { subject.remove(child) }

    it 'removes a child from a parent' do
      expect(subject.children).to have(0).children
      expect(child).to be_root
    end

    it 'cannot remove a node if it is not a child' do
      expect { child.remove(subject) }.to raise_error(ArgumentError)
    end
  end
end
