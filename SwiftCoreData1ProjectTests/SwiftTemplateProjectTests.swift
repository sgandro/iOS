//
//  SwiftTemplateProjectTests.swift
//  SwiftTemplateProjectTests
//
//  Created by Alessandro Perna on 18/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import XCTest

@testable import SwiftTemplateProject

class SwiftTemplateProjectTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNetworkGetService(){
        
        let url = "https://httpbin.org/get"
        ColorLog.blue("Environment \(Config.env)")
        
        let expectation = expectationWithDescription("GET \(url)")
        
        let request = NetworkServices.callGetService(url) { (result, error) -> Void in
            
            XCTAssertNotNil(result, "result should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if error == nil{
                ColorLog.purple("RESULT ***************************************************\n")
                ColorLog.purple("\(result)\n")
                ColorLog.purple("**********************************************************")
            }else{
                ColorLog.red(error)
                XCTFail(error!.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout((request?.task.originalRequest?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            request?.cancel()
        }
        
    }
    
    func testNetworkPostService(){
        
        let url = "https://httpbin.org/post"
        let json = ["nome":"Alessandro","cognome":"Perna"]
        ColorLog.blue("Environment \(Config.env)")
        
        let expectation = expectationWithDescription("POST \(url)")
        
        let request = NetworkServices.callPostService(url,params: json) { (result, error) -> Void in
            
            XCTAssertNotNil(result, "result should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if error == nil{
                ColorLog.purple("RESULT ***************************************************\n")
                ColorLog.purple("\(result)\n")
                ColorLog.purple("**********************************************************")
            }else{
                ColorLog.red(error)
                XCTFail(error!.localizedDescription)
            }
            expectation.fulfill()
            
        }
        
        waitForExpectationsWithTimeout((request?.task.originalRequest?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            request?.cancel()
        }
    }
    
    func testNetworkDownloadService(){
        
        let url = "https://dl.dropboxusercontent.com/u/6697572/D682B491-1F8C-404D-87D9-3CB9146728E0.MOV"
        ColorLog.blue("Environment \(Config.env)")
        
        let expectation = expectationWithDescription("GET \(url)")
        
        let request = NetworkServices.sharedIstance.downaloadFileService(url, progress: { (percentage) -> Void in

            print("percentage \(percentage) %")
            
            }) { (request, response, data, error) -> Void in

            if error == nil{
                ColorLog.purple("RESULT ***************************************************\n")
                ColorLog.purple("\(response?.suggestedFilename)\n")
                ColorLog.purple("**********************************************************")
            }else{
                ColorLog.red(error)
                XCTFail(error!.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout((request?.task.originalRequest?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            request?.cancel()
        }
        
    }
    
    
    
}
