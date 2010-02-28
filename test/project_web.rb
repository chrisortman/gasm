require 'rubygems'
require 'sinatra'
require 'erb'

get "/index.html" do
  erb :index
end

get "/sample_project.html" do
  erb :sample_project
end

__END__

@@ index
<html>
  <body>
    <h1>Welcome to GASM</h1>

    <ul id="projects">
      <li id="sample_project">
        <a href="http://localhost:4567/sample_project.html">sample_project</a>
      </li>
    </ul>
  </body>
</html>


@@ sample_project
<html>
  <body>
    <h1>This is a SAMPLE PROJECT</h1>

    <p>Maybe something interesting here?</p>

    <div class="gasm-options">
      <a id="source_url" href="git://localhost/sample_project">Download Source</a>
      <p id="build_command">rake</p>
    </div>
  </body>
</html>
