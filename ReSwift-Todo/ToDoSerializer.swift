//
//  ToDoSerializer.swift
//  ReSwift-Todo
//
//  Created by Jay Koutavas on 2/26/20.
//  Copyright © 2020 ReSwift. All rights reserved.
//

import Foundation

class ToDoSerializer {

init() { }

    lazy var dateConverter: DateConverter = DateConverter()

    func itemRepresentation(_ item: ToDo) -> String {

        let body = "- \(item.title)"
        let tags = item.tags.sorted().map { "@\($0)" }
        let done: String? = {
            switch item.completion {
            case .unfinished: return nil
            case .finished(when: let date):
                guard let date = date else { return "@done" }

                let dateString = dateConverter.string(date: date)
                return "@done(\(dateString))"
            }
        }()

        return [body]
            .appendedContentsOf(tags)
            .appendedContentsOf([done].compactMap(identity)) // remove nil
            .joined(separator: " ")
    }
}
