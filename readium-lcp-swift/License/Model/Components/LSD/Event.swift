//
//  Event.swift
//  readium-lcp-swift
//
//  Created by Alexandre Camilleri on 9/6/17.
//
//  Copyright 2018 Readium Foundation. All rights reserved.
//  Use of this source code is governed by a BSD-style license which is detailed
//  in the LICENSE file present in the project repository where this source code is maintained.
//

import Foundation
import SwiftyJSON

/// Event related to the change in status of a License Document.
struct Event {
    /// Identifies the type of event.
    var type: String // Type TODO
    /// Name of the client, as provided by the client during an interaction.
    var name: String
    /// Identifies the client, as provided by the client during an interaction.
    var id: String
    /// Time and date when the event occurred.
    var date: Date // Named timestamp in spec.

    init(with json: JSON) throws {
        guard let name = json["name"].string,
            let dateData = json["timestamp"].string,
            let type = json["type"].string,
            let id = json["id"].string else
        {
            throw ParsingError.json
        }
        guard let date = dateData.dateFromISO8601 else {
            throw ParsingError.date
        }
        self.type = type
        self.name = name
        self.id = id
        self.date = date
    }
}

/// Parses the Events.
///
/// - Parameter json: The JSON representing the Events.
/// - Throws: LsdErrors.
func parseEvents(_ json: JSON) throws -> [Event] {
    guard let jsonEvents = json.array else {
        return []
    }
    var events = [Event]()

    for jsonEvent in jsonEvents {
        let event = try Event.init(with: jsonEvent)

        events.append(event)
    }
    return events
}