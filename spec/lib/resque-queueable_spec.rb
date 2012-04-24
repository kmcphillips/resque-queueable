require 'spec_helper'

describe ResqueQueueable do
  before(:each) do
    Resque.stub(:enque) # Don't fire this accidentally
  end

  let(:pie) do
    p = Pie.new
    p.id = 314
    p
  end

  it "should put a queue on a queueable instance" do
    pie.queue.should be_an_instance_of ResqueQueueable::Queue
  end

  it "should run the method without the queue" do
    pie.is("delicious").should == "This pie #314 is delicious"
  end

  it "should enqueue with some metaprogramming magic" do
    Resque.should_receive(:enque).with(pie.class, pie.id, :is, "delicious")
    pie.queue.is("delicious")
  end

  it "should perform the action as expected" do
    Pie.should_receive(:find).with(pie.id).and_return(pie)
    pie.should_receive(:is).with("delicious")
    Pie.perform(pie.id, :is, "delicious")
  end
end
