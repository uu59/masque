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
    <div id="params">#{MultiJson.dump(params)}</div>
    <script>
      document.getElementById("js").innerHTML = JSON.stringify({
        h: window.innerHeight,
        w: window.innerWidth
      });
    </script>
    <form id="form" action="/">
      <input type="text" name="a" />
      <select name="b">
      <option value="1">1</option>
      <option value="2">2</option>
      </select>
      <input type="submit" />
    </form>
    HTML
  end
end
