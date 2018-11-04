//___FILEHEADER___

import XCTest


class MEAPUITest: XCTestCase {
    
    // Variables Initialized
    
    let app = XCUIApplication()
    var number:String!
    
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Setup to be initialized for every test case
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
        
        // landscape orientation is set arbitrarily to the left
        XCUIDevice.shared.orientation = .landscapeLeft
    }
    
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Functions to be used in the UI Test Cases
    //
    // Format:  Description of the function
    //          Expected output of the function
    //          Reason for function failure
    
    private func checkTextExists (labelText: String) {
        
        // Description: Checks the current screen to see if the label
        //              passed in the argument is present.
        //
        // Expected Result: XC Assert returns true and test proceeds.
        //
        // Error: Label is not present in the current screen.
        
        XCTAssertTrue(app.staticTexts[labelText].exists)
    }
    
    private func checkButtonExists (buttonLabel: String) {
        
        // Description: Checks the current screen to see if the button
        //              label passed in the argument is present.
        //
        // Expected Result: XC Assert returns true and test proceeds.
        //
        // Error: Button label is not present in the current screen.
        
        XCTAssertTrue(app.buttons[buttonLabel].exists)
    }
    
    private func checkPageIndicatorExists () {
        
        // Description: Checks the current screen to see if the page
        //              indicators are present.
        //
        // Expected Result: XC Assert returns true and test proceeds.
        //
        // Error: Page indicators is not present in the current screen.
        
        XCTAssert(app.pageIndicators["page 1 of 1"].exists)
    }
    
    private func clickButton (buttonLabel: String) {
        
        // Description: Clicks the button on the screen with the label
        //              passed in the argument.
        //
        // Expected Result: Button is pressed.
        //
        // Error: Button label is not present in the current screen.
        
        app.buttons[buttonLabel].tap()
    }
    
    private func tapCoordinate (xCoordinate: Double, yCoordinate: Double) {
        
        // Description: Simulates a user touch at the coordinate in the argument.
        //              Code taken from "https://stackoverflow.com/questions/36285090/how-to-tap-on-a-specific-point-using-xcode-uitests", user : JJacquet and Jakub
        //
        // Expected Result: The coordinate is pressed.
        //
        // Error: Coordinate is not within the screen.
        
        let normalized = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let coordinate = normalized.withOffset(CGVector(dx: xCoordinate, dy: yCoordinate))
        coordinate.tap()
    }
    
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // UI Test Cases - Verify that all screen elements are present
    //
    // Format:  Description of test case
    //          Expected Elements on the screen
    //          Steps for manual reproduction
    
    func testCheckHomePage() {
        
        // Description: Verify that all elements in the Home Screen are present.
        //
        // Expected: Text: "MEAP"
        //           Buttons: "Menu", "How To", "Start"
        //
        // Steps:    1) Open MEAP app
        //           2) Verify elements
        
        // Verify
        checkTextExists(labelText: "MEAP")
        checkButtonExists(buttonLabel: "Menu")
        checkButtonExists(buttonLabel: "How To")
        checkButtonExists(buttonLabel: "Start")
    }
    
    func testCheckMenuPage() {
        
        // Description: Verify that all elements in the Menu Screen are present.
        //
        // Expected: Text: "Menu"
        //           Buttons: "History Button", "Return Button", "How To"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Menu" button
        //           3) Verify elements
        
        // Pre-Condition
        clickButton(buttonLabel: "Menu")
        
        // Verify
        checkTextExists(labelText: "MENU")
        checkButtonExists(buttonLabel: "History Button")
        checkButtonExists(buttonLabel: "Return Button")
        checkButtonExists(buttonLabel: "How To")
    }
    
    func testStartButton() {
        
        // Verify that clicking the "Start" button will initiate the countdown timer
        // with the correct labels.
        //
        // Expected: Text: "Start", "3", "2", "1"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Verify elements
        
        clickButton(buttonLabel: "Start")
        checkTextExists(labelText: "3")
        sleep(1)
        checkTextExists(labelText: "2")
        sleep(1)
        checkTextExists(labelText: "1")
        
    }
    
    func testCheckPatternCompletionPage() {
        
        // Verify that all elements in the Pattern Completion page are present.
        //
        // Expected: Text: "Pattern Completion", "SCORE", "BEST",
        //                  "Please memorize the above pattern."
        //           Buttons: "Pause Button", "Next Button", "How To"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Verify elements
        
        // Pre-Condition
        clickButton(buttonLabel: "Start")
        sleep(5)
        
        // Verify
        checkTextExists(labelText: "Pattern Completion")
        checkTextExists(labelText: "SCORE")
        checkTextExists(labelText: "BEST")
        checkTextExists(labelText: "Please memorize the above pattern.")
        checkButtonExists(buttonLabel: "Pause Button")
        checkButtonExists(buttonLabel: "How To")
        checkButtonExists(buttonLabel: "Start Button")
    }
    
    func testCheckPausePage() {
        
        // Verify that all elements in the Pause page are present.
        //
        // Expected: Text: "PAUSED"
        //           Buttons: "How To", "MuteMusic",
        //                    "Resume Button", "Quit Game Button"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Click "Pause" button
        //           4) Verify elements

        // Pre-Condition
        clickButton(buttonLabel: "Start")
        sleep(5)
        clickButton(buttonLabel: "Pause Button")
        sleep(1)
        
        // Verify
        checkTextExists(labelText: "PAUSED")
        checkButtonExists(buttonLabel: "How To")
        checkButtonExists(buttonLabel: "MuteMusic")
        checkButtonExists(buttonLabel: "Resume Button")
        checkButtonExists(buttonLabel: "Quit Game Button")
    }
    
    func testCheckPatternCompletionGameplayPage() {
        
        // Verify that all elements in the Pattern Completion page are present
        // when the "Start" button is pressed.
        //
        // Expected: Text: "Pattern Completion", "SCORE", "BEST",
        //                  "Number of Blocks Left: 3"
        //           Buttons: "Pause Button", "Next Button", "How To"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Click "Start" button
        //           4) Verify elements
        
        // Pre-Condition
        clickButton(buttonLabel: "Start")
        sleep(5)
        clickButton(buttonLabel: "Start Button")
        sleep(1)
        
        // Verify
        checkTextExists(labelText: "Pattern Completion")
        checkTextExists(labelText: "SCORE")
        checkTextExists(labelText: "BEST")
        checkTextExists(labelText: "Number of Blocks Left: 3")
        checkButtonExists(buttonLabel: "Pause Button")
        checkButtonExists(buttonLabel: "How To")
        checkButtonExists(buttonLabel: "Next Button")
    }
    
    func testCheckScorePage() {
        
        // Verify that all elements in the Scores page are present.
        //
        // Expected: Text: "SCORES", "SCORE", "BEST"
        //           Buttons: "Forward", "How To"
        //           Page indicators
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Click "Start" button
        //           4) Click 3 different blue cells in the table
        //           5) Click "Next" button
        //           6) Verify elements
        
        // Pre-Condition
        clickButton(buttonLabel: "Start")
        sleep(5)
        clickButton(buttonLabel: "Start Button")
        tapCoordinate(xCoordinate: 400, yCoordinate: 300)
        tapCoordinate(xCoordinate: 430, yCoordinate: 300)
        tapCoordinate(xCoordinate: 460, yCoordinate: 300)
        clickButton(buttonLabel: "Next Button")
        
        // Verify
        checkTextExists(labelText: "SCORES")
        checkTextExists(labelText: "SCORE")
        checkTextExists(labelText: "BEST")
        checkButtonExists(buttonLabel: "How To")
        checkButtonExists(buttonLabel: "Forward Button")
        checkPageIndicatorExists()
        
    }
    
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // UI Test Cases - Testing Game Play
    //
    // Format: Description
    //         Expected Elements
    //         Steps for manual reproduction
    
    func testResumeGame() {
        
        // Test that the game is able to be paused and resumed.
        // Verify that the correct screen is shown by looking for
        // the expected elements.
        //
        // Expected: Text: "Pattern Completion", "SCORE", "BEST",
        //                  "Please memorize the above pattern."
        //           Buttons: "Pause Button", "Next Button", "How To"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Click "Pause" button
        //           4) Click "Resume" button
        //           5) Verify elements
        
        // Testing Resume
        clickButton(buttonLabel: "Start")
        sleep(5)
        clickButton(buttonLabel: "Pause Button")
        sleep(1)
        clickButton(buttonLabel: "Resume Button")
        sleep(1)
        
        // Verify
        checkTextExists(labelText: "Pattern Completion")
        checkTextExists(labelText: "SCORE")
        checkTextExists(labelText: "BEST")
        checkTextExists(labelText: "Please memorize the above pattern.")
        checkButtonExists(buttonLabel: "Pause Button")
        checkButtonExists(buttonLabel: "Start Button")
        checkButtonExists(buttonLabel: "How To")
    }
    
    func testPlayGame() {
        
        // Test that the whole gameplay is able to complete from
        // start to finish.
        //
        // Expected: Text: "MEAP"
        //           Buttons: "Menu", "How To", "Start"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Click "Start" button
        //           4) Click 3 different blue cells in the table
        //           5) Click "Next" button
        //           6) Verify elements
        
        // Gameplay
        clickButton(buttonLabel: "Start")
        sleep(5)
        clickButton(buttonLabel: "Start Button")
        tapCoordinate(xCoordinate: 400, yCoordinate: 300)
        tapCoordinate(xCoordinate: 430, yCoordinate: 300)
        tapCoordinate(xCoordinate: 460, yCoordinate: 300)
        clickButton(buttonLabel: "Next Button")
        clickButton(buttonLabel: "Forward Button")
        
        // Verify
        checkTextExists(labelText: "MEAP")
        checkButtonExists(buttonLabel: "Menu")
        checkButtonExists(buttonLabel: "How To")
        checkButtonExists(buttonLabel: "Start")
    }

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Test teardown after every test case
    
    override func tearDown() {
        super.tearDown()
    }
    
}
