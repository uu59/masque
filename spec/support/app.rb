# -- coding: utf-8

require "sinatra/base"

class Dummy < Sinatra::Base
  disable :logging
  enable :sessions

  get "/:arg?" do
    session[:visit] ||= 0
    session[:visit] += 1
    <<-HTML
    <style>
      body {
        background: #fff;
        color: #222;
      }
    </style>
    <title>hi #{params[:arg]}</title>
    <h1 id="visits">#{session[:visit]}</h1>
    <p>Hello, World!</p>
    HTML
  end
end
