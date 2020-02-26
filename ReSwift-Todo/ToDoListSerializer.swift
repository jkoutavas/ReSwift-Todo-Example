//
//  ToDoListSerializer.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

extension String {

    func appended(_ other: String) -> String {

        return self + other
    }
}

extension Array {

    func appendedContentsOf<C : Collection>(_ newElements: C) -> [Element] where C.Iterator.Element == Element {

        var result = self
        result.append(contentsOf: newElements)
        return result
    }
}

enum SerializationError: Error {

    case cannotEncodeString
}

class ToDoListSerializer {

    init() { }
    
    lazy var toDoSerializer = ToDoSerializer()

    func data(toDoList: ToDoList, encoding: String.Encoding = String.Encoding.utf8) -> Data? {

        return string(toDoList: toDoList).data(using: encoding)
    }

    func string(toDoList: ToDoList) -> String {

        guard !toDoList.isEmpty else { return "" }

        let title = toDoList.title.map { $0.appended(":") } ?? ""
        let items = toDoList.items.map(toDoSerializer.itemRepresentation)

        let lines = [title]
            .appendedContentsOf(items)
            .filter({ !$0.isEmpty }) // Remove empty title lines

        return lines.joined(separator: "\n").appended("\n")
    }
}

func identity<T>(_ value: T?) -> T? {
    return value
}
