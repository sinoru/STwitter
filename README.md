# STwitter #

STwitter is a Twitter Frameworks for iOS. It support iOS Integrated Twitter SSO too. and It offers User Streaming API.

========


### Usage ###

Place anywhere and drag STwitter.xcodeproj in to your project. It needs SBJson Framework to support iOS 4.

Library documents will be available later.

### License ###

Read LICENSE for more information.

### Note ###

Twitter API is not implemented all yet. and API Documents aren't available yet.

Available API:

* STwitterRequest (Same as TWRequest in Twitter framework. but It supports iOS 4)
* STwitterTweets
	* statusUpdate
	* statusUpdate with media
	* retweet
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
* STwitterHelp
	* getConfiguration
* STwitterUser
	* getUserProfileImage
* STwitterUserStream