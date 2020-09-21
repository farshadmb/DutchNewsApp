//
//  Logger.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import CocoaLumberjack

/// App Logger class, in order to log async in xcode project.
struct Logger {
    
    /// Log the message passed into function with debug level.
    ///
    /// - Parameters:
    ///   - message: The message will be log
    ///   - file: The file name which the method called by.
    ///   - function: The function name which log method called in.
    ///   - line: The line number of file
    ///   - tag: The external tags which provide more information.
    static func debugLog(_ message:  @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil) {
        DDLogDebug(message(), file: file, function: function, line: line, tag: tag)
    }
    
    /// Log the message passed into function with info level.
    ///
    /// - Parameters:
    ///   - message: The message will be log
    ///   - file: The file name which the method called by.
    ///   - function: The function name which log method called in.
    ///   - line: The line number of file
    ///   - tag: The external tags which provide more information.
    static func infoLog(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil) {
        DDLogInfo(message(), file: file, function: function, line: line, tag: tag)
    }
    
    /// Log the message passed into function with warn level.
    ///
    /// - Parameters:
    ///   - message: The message will be log
    ///   - file: The file name which the method called by.
    ///   - function: The function name which log method called in.
    ///   - line: The line number of file
    ///   - tag: The external tags which provide more information.
    static func warnLog(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil) {
        DDLogWarn(message(), file: file, function: function, line: line, tag: tag)
    }
    
    /// Log the message passed into function with verbose level.
    ///
    /// - Parameters:
    ///   - message: The message will be log
    ///   - file: The file name which the method called by.
    ///   - function: The function name which log method called in.
    ///   - line: The line number of file
    ///   - tag: The external tags which provide more information.
    static func verboseLog(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil) {
        DDLogVerbose(message(), file: file, function: function, line: line, tag: tag)
    }
    
    /// Log the message passed into function with error level.
    /// - Note: this method log and effect immediately after called.
    /// - Parameters:
    ///   - message: The message will be log
    ///   - file: The file name which the method called by.
    ///   - function: The function name which log method called in.
    ///   - line: The line number of file
    ///   - tag: The external tags which provide more information.
    static func errorLog(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil) {
        DDLogError(message(), file: file, function: function, line: line, tag: tag)
    }
    
    /** File Logger variable */
    let fileLogger = DDFileLogger()
    
    /// default instance of Logger
    static let `default` = Logger()
    
    /// Default Constructor for Logger
    /// Set Log Level depend on Scheme Configuration
    /// Note: Debug Configuration level is all, otherwise leve is waring
    init() {
        
        #if DEBUG
        dynamicLogLevel = DDLogLevel.all
        #else
        dynamicLogLevel = DDLogLevel.warning
        #endif
        
        if let ddttyLogger = DDTTYLogger.sharedInstance {
            DDLog.add(ddttyLogger)
        }
        
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24)  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 3
        DDLog.add(fileLogger)
        
    }
    
}

/// Load Logger
private let logger = Logger.default
