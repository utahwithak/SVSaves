//
//  SV_SavesTests.swift
//  SV SavesTests
//
//  Created by Carl Wieland on 7/6/21.
//

import XCTest
@testable import SV_Saves

class SV_SavesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testParsing() throws {
    
        let bundle = Bundle(for: self.classForCoder)
        let savesFolder = bundle.bundleURL.appendingPathComponent("Saves")
        guard let folderEnumerator = FileManager.default.enumerator(at: savesFolder, includingPropertiesForKeys: nil, options: [.skipsSubdirectoryDescendants]) else {
            XCTFail("Unable to get save folder enumerator")
            return
        }
        for file in folderEnumerator {
            
        }
        
        XCTAssert(bundle.bundlePath != "")
        
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
