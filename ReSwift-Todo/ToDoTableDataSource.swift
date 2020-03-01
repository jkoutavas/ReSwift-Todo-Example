//
//  ToDoTableDataSource.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Cocoa

class ToDoTableDataSource: NSObject {

    var viewModel: ToDoListViewModel?
    var store: ToDoListStore?
    
    fileprivate func dispatchAction(_ action: Action) {

           store?.dispatch(action)
       }
}

extension ToDoTableDataSource: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {

        return viewModel?.itemCount ?? 0
    }
    
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting?
    {
        guard let viewModel = viewModel?.items[safe: row]
            else { return nil }

        return ToDoPasteboardWriter(todoViewModel: viewModel, at: row)
    }

    func tableView( _ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int,
        proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation
    {
        guard dropOperation == .above else { return [] }

        if let source = info.draggingSource as? NSTableView, source === tableView
        {
            tableView.draggingDestinationFeedbackStyle = .gap
        } else {
            tableView.draggingDestinationFeedbackStyle = .regular
        }
        return .move
    }

    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int,
        dropOperation: NSTableView.DropOperation) -> Bool
    {
        guard let items = info.draggingPasteboard.pasteboardItems
            else { return false }

        let indexes = items.compactMap{ $0.integer(forType: .tableViewIndex) }
        if !indexes.isEmpty {
            dispatchAction(
                MoveTaskAction(from: indexes[0], to: row))
            return true
        }

        return true
    }
}

extension ToDoTableDataSource: ToDoTableDataSourceType {

    var selectedRow: Int? { return viewModel?.selectedRow }
    var selectedToDo: ToDoViewModel? { return viewModel?.selectedToDo }
    var toDoCount: Int { return viewModel?.itemCount ?? 0 }
    
    func setStore(toDoListStore: ToDoListStore?) {
        store = toDoListStore
    }
    
    func updateContents(toDoListViewModel viewModel: ToDoListViewModel) {

        self.viewModel = viewModel
    }

    func toDoCellView(tableView: NSTableView, row: Int, owner: AnyObject) -> ToDoCellView? {

        guard let cellViewModel = viewModel?.items[safe: row],
            let cellView = ToDoCellView.make(tableView: tableView, owner: owner)
            else { return nil }

        cellView.showToDo(toDoViewModel: cellViewModel)

        return cellView
    }
}
