//
//  ViewController.swift
//  Swift5Demo
//
//  Created by YukiOkudera on 2019/04/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        compactMapValues()
        compactMapValuesExcludeNil()
        rawString()
        checkMultiples()
        outputAreaInfo()
        callUserMessages()
        callFetch()
        resultEx()
    }
}

// MARK: - Handling future enum cases (SE-0192)
enum ExError: Error {
    case aError
    case bError
    case cError
}

extension ViewController {
    func handlingError(exError: ExError) {
        switch exError {
        case .aError:
            print("aError")
        case .bError:
            print("bError")
        @unknown default:
            print("default")
        }
    }
}

// MARK: - Raw strings (SE-0200)
extension ViewController {
    func rawString() {
        // ""を含む文字列
        let string = #""社内報アプリ"配信しました！！"#
        print(string)
        // #を含む文字列
        let stringContainSharp = ##"#社内報アプリ"##
        print(stringContainSharp)
        
        // バックスラッシュをリテラル文字列として扱う
        let one = 1
        let text1 = #"Only \(one)!!"#
        print(text1)
        // string interpolation(文字列補間)
        let text2 = #"Only \#(one)!!"#
        print(text2)
        
        // 正規表現をRaw stringsで定義
        let regex = #"\\[A-Z]+[A-Za-z]+\.[a-z]+"#
        print(regex)
    }
}

// MARK: - Transforming and unwrapping dictionary values with compactMapValues() (SE-0218)
extension ViewController {
    func compactMapValues() {
        let access = [
            "walk": "60",
            "train": "20",
            "car": "unknown"
        ]
        
        // [String: String] to [String: Int]
        let knownAccessTimes = access.compactMapValues { Int($0) }
        print("knownAccessTimes", knownAccessTimes) // "car"は、含まれない
    }
    
    func compactMapValuesExcludeNil() {
        let ages = [
            "a": 20,
            "b": 21,
            "c": nil
        ]
        // [String: Int?] to [String: Int]
        let knownAges = ages.compactMapValues { $0 }
        print("knownAges", knownAges) // "c"は、含まれない
    }
}

// MARK: - Checking for integer multiples (SE-0225)
extension ViewController {
    func checkMultiples() {
        let intValue = 4
        if intValue.isMultiple(of: 2) {
            print("intValue は2の倍数")
        }
        if intValue.isMultiple(of: 3) {
            print("intValue は3の倍数")
        }
    }
}

// MARK: - Customizing string interpolation (SE-0228)
struct Area {
    var code: Int
    var name: String
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: Area) {
        appendInterpolation("Area code is \(value.code), name is \(value.name).")
    }
}

extension ViewController {
    func outputAreaInfo() {
        let area = Area(code: 100, name: "五反田")
        print(area)
        print("\(area)")
    }
}

// MARK: - Flattening nested optionals resulting from try? (SE-0230)
enum UserError: Error {
    case invalidId
}

struct User {
    var id: Int
    
    init?(id: Int) {
        if id < 0 {
            return nil
        }
        
        self.id = id
    }
    
    func getMessages() throws -> String {
        if id < 0 {
            throw UserError.invalidId
        }
        return "No messages"
    }
}

extension ViewController {
    func callUserMessages() {
        var user = User(id: 1)
        user?.id = 0
        
        // String??ではなくString?が返却される
        let messages = try? user?.getMessages()
        print("messages", messages ?? "")
    }
}

// MARK: - Result type (SE-0235) (1)
enum APIError: Error {
    case connectionError
    case decodeError
    case invalidRequest
    case invalidResponse
    case others
}

extension ViewController {
    func fetch(urlRequest: URLRequest?, completion: @escaping (Result<Int, APIError>) -> Void) {
        guard let urlRequest = urlRequest else {
            completion(.failure(.others))
            return
        }
        print("urlRequest", urlRequest)
        let successCount = 1
        completion(.success(successCount))
    }
    
    func callFetch() {
        let theUrl = URL(string: "https://example.com")!
        let request = URLRequest(url: theUrl)
        fetch(urlRequest: request) { result in
            switch result {
            case .success(let count):
                print("count", count)
            case .failure(let error):
                print("APIError", error)
            }
        }
    }
}

// MARK: - Result type (2)
extension ViewController {
    func resultEx() {
        // successケース
//        guard let fileUrl = Bundle.main.path(forResource: "test", ofType: "txt") else {
//            return
//        }
        // failureケース
        guard let fileUrl = Bundle.main.path(forResource: "test", ofType: "pdf") else {
            return
        }
        let result = Result { try String(contentsOfFile: fileUrl) }
        switch result {
        case .success(let text):
            print("text", text)
        case .failure(let error):
            print("error", error)
        }
    }
}
