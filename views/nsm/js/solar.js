// JavaScript Document
app.component('about', {
  template:  '<h3>Its the UI-Router<br>Hello Solar System app!</h3>'
});

app.component('hello', {
  template:  '<h3>{{$ctrl.greeting}} solar sytem!</h3>' +
             '<button ng-click="$ctrl.toggleGreeting()">toggle greeting</button>',
             
  controller: function() {
    this.greeting = 'hello';
	
	console.log("this.greeting", this.greeting);
    
    this.toggleGreeting = function() {
      this.greeting = (this.greeting == 'hello') ? 'whats up' : 'hello'
    }
  }
});

app.component('people', {
  bindings: { people: '<' },
  
  template: '<h3>Some people:</h3>' +
            '<ul>' +
            '  <li ng-repeat="person in $ctrl.people">' +
            '    <a ui-sref="person({ personId: person.id })">' +
            '      {{person.name}}' +
            '    </a>' +
            '  </li>' +
            '</ul>'
});

app.component('person', {
  bindings: { person: '<' },
  template: '<h3>A person!</h3>' +
  
            '<div>Name: {{$ctrl.person.name}}</div>' +
            '<div>Id: {{$ctrl.person.id}}</div>' +
            '<div>Company: {{$ctrl.person.company}}</div>' +
            '<div>Email: {{$ctrl.person.email}}</div>' +
            '<div>Address: {{$ctrl.person.address}}</div>' +
            
            '<button ui-sref="people">Close</button>'
});

app.service('PeopleService', function($http) {
	
  var service = {
    getAllPeople: function() {
      return $http.get('views/nsm/js/people.json', { cache: true }).then(function(resp) {
        return resp.data;
      });
    },
    
    getPerson: function(id) {
      function personMatchesParam(person) {
        return person.id === id;
      }
      
      return service.getAllPeople().then(function (people) {
        return people.find(personMatchesParam)
      });
    }
  }
  
  return service;
});

app.config(function($stateProvider) {
  // An array of state definitions
  var states = [
    { 
      name: 'hello', 
      url: '/hello', 
      // Using component: instead of template:
      component: 'hello'  
    },
    
    { 
      name: 'about', 
      url: '/about', 
      component: 'about'
    },
    
    { 
      name: 'people', 
      url: '/people', 
      component: 'people',
      // This state defines a 'people' resolve
      // It delegates to the PeopleService to HTTP fetch (async)
      // The people component receives this via its `bindings: `
      resolve: {
        people: function(PeopleService) {
          return PeopleService.getAllPeople();
        }
      }
    },
    
    { 
      name: 'person', 
      // This state takes a URL parameter called personId
      url: '/people/{personId}', 
      component: 'person',
      // This state defines a 'person' resolve
      // It delegates to the PeopleService, passing the personId parameter
      resolve: {
        person: function(PeopleService, $transition$) {
          return PeopleService.getPerson($transition$.params().personId);
        }
      }
    }
  ]
  
  // Loop over the state definitions and register them
  states.forEach(function(state) {
    $stateProvider.state(state);
  });
});