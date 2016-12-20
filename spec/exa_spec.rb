require 'spec_helper'
require 'pry'
require 'exa'

describe Exa do
  it 'should store a value' do
    Exa.remember('/x', 5)
    Exa.remember('/y', 7)
    expect(Exa.recall('/x').value).to eq(5)
    expect(Exa.recall('/y').value).to eq(7)
  end

  it 'should store a structured value' do
    Exa.remember('/hello/world', 5)
    expect(Exa.recall('/hello/world').value).to eq(5)
  end

  it 'should navigate' do
    Exa.remember("/a/b/c", 'd')
    expect(Exa["/a/b/c"].value).to eq('d')
    expect(Exa["/a"].children).to eq([Exa["/a/b"]])
    expect(Exa["/a"].parent).to eq(Exa["/"])
  end

  it 'should unify/virtualize' do
    Exa.remember("/usr/joe/minutes/alpha", "hello")
    Exa.remember("/usr/mal/minutes/beta", "world")

    Exa.union("/usr/joe", "/usr/mal/friends")

    expect( Exa["/usr/mal/friends/minutes"].children ).to eq([ Exa["/usr/mal/friends/minutes/alpha"] ])
    expect( Exa["/usr/mal/friends/minutes/alpha"].value ).to eq('hello')
  end
end
