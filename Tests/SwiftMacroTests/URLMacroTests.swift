//
//  URLMacroTests.swift
//  
//
//  Created by Илья Шаповалов on 16.08.2023.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SwiftMacroMacros)
import SwiftMacroMacros

let urlMacroTest: [String: Macro.Type] = [
    "URL": URLMacro.self,
]
#endif

final class URLMacroTests: XCTestCase {
    func test_validMacro() throws {
#if canImport(SwiftMacroMacros)
        assertMacroExpansion(
            #"""
            #URL("http://www.apple.com")
            """#,
            expandedSource: #"""
            URL(string: "http://www.apple.com")!
            """#,
            macros: urlMacroTest
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testURLStringLiteralError() throws {
#if canImport(SwiftMacroMacros)
        assertMacroExpansion(
            #"""
            #URL("https://www.apple.com/\(Int.random())")
            """#,
            expandedSource: #"""

            """#,
            diagnostics: [
                DiagnosticSpec(message: "#URL requires a static string literal", line: 1, column: 1)
            ],
            macros: urlMacroTest
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
