require 'spec_helper'

describe MustacheTemplate do
  it "should raise an error if the 'mustache_templates' directory doesn't exist" do
    File.stubs(:directory?).returns(false)
    except { MustacheTemplate.just_a_test }.to raise_error(MissingMustache)
  end

  it "should raise an error if the key doesn't exist in 'mustache_templates' directory"
  it "should raise an error if the key doesn't exist in sub-directory"
  it "should get mustache string if the file exists in 'mustache' directory"
  it "should get mustache string if the file exists in sub-dirctory"
end
