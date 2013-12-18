(function() {
  'use strict';
  angular.module('pagerApp', ['ngRoute']).config(function($routeProvider) {
    return $routeProvider.when('/', {
      templateUrl: 'home',
      controller: 'HomeController'
    }).when('/links', {
      templateUrl: 'links',
      controller: 'LinksController'
    }).when('/links/:linkID', {
      templateUrl: 'links',
      controller: 'LinksController'
    }).when('/about', {
      templateUrl: 'about',
      controller: 'AboutController'
    }).otherwise({
      redirectTo: '/'
    });
  }).factory('Page', function($rootScope) {
    var cache, page, store;
    store = [];
    cache = [];
    page = {
      getVal: function(vName) {
        return store[vName];
      },
      setVal: function(vName, vValue) {
        store[vName] = vValue;
      },
      getCache: function(vName) {
        return cache[vName];
      },
      setCache: function(vName, vValue) {
        cache[vName] = vValue;
      },
      getAll: function() {
        return store;
      }
    };
    return page;
  }).controller('MainController', function($scope, Page) {
    var links;
    $scope.page = {};
    if (!Page.getCache('links')) {
      links = [
        {
          id: 1,
          name: 'Youtube',
          url: 'http://youtube.com/'
        }, {
          id: 2,
          name: 'My Instagram',
          url: 'http://instagram.com/lepascal'
        }
      ];
      Page.setCache('links', links);
    }
    $scope.page = Page.getAll();
  }).controller('HomeController', function($scope, Page) {
    Page.setVal('title', 'Home');
  }).controller('LinksController', function($scope, $routeParams, $location, Page) {
    $scope.links = Page.getCache('links');
    Page.setVal('title', 'Links');
    if ($routeParams.linkID) {
      if (!$scope.links[$routeParams.linkID - 1]) {
        $location.path('#/links');
      }
      $scope.showSingle = true;
      $scope.currentLink = $scope.links[$routeParams.linkID - 1];
      Page.setVal('title', 'Link: ' + $scope.currentLink.name);
    }
    return $scope.addLink = function() {
      if ($scope.newLink.url.length < 4 || !$scope.newLink.name) {
        return console.error('not enough data');
      }
      $scope.newLink.id = $scope.links.length + 1;
      $scope.links.push($scope.newLink);
      return $scope.newLink = {};
    };
  }).controller('AboutController', function($scope, Page) {
    Page.setVal('title', 'About');
  });

}).call(this);

/*
//@ sourceMappingURL=app.js.map
*/