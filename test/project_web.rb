require 'rubygems'
require 'sinatra'
require 'erb'

get "/index.html" do
  erb :index
end

get "/sample_project.html" do
  erb :sample_project
end

get "/sample_project_a.html" do
  erb :sample_project_a
end

get "/sample_project_b.html" do
  erb :sample_project_b
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
      <li id="sample_project_a">
        <a href="http://localhost:4567/sample_project_a.html">sample_project_a</a>
      </li>
      <li id="sample_project_b">
        <a href="http://localhost:4567/sample_project_b.html">sample_project_b</a>
      </li>
    </ul>
  </body>
</html>


@@ sample_project
<html>
  <body>
    <h1>This is a SAMPLE PROJECT</h1>

    <p id="project_name">sample_project</p>
    <p>Maybe something interesting here?</p>

    <div class="gasm-options">
      <a id="source_url" href="git://localhost/sample_project">Download Source</a>
      <p id="build_command">rake</p>
      <p id="output_path">build</p>
    </div>
  </body>
</html>

@@ sample_project_a
<html>
  <body>
    <h1>This is SAMPLE PROJECT A</h1>

    <p id="project_name">sample_project_a</p>
    <p>It is a project that depends on another project</p>

    <div class="gasm-options">
      <a id="source_url" href="git://localhost/sample_project_a">Download Source</a>
      <p id="build_command">rake</p>
      <p id="output_path">build</p>
      <ol class="dependencies">
        <li>
          <a href="http://localhost:4567/sample_project_b.html">Sample Project B <span class="file-mask">lib/sample.exe</span></a>
        </li>
      </ol>
    </div>
   </body>
 </html>
 
@@ sample_project_b
<html>
  <body>
    <h1>This is SAMPLE PROJECT B</h1>

    <p id="project_name">sample_project_b</p>
    <p>
    It is a project that is depended on by <a href="/sample_project_a.html">project a</a>
    </p>

    <div class="gasm-options">
      <a id="source_url" href="git://localhost/sample_project_b">Download Source</a>
      <p id="build_command">rake</p>
      <p id="output_path">build</p>
    </div>
   </body>
 </html>
