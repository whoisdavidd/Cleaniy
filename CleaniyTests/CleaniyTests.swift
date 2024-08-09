import XCTest
@testable import Cleaniy

final class CleaniyTests: XCTestCase {

    var temporaryDirectoryURL: URL!
    var contentView: ContentView!

    override func setUpWithError() throws {
        // Create a temporary directory for testing
        let temporaryDirectory = NSTemporaryDirectory()
        let uniqueDirectoryName = UUID().uuidString
        temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory).appendingPathComponent(uniqueDirectoryName)
        try FileManager.default.createDirectory(at: temporaryDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        
        // Initialize ContentView (you can mock data if necessary)
        contentView = ContentView()
    }

    override func tearDownWithError() throws {
        // Remove the temporary directory after each test
        try FileManager.default.removeItem(at: temporaryDirectoryURL)
        contentView = nil
    }

    func createTestScreenshot(named name: String) -> URL {
        let testFilePath = temporaryDirectoryURL.appendingPathComponent(name)
        let sampleData = "This is a test screenshot".data(using: .utf8)
        FileManager.default.createFile(atPath: testFilePath.path, contents: sampleData, attributes: nil)
        return testFilePath
    }

    // Test for moving screenshot files to a folder
    func testMoveScreenshotFiles() throws {
        // Create test screenshot files
        let screenshot1 = createTestScreenshot(named: "Screenshot1.png")
        let screenshot2 = createTestScreenshot(named: "Screenshot2.png")
        
        // Ensure the files exist
        XCTAssertTrue(FileManager.default.fileExists(atPath: screenshot1.path), "Screenshot1 should exist in the temporary directory.")
        XCTAssertTrue(FileManager.default.fileExists(atPath: screenshot2.path), "Screenshot2 should exist in the temporary directory.")
        
        // Create a destination folder within the temporary directory
        let destinationFolderName = "TestFolder"
        let destinationFolderPath = temporaryDirectoryURL.appendingPathComponent(destinationFolderName)
        try FileManager.default.createDirectory(at: destinationFolderPath, withIntermediateDirectories: true, attributes: nil)
        
        // Perform the move operation using custom paths
        contentView.moveItemsToFolder(folder: destinationFolderName, sourceDirectory: temporaryDirectoryURL, destinationDirectory: destinationFolderPath)
        
        // Assert that the files were moved
        let movedScreenshot1Path = destinationFolderPath.appendingPathComponent("Screenshot1.png")
        let movedScreenshot2Path = destinationFolderPath.appendingPathComponent("Screenshot2.png")
        XCTAssertTrue(FileManager.default.fileExists(atPath: movedScreenshot1Path.path), "Screenshot1 should have been moved to the destination folder.")
        XCTAssertTrue(FileManager.default.fileExists(atPath: movedScreenshot2Path.path), "Screenshot2 should have been moved to the destination folder.")
    }

    // Test for deleting screenshot files from the desktop (temporary directory)
    func testDeleteScreenshotFiles() throws {
        // Create test screenshot files
        let screenshot1 = createTestScreenshot(named: "Screenshot1.png")
        let screenshot2 = createTestScreenshot(named: "Screenshot2.png")
        
        // Ensure the files exist
        XCTAssertTrue(FileManager.default.fileExists(atPath: screenshot1.path), "Screenshot1 should exist in the temporary directory.")
        XCTAssertTrue(FileManager.default.fileExists(atPath: screenshot2.path), "Screenshot2 should exist in the temporary directory.")
        
        // Perform the delete operation
        contentView.deleteItemsOnDesktop(sourceDirectory: temporaryDirectoryURL) // Ensure this deletes from `temporaryDirectoryURL`
        
        // Assert that the files were deleted
        XCTAssertFalse(FileManager.default.fileExists(atPath: screenshot1.path), "Screenshot1 should have been deleted from the temporary directory.")
        XCTAssertFalse(FileManager.default.fileExists(atPath: screenshot2.path), "Screenshot2 should have been deleted from the temporary directory.")
    }
}
