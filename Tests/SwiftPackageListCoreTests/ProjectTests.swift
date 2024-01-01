//
//  ProjectTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 15.05.22.
//

import XCTest
@testable import SwiftPackageListCore

final class ProjectTests: XCTestCase {
    func testXcodeProject() throws {
        // Note: The project and workspace files in the Resources directory get's hidden by Xcode
        let url = Bundle.module.url(forResource: "Project", withExtension: "xcodeproj", subdirectory: "Resources/XcodeProject")
        let unwrappedURL = try XCTUnwrap(url)
        
        let projectType = try XCTUnwrap(ProjectType(fileURL: unwrappedURL))
        XCTAssertEqual(projectType, .xcodeProject)
        
        let project = try projectType.project(fileURL: unwrappedURL)
        let xcodeProject = try XCTUnwrap(project as? XcodeProject)
        
        let expectedPackageResolvedFileURL = unwrappedURL
            .appendingPathComponent("project.xcworkspace")
            .appendingPathComponent("xcshareddata")
            .appendingPathComponent("swiftpm")
            .appendingPathComponent("Package.resolved")
        XCTAssertEqual(try xcodeProject.packageResolved.url, expectedPackageResolvedFileURL)
        
        XCTAssertEqual(xcodeProject.name, "Project")
        XCTAssertEqual(xcodeProject.organizationName, "SwiftPackageList")
    }
    
    func testXcodeWorkspace() throws {
        // Note: The project and workspace files in the Resources directory get's hidden by Xcode
        let url = Bundle.module.url(
            forResource: "Workspace",
            withExtension: "xcworkspace",
            subdirectory: "Resources/XcodeWorkspace"
        )
        let unwrappedURL = try XCTUnwrap(url)
        
        let projectType = try XCTUnwrap(ProjectType(fileURL: unwrappedURL))
        XCTAssertEqual(projectType, .xcodeWorkspace)
        
        let project = try projectType.project(fileURL: unwrappedURL)
        let xcodeWorkspace = try XCTUnwrap(project as? XcodeWorkspace)
        
        let expectedPackageResolvedFileURL = unwrappedURL
            .appendingPathComponent("xcshareddata")
            .appendingPathComponent("swiftpm")
            .appendingPathComponent("Package.resolved")
        XCTAssertEqual(try xcodeWorkspace.packageResolved.url, expectedPackageResolvedFileURL)
        
        XCTAssertEqual(xcodeWorkspace.name, "Workspace")
        XCTAssertEqual(xcodeWorkspace.organizationName, "SwiftPackageList")
    }
    
    func testSwiftPackage() throws {
        let url = Bundle.module.url(forResource: "Package", withExtension: "swift", subdirectory: "Resources/SwiftPackage")
        let unwrappedURL = try XCTUnwrap(url)
        
        let projectType = try XCTUnwrap(ProjectType(fileURL: unwrappedURL))
        XCTAssertEqual(projectType, .swiftPackage)
        
        let project = try projectType.project(fileURL: unwrappedURL)
        let swiftPackage = try XCTUnwrap(project as? SwiftPackage)
        
        let expectedPackageResolvedFileURL = unwrappedURL
            .deletingLastPathComponent()
            .appendingPathComponent("Package.resolved")
        XCTAssertEqual(try swiftPackage.packageResolved.url, expectedPackageResolvedFileURL)
        
        XCTAssertEqual(swiftPackage.name, "SwiftPackage")
        XCTAssertNil(swiftPackage.organizationName)
    }
}
