# STwitter #

STwitter is a High Level Twitter Frameworks for iOS / OS X. It support iOS Integrated Twitter SSO too. and It offers User Streaming API.

### Features ###
- BSD License
- High-Level Twitter API
- User Stream API
- iOS Styled API (STwitterRequest) for iOS 4 and OS X
- Automatic Reference Counting on OS X and iOS

========

### Usage ###

Place anywhere and drag STwitter.xcodeproj in to your project.

### Requirements ###

##### Build time requirements ####

This framework needs the latest iOS & OS X SDK from Apple. (Xcode 4.5 with iOS 6.0, OS X 10.8 SDK or above required)

##### Run time requirements ####

It support just OS X 10.6, iOS 4.0 and above. Other version of iOS/OS X will not be worked correctly. It needs OS Supports libdispatch and ARC (Automatic Reference Counting).

### License ###

Read LICENSE for more information.

### Note ###

Twitter API is not implemented all yet. and API Documents aren't available yet. Sorry. I'm working on it.

Available API:

* STwitterRequest (Same as TWRequest in Twitter framework. but It supports iOS 4 and OS X)
* STwitterTweets
	* statusUpdate
	* statusUpdate with media
	* retweet
	* showStatus
* STwitterOAuth
	* requestRequestToken
	* requestAuthorizeURL
	* exchangeRequestTokenToAccessToken
* STwitterAccounts
	* verifyCredentials
* STwitterFavorites
	* favoriteTweet
* STwitterTimeline
	* getHomeTimeline
	* getMentions
* STwitterDirectMessages
	* getDirectMessages
* STwitterHelp
	* getConfiguration
* STwitterUser
	* getUserProfileImage
* STwitterUserStream
	* startUserStreaming
	* stopUserStreaming
	* (with Delegate)