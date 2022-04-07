require 'rails_helper'

describe  'access token routes' do
  it 'should route access_tokens create action' do
    expect(post 'auth/tokens').to route_to('access_tokens#create')
  end

  it 'should route access_tokens destroy action' do
    expect(delete 'auth/tokens').to route_to('access_tokens#destroy')
  end

end