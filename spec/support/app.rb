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
    <div id="ua">#{env["HTTP_USER_AGENT"]}</div>
    <p>Hello, World!</p>
    <div id="js"></div>
    <script>
      document.getElementById("js").innerHTML = JSON.stringify({
        h: window.innerHeight,
        w: window.innerWidth
      });
    </script>
    HTML
  end
end
