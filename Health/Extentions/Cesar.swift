//
//  Cesar.swift
//  Flash Card
//
//  Created by mac on 07/12/2021.
//


import Foundation

public class Cesar {
    
    let alphabetList = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4","5", "6", "7", "8", "9", "0", "-", "."]
    
    public init() {}

    /// Removes repeated elements. Example input: abbbc - output: abc
    fileprivate func uniquekey(keyword: String) -> String {
        var string = String()
        for character in keyword {
            if !string.contains(String(character)) {
                string.append(character)
            }
        }
        
        return string.lowercased()
    }
    
    /// Reversed. Exemple input: abcdexyz - output: zyxedcba
    fileprivate func reversed(alphabet: [String]) -> [String] {
        var alphabet = alphabet
        var startIndex = alphabet.startIndex
        var endIndex = alphabet.endIndex - 1
        
        for _ in 0..<alphabet.count / 2 {
            
            let sString = alphabet[startIndex]
            let eString = alphabet[endIndex]
            
            alphabet.remove(at: startIndex)
            alphabet.insert(eString, at: startIndex)
            
            alphabet.remove(at: endIndex)
            alphabet.insert(sString, at: endIndex)
            
            startIndex = startIndex + 1
            endIndex = endIndex - 1
        }
        
        return alphabet
    }
    
    /// SALT alphabet, MIX alphabet, etc.
    fileprivate func shiftAlphabetList(key: String) -> [String] {
        var alphabet = alphabetList
        
        for (idx, char) in key.enumerated() {
            if let index = alphabet.index(of: String(char)) {
                let element = alphabet.remove(at: index)
                alphabet.insert(element, at: idx)
            }
        }
        return reversed(alphabet: alphabet)
    }
    
    /// Cesar reciprocation
    
    fileprivate func mapMessage(reversed: [String]) -> (encryption: [String : String], decryption: [String : String]) {
        var encryption = [String : String]()
        var decryption = [String : String]()
        
        for (index, letter) in reversed.enumerated() {
            /// [positionAlphabet: letter]
            encryption[alphabetList[index]] = letter
            /// [letter: positionAlphabet]
            decryption[letter] = alphabetList[index]
        }
        return (encryption: encryption, decryption: decryption)
    }
    
    public func encrypt(text: String, keyword: String) -> String {
        let text = text.lowercased()
        let key = uniquekey(keyword: keyword)
        let alphabet = shiftAlphabetList(key: key)
        print("ENalphabet////\(alphabet)")
        let map = mapMessage(reversed: alphabet).encryption
        print("ENmap////\(map)")

        var encrypted = String()
        
        for character in text {
            if character == " " { encrypted.append(":") }
            if let string = map[String(character)] {
                encrypted.append(string)
            }
        }
        return encrypted.uppercased()
    }
    
    public func decrypt(text: String, keyword: String) -> String {
        let text = text.lowercased()
        let key = uniquekey(keyword: keyword)
        let alphabet = shiftAlphabetList(key: key)
        print("DEalphabet////\(alphabet)")

        let map = mapMessage(reversed: alphabet).decryption
        print("DEmap////\(map)")

        var decrypted = String()
        
        for character in text {
            if character == ":" {
                decrypted.append(" ")
            }
            else if let string = map[String(character)] {
                decrypted.append(string)
            }
        }
        return decrypted
    }
    
}
