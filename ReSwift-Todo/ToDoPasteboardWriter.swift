//
//  ToDoPasteboardWriter.swift
//  ReSwift-TodoTests
//
//  Created by Jay Koutavas on 2/26/20.
//  Copyright © 2020 ReSwift. All rights reserved.
//

import Cocoa

class ToDoPasteboardWriter: NSObject, NSPasteboardWriting {
    var todoViewModel: ToDoViewModel
    var index: Int
    lazy var toDoSerializer = ToDoSerializer()
    
    init(todoViewModel: ToDoViewModel, at index: Int) {
        self.todoViewModel = todoViewModel
        self.index = index
    }
    
    func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [.todo, .tableViewIndex]
    }

    func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any? {
        switch type {
        case .todo:
            return todoViewModel.title
        case .tableViewIndex:
            return index
        default:
            return nil
        }
    }
}

extension NSPasteboard.PasteboardType {
    static let todo = NSPasteboard.PasteboardType("com.heynow.todo")
    static let tableViewIndex = NSPasteboard.PasteboardType("com.heynow.tableViewIndex")
}

extension NSPasteboardItem {
    open func integer(forType type: NSPasteboard.PasteboardType) -> Int? {
        guard let data = data(forType: type) else { return nil }
        let plist = try? PropertyListSerialization.propertyList(
            from: data,
            options: .mutableContainers,
            format: nil)
        return plist as? Int
    }
}
