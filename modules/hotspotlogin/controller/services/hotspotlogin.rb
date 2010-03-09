require 'yaml'
require 'sinatra/base'

require 'onboard/service/hotspotlogin'

class OnBoard

  class Controller < Sinatra::Base

    get '/services/hotspotlogin.:format' do
      format(
        :module => 'hotspotlogin',
        :path => '/services/hotspotlogin',
        :format => params[:format],
        :objects  => Service::HotSpotLogin.data
      )
    end

    put '/services/hotspotlogin.:format' do
      msg = {:ok => true}
      begin
        if params['change']
          Service::HotSpotLogin.change_from_HTTP_request!(params)
        elsif params['start']
        elsif params['stop']
        elsif (params['reload'] or params['restart'])
        end
      rescue Service::HotSpotLogin::BadRequest
        status 400 # HTTP Bad Request
        msg = {:err => $!} 
      end
      format(
        :module => 'hotspotlogin',
        :path => '/services/hotspotlogin',
        :format => params[:format],
        :objects  => Service::HotSpotLogin.data,
        :msg => msg
      )
    end

  end

end