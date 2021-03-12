import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Image_ZoomTests.allTests),
    ]
}
#endif
