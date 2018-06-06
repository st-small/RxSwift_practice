import Foundation

public func exampleOf(_ description: String, action: () -> ()) {
    print("\n--- Example of:", description, "---")
    action()
}
