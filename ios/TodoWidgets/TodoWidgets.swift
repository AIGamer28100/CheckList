import WidgetKit
import SwiftUI

// MARK: - Widget Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TodoEntry {
        TodoEntry(date: Date(), totalTasks: 0, completedTasks: 0, pendingTasks: 0, todayTasks: 0, overdueTasks: 0, tasks: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (TodoEntry) -> ()) {
        let entry = loadWidgetData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = loadWidgetData()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
    
    private func loadWidgetData() -> TodoEntry {
        let userDefaults = UserDefaults(suiteName: "group.com.example.todoApp")
        
        let totalTasks = userDefaults?.integer(forKey: "total_tasks") ?? 0
        let completedTasks = userDefaults?.integer(forKey: "completed_tasks") ?? 0
        let pendingTasks = userDefaults?.integer(forKey: "pending_tasks") ?? 0
        let todayTasks = userDefaults?.integer(forKey: "today_tasks") ?? 0
        let overdueTasks = userDefaults?.integer(forKey: "overdue_tasks") ?? 0
        
        var tasks: [TaskData] = []
        if let tasksData = userDefaults?.string(forKey: "tasks_json"),
           let jsonData = tasksData.data(using: .utf8),
           let taskArray = try? JSONDecoder().decode([TaskData].self, from: jsonData) {
            tasks = Array(taskArray.prefix(5))
        }
        
        return TodoEntry(
            date: Date(),
            totalTasks: totalTasks,
            completedTasks: completedTasks,
            pendingTasks: pendingTasks,
            todayTasks: todayTasks,
            overdueTasks: overdueTasks,
            tasks: tasks
        )
    }
}

// MARK: - Data Models
struct TodoEntry: TimelineEntry {
    let date: Date
    let totalTasks: Int
    let completedTasks: Int
    let pendingTasks: Int
    let todayTasks: Int
    let overdueTasks: Int
    let tasks: [TaskData]
    
    var completionPercentage: Double {
        totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) * 100.0 : 0.0
    }
}

struct TaskData: Codable, Identifiable {
    let id: String
    let title: String
    let isCompleted: Bool
    let priority: String
    let dueDate: String?
    
    var priorityColor: Color {
        switch priority.lowercased() {
        case "urgent": return .red
        case "high": return .orange
        case "medium": return .blue
        default: return .green
        }
    }
}

// MARK: - Widget Views

// Small Widget (2x2)
struct SmallWidgetView: View {
    var entry: TodoEntry
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.3, green: 0.5, blue: 0.9), Color(red: 0.2, green: 0.3, blue: 0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                Image(systemName: "checklist")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                Text("\(entry.pendingTasks)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Pending")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                
                HStack(spacing: 12) {
                    StatBadge(label: "Today", value: entry.todayTasks, color: .green)
                    StatBadge(label: "Overdue", value: entry.overdueTasks, color: .red)
                }
            }
            .padding()
        }
    }
}

// Medium Widget (4x2)
struct MediumWidgetView: View {
    var entry: TodoEntry
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.3, green: 0.5, blue: 0.9), Color(red: 0.2, green: 0.3, blue: 0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(alignment: .leading, spacing: 8) {
                // Header
                HStack {
                    Image(systemName: "checklist")
                        .foregroundColor(.white)
                    Text("CheckList")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(Int(entry.completionPercentage))%")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                // Progress Bar
                ProgressView(value: entry.completionPercentage, total: 100)
                    .tint(.white)
                    .background(Color.white.opacity(0.3))
                
                // Tasks
                if entry.tasks.isEmpty {
                    Text("No tasks yet")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ForEach(entry.tasks.prefix(2)) { task in
                        TaskRowView(task: task, compact: true)
                    }
                }
            }
            .padding()
        }
    }
}

// Large Widget (4x4)
struct LargeWidgetView: View {
    var entry: TodoEntry
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.3, green: 0.5, blue: 0.9), Color(red: 0.2, green: 0.3, blue: 0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    Image(systemName: "checklist")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text("CheckList")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                }
                
                // Stats Summary
                HStack(spacing: 16) {
                    StatCard(label: "Total", value: entry.totalTasks)
                    StatCard(label: "Done", value: entry.completedTasks)
                    StatCard(label: "Pending", value: entry.pendingTasks)
                }
                
                // Progress
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Progress")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                        Spacer()
                        Text("\(Int(entry.completionPercentage))%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    ProgressView(value: entry.completionPercentage, total: 100)
                        .tint(.white)
                        .background(Color.white.opacity(0.3))
                }
                
                Divider()
                    .background(Color.white.opacity(0.3))
                
                // Task List
                if entry.tasks.isEmpty {
                    VStack {
                        Image(systemName: "checkmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.5))
                        Text("All caught up!")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Upcoming Tasks")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                        
                        ForEach(entry.tasks.prefix(5)) { task in
                            TaskRowView(task: task, compact: false)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Helper Views

struct StatBadge: View {
    let label: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 8))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(4)
        .background(Color.white.opacity(0.2))
        .cornerRadius(6)
    }
}

struct StatCard: View {
    let label: String
    let value: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.15))
        .cornerRadius(8)
    }
}

struct TaskRowView: View {
    let task: TaskData
    let compact: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            // Priority indicator
            Circle()
                .fill(task.priorityColor)
                .frame(width: 6, height: 6)
            
            // Checkbox
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: compact ? 14 : 16))
                .foregroundColor(task.isCompleted ? .green : .white.opacity(0.7))
            
            // Task title
            Text(task.title)
                .font(.system(size: compact ? 11 : 13))
                .foregroundColor(.white)
                .lineLimit(1)
                .strikethrough(task.isCompleted)
            
            Spacer()
            
            // Due date (if available and not compact)
            if !compact, let dueDate = task.dueDate, !dueDate.isEmpty {
                Text(dueDate)
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color.white.opacity(0.1))
        .cornerRadius(6)
    }
}

// MARK: - Widget Configuration

@main
struct TodoWidgets: Widget {
    let kind: String = "TodoWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("CheckList Tasks")
        .description("View your tasks at a glance")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct TodoWidgetsEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        @unknown default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Preview
struct TodoWidgets_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTasks = [
            TaskData(id: "1", title: "Review pull requests", isCompleted: false, priority: "high", dueDate: "Today"),
            TaskData(id: "2", title: "Update documentation", isCompleted: false, priority: "medium", dueDate: "Tomorrow"),
            TaskData(id: "3", title: "Fix bug in payment flow", isCompleted: true, priority: "urgent", dueDate: "Yesterday")
        ]
        
        let entry = TodoEntry(
            date: Date(),
            totalTasks: 10,
            completedTasks: 6,
            pendingTasks: 4,
            todayTasks: 3,
            overdueTasks: 1,
            tasks: sampleTasks
        )
        
        Group {
            TodoWidgetsEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small")
            
            TodoWidgetsEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDisplayName("Medium")
            
            TodoWidgetsEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .previewDisplayName("Large")
        }
    }
}
