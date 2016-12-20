require 'exa/version'

module Exa
  class TreeNode
    attr_reader :name, :value, :parent, :overlays
    def initialize(name:, value: '--', parent: nil)
      @name = name
      @value = value
      @parent = parent
      @children = []
      @overlays = []
    end

    def inspect
      "<#{@name}>"
    end

    def update(val)
      @value = val
      self
    end

    def create_child(name:)
      child = TreeNode.new(name: name, parent: self)
      @children << child
      child
    end

    def unify(overlay)
      @overlays << overlay
      self
    end

    def children
      @children + @overlays.flat_map(&:children)
    end
  end

  class Visitor
    def initialize(root)
      @root = root
    end

    def seek(path)
      _root, *path_segments = path.split('/')
      current = @root
      path_segments.each do |segment|
        next_child = current.children.detect do |child|
          child.name == segment
        end

        current = if next_child
          next_child
        else
          current.create_child(name: segment)
        end
      end
      current
    end
  end

  class << self
    def remember(path, value)
      recall(path).update(value)
    end

    def recall(path)
      visitor.seek(path)
    end
    alias :[] :recall

    def union(source, target)
      # create union between source and target paths
      src_node, tgt_node = recall(source), recall(target)
      tgt_node.unify(src_node)
    end

    def visitor
      @visitor ||= Visitor.new(root)
    end

    def root
      @root ||= TreeNode.new(name: '', value: '(system root)')
    end
  end
end
