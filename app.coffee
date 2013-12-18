'use strict'

angular.module('pagerApp', [
  'ngRoute' 
])
  .config ($routeProvider) ->
    # all registered routes and views for this app
    $routeProvider
      .when '/',
        templateUrl: 'home'
        controller: 'HomeController'
      .when '/links',
        templateUrl: 'links'
        controller: 'LinksController'
      .when '/links/:linkID',
        templateUrl: 'links'
        controller: 'LinksController'
      .when '/about',
        templateUrl: 'about'
        controller: 'AboutController'
      .otherwise
        redirectTo: '/'
  # Cache Factory for our App, that is loaded in each controller
  .factory 'Page', ($rootScope) ->
  	store = []
  	cache = []
  	page =
  		getVal: (vName) ->
  			store[vName]
  		setVal: (vName, vValue) ->
  			store[vName] = vValue
  			return
  		getCache: (vName) ->
  			cache[vName]
  		setCache: (vName, vValue) ->
  			cache[vName] = vValue
  			return
  		getAll: ->
  			 store

  	return page
  # (most parent controller) controls the entire html document, so it can access title, body...
  .controller 'MainController', ($scope, Page) ->
  	$scope.page = {}

  	# preset the links
  	unless Page.getCache 'links'
	  	links = 
	  	[
	  		id: 1
	  		name: 'Youtube'
	  		url: 'http://youtube.com/'
	  	,
	  		id: 2
	  		name: 'My Instagram'
	  		url: 'http://instagram.com/lepascal'
	  	]
	  	Page.setCache('links', links)

  	# always use the current title
  	$scope.page = Page.getAll()
  	return

  .controller 'HomeController', ($scope, Page) ->
 		Page.setVal('title', 'Home')
 		return
 	# serves all links
	.controller 'LinksController', ($scope, $routeParams, $location, Page) ->

  	# access the cached element 
  	# in case you don't want to change the Cache use angular.copy(Page.getCache('links'))
  	$scope.links = Page.getCache('links')

  	# pre set the title
  	Page.setVal 'title', 'Links'

  	# if the single view is requested by providing a linkID parameter
  	if $routeParams.linkID
  		# it looks a bit dirty but we don't work with a resource/database/api so [$routeParams.linkID - 1] is ok
  		$location.path '#/links' unless $scope.links[$routeParams.linkID - 1]
  		$scope.showSingle = true
  		$scope.currentLink = $scope.links[$routeParams.linkID - 1]
  		Page.setVal 'title', 'Link: ' + $scope.currentLink.name

  	# is triggered by submit and adds a new link to the links list
  	$scope.addLink = () ->
  		if $scope.newLink.url.length < 4 || !$scope.newLink.name
  			return console.error 'not enough data'
  		# detect the new link's id
  		$scope.newLink.id = $scope.links.length + 1
  		$scope.links.push $scope.newLink
  		# reset the newLink obj and view
  		$scope.newLink = {}

  .controller 'AboutController', ($scope, Page) ->
  	Page.setVal 'title', 'About'
  	return
