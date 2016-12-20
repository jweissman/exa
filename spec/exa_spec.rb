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
    expect(Exa.recall("/a/b/c").value).to eq('d')
    expect(Exa.recall("/a").children).to eq([Exa.recall("/a/b")])
    expect(Exa.recall("/a").parent).to eq(Exa.recall("/"))
  end
end
