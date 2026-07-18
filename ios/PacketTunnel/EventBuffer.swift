import Foundation

/// Ring buffer for core events (`ActionResult` JSON strings with
/// `method == "message"`), drained by the app through the `getEvents`
/// provider message. NE cannot push to the app, so the app polls.
final class EventBuffer {
    static let shared = EventBuffer()

    private let capacity = 512
    private let queue = DispatchQueue(label: "uk.toworld.flclash.events")
    private var events: [(seq: Int, data: String)] = []
    private var nextSeq = 1

    func append(_ data: String) {
        queue.sync {
            events.append((seq: nextSeq, data: data))
            nextSeq += 1
            if events.count > capacity {
                events.removeFirst(events.count - capacity)
            }
        }
    }

    /// Returns events with seq > `after`, plus the newest seq for the next poll.
    func drain(after: Int) -> (events: [String], seq: Int) {
        queue.sync {
            let pending = events.filter { $0.seq > after }
            return (pending.map(\.data), nextSeq - 1)
        }
    }

    func clear() {
        queue.sync {
            events.removeAll()
        }
    }
}
