
    
    <!--  Hello solarsystem Code -->
<!---    <script src="hellosolarsystem.js"></script>
    <script src="services/people.js"></script>
    <script src="components/hello.js"></script>
    <script src="components/about.js"></script>
    <script src="components/people.js"></script>
    <script src="components/person.js"></script>--->
    
    <script src="views/nsm/js/solar.js"></script>
    
    <!-- Visualizer and url -->
    <link rel="stylesheet" href="views/nsm/css/styles.css">
    <script src="https://npmcdn.com/show-current-browser-url"></script>
    <script src="https://npmcdn.com/@uirouter/visualizer@4.0.2"></script>
  </head>
  
  <br>
  <br>
  
 
   <!--- <div><button onClick="document.location.reload(true)">reload plunker (without changing the url)</button></div>--->
    
    <a ui-sref="hello" ui-sref-active="active">Hello</a>
    <a ui-sref="about" ui-sref-active="active">About</a>
    <a ui-sref="people" ui-sref-active="active">People</a>
    
    <ui-view></ui-view>
