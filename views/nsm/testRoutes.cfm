
<script src="views/nsm/js/testRoutes.js"></script>

    <style>
	.active { color: red; font-weight: bold; }
    </style>   
  
    <a ui-sref="hello" ui-sref-active="active">Hello</a>
    <a ui-sref="about" ui-sref-active="active">About</a>

    <ui-view></ui-view>
