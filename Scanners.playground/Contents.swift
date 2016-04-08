import UIKit

// rough replacement scanner class. 
// Tests below.
class JerScanner {
    enum Error:ErrorType{
        case OutOfBounds
    }

    let characters: String.CharacterView
    var scanLocation: String.CharacterView.Index

    init(string:String){
        characters = string.characters
        scanLocation = characters.startIndex
    }

    func scanUpToString(string: String) -> String? {
        let targetCharacters = string.characters
        var targetIndex = targetCharacters.startIndex
        var output:String?

        scanLoop: while let nextCharacter = scanNext() {
            switch nextCharacter {

            case targetCharacters[targetIndex]:                                     // IF we have a PARTIAL MATCH with the next target character:
                targetIndex = targetIndex.advancedBy(1)                             // ...check next target character for the next loop.
                if targetIndex == targetCharacters.endIndex {                       // IF that hits the end of the target string, we have a MATCH:
                    targetIndex = targetCharacters.startIndex                       // Clear our "buffer" of partial match characters...
                    scanLocation = scanLocation.advancedBy(-targetCharacters.count) // ...reset our scan location to right before the target...
                    break scanLoop                                                  // ... and break the loop
                }
            default:                                                                // IF we do not have a match:
                var appendString = string.substringToIndex(targetIndex)            // Add the contents of any failed PARTIAL MATCH to the output...
                targetIndex = targetCharacters.startIndex                           // ...clear our buffer of partial match characters...
                appendString.append(nextCharacter)                                  // ... then, add the scanned character to our output
                if let outputString = output {
                    output = outputString + appendString
                } else {
                    output = appendString
                }
            }
        }
        let appendString = string.substringToIndex(targetIndex)
        guard appendString == "" else {                                             // If there is still a PARTIAL MATCH in the buffer on break...
            if let outputString = output {                                          // ...(becasue we the end of the input during a match)...
                return outputString + appendString                                  // ...add it to the output
            }
            return appendString
        }
        return output
    }

    func scanNext() -> Character? {
        guard scanLocation < characters.endIndex else {
            return nil
        }
        let currentLocation = scanLocation
        scanLocation = scanLocation.advancedBy(1)
        return characters[currentLocation]
    }
}

let string = "🍶éÅ123abc{dfsdgasg{{asdfs{{sadfdsafs{{dfds gads"

string.characters.count

var targetNSString:NSString? = nil
let scanner = NSScanner(string: string)
scanner.scanUpToString("{{", intoString: &targetNSString)

scanner.scanLocation
targetNSString!.length

let targetString = targetNSString as! String
targetString.characters.count

let jerScanner = JerScanner(string: string)

jerScanner.scanUpToString("{{")
(jerScanner.characters.startIndex..<jerScanner.scanLocation).count

jerScanner.scanUpToString("{{")

jerScanner.scanLocation = jerScanner.scanLocation.advancedBy(2)

jerScanner.scanUpToString("{{")



