
import Foundation

class Game {
    
    private var logMessages : [String] = []
    
    var logCallback : ((String) -> Void)?;
    var logString: String {
        get { return "\n".join(logMessages.reverse()) }
    }
    
    func Log(line : String) {
        logMessages.append(line)
        logCallback?(logString)
    }
    
    
    init() {
        
    }
    
}