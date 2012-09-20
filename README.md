#StatusShare
This is a [Kinvey](http://www.kinvey.com) iOS Sample app to illustrate how to take advantage of backend features through the native library's store API. This application allows individual users to share text and photo updates with the other users of the service. 

In particular this sample application highlights the following key backend tasks:
* Allow users to sign up and log in
    * Allows users to log in with Facebook credentials
* Create public/private shared data
* Link images to application data
* Save location information and display on a map
* Provide offline functionality
* Connect on the client-side to 3rd party service (Gravatar)


![](https://github.com/KinveyApps/StatusShare-iOS/raw/master/assets/kinvey_gram_in_phone.png)
![](https://github.com/KinveyApps/StatusShare-iOS/raw/master/assets/StatusShare_ss1.png)
![](https://github.com/KinveyApps/StatusShare-iOS/raw/master/assets/StatusShare_ss3.png)
![](https://github.com/KinveyApps/StatusShare-iOS/raw/master/assets/StatusShare_ss2.png)
![](https://github.com/KinveyApps/StatusShare-iOS/raw/master/assets/StatusShare_ss4.png)

## Using the App
1. First time users, tap "Create New Account"
   * New accounts require user name and password of at least 5 characters.
2. Log in using those created credentials.
3. Press the "Compose" button to write a new Update.
   * The camera button allows an image to be attached to the update.
   * Tapping the lock/unlock button makes the update private/public
   * Tapping the globe button will geo-tag the post (if the globe goes green).
4. Refresh the list by pulling down.
5. Tap a row in the list to see the author listed with the last five updates for that user.
   * If there is a geo-coded update in the last 5 for a particular author, the most recent one's coordinates will be displayed. Tapping this row will show the update on a map.

## Using the Kinvey Backend
The following section describes where to look in the code for examples of common backend tasks.

### User management
* `- [CreateAccountViewController createNewAccount:]` goes through the process of adding a new user to the users collection for a Kinvey-powered application. 
* `- [LoginViewContoller login:]` provides an example of using the `KCSUser` class to verify input credentials.
* `- [LoginViewContoller loginWithFacebook:]` provides an example of using the Facebook SDK obtain a Facebook session token an log in to Kinvey with it.


### Data caching and linking
* The `UpdatesViewController` (the main list view) uses a `KCSLinkedAppdataStore` with a cache policy: `KCSCachePolicyBoth`. This means the UI will be updated immediately with the cached results of the last query to the server, and then query the backend for new information. If the app is offline, it will just use the cache, otherwise the UI will update again when the new results come back from the server.
* The `KCSLinkedAppdataStore` also handles automatically loading attached `UIImage` objects from the backend, when a post has an associated image. The 	`WriteUpdateViewController` also uses that store to automatically link and save images chosen from the ImagePicker to a given post.

### Controlling Data Visibilty
* The `WriteUpdateViewController` lets the user choose the post visibility through a toggle button in the toolbar. This affects the `globalRead` property of the post through the created update's `KCSMetadata` object. 

### User Location
* The `WriteUpdateViewController` lets the user tag the update post with the device's current location. This uses the `CLLocationManager` class to get the location (assuming the user has granted location permission to the app). This data is stored in the special `KCSEntityKeyGeolocation` field, which allows for `KCSQuery` geo-queries on the updates (although not yet done in this sample, see the [Kinvey GeoTag](https://github.com/Kinvey/KinveyGeoTag) for sample code).
* There are additional methods in this version of `KinveyKit` to convert `CLLocation` objects to NSArrays for serialization to the backend. 

### Taking Advantage of 3rd-Party APIs
* While you can link arbitrary APIs on the backend, I wanted to provide an example of using the `KCSStore` protocol to extend the library through creating custom data sources. `GravatarStore` connects to [Gravatar](http://en.gravatar.com/site/implement/)'s API to load images to represent each user.
    * `GravatarStore` uses `queryWithQuery:` to make calls to the Gravatar API. The input query is the username, for this example. 
    * The `GravatarStore` class can be used as-is by any other application that wants to use Gravatar images. <font size=-1>(just be sure to also copy `MD5Helpers`)</font>
    

## System Requirements
* iOS 5 or later (uses storyboards)
* KinveyKit library 1.7.0 or later
* Facebook SDK 3.0 or later
