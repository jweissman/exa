require 'exa/version'

module Exa
  class TreeNode
    attr_reader :name, :value, :children, :parent
    def initialize(name:, value: '--', parent: nil)
      @name = name
      @value = value
      @parent = parent
      @children = []
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

    def visitor
      @visitor ||= Visitor.new(root)
    end

    def root
      @root ||= TreeNode.new(name: '', value: '(system root)')
    end
  end
end
