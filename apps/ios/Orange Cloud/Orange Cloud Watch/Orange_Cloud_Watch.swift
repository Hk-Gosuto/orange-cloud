//
//  Orange_Cloud_Watch.swift
//  Orange Cloud Watch
//

import SwiftUI
import WidgetKit

struct WatchComplicationEntry: TimelineEntry {
    let date: Date
    let totalRequests: Int
    let series: [Int]
    let topZone: String
}

struct WatchComplicationProvider: TimelineProvider {
    func placeholder(in context: Context) -> WatchComplicationEntry {
        WatchComplicationEntry(date: .now, totalRequests: 1234, series: Array(repeating: 42, count: 24), topZone: "example.com")
    }

    func getSnapshot(in context: Context, completion: @escaping (WatchComplicationEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WatchComplicationEntry>) -> Void) {
        completion(Timeline(entries: [placeholder(in: context)], policy: .after(.now.addingTimeInterval(3600))))
    }
}

struct AccountComplication: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "AccountComplication", provider: WatchComplicationProvider()) { entry in
            ComplicationView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("账号总览")
        .description("全账号 24 小时请求合计")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

struct ComplicationView: View {
    @Environment(\.widgetFamily) private var family
    let entry: WatchComplicationEntry

    private var compact: String {
        entry.totalRequests > 0 ? entry.totalRequests.formatted(.number.notation(.compactName)) : "—"
    }

    var body: some View {
        VStack {
            Text(compact)
                .font(.headline)
            Text(entry.topZone)
                .font(.caption2)
                .lineLimit(1)
        }
        .padding(4)
    }
}

@main
struct OrangeCloudWatchWidget: WidgetBundle {
    var body: some Widget {
        AccountComplication()
    }
}
