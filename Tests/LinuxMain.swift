import XCTest
@testable import STwitterTests

XCTMain([
     testCase(OAuthTests.allTests),
     testCase(UserTests.allTests)
])
