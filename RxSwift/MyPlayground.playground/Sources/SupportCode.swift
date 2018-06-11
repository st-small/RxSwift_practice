import UIKit

public func exampleOf(_ description: String, action: () -> ()) {
    print("\n--- Example of:", description, "---")
    action()
}

public func delay(delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}
