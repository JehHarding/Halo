import SwiftUI

struct LogEntry: Identifiable {
    let id = UUID()
    let date: String
    let summary: String
}

struct DashboardView: View {
    @State private var showSymptomLog     = false
    @State private var logExpanded        = false
    @State private var nextDoseExpanded   = true
    @State private var weightExpanded     = false
    @State private var breathingExpanded  = false
    @State private var upcomingExpanded   = false
    @State private var logHistory: [LogEntry] = []

    var body: some View {
        ZStack {
            GeometryReader { geo in
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {

                    // ── Header ──
                    VStack(alignment: .leading, spacing: 0) {
                        // Row 1: avatars flush right
                        HStack {
                            Spacer()
                            // Angel's photo
                            ZStack(alignment: .bottomTrailing) {
                                Image("angel_face")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Halo.dark, lineWidth: 2))
                                Circle()
                                    .fill(Color(hex: "#7a9a6a"))
                                    .frame(width: 9, height: 9)
                                    .overlay(Circle().stroke(Halo.bg, lineWidth: 1.5))
                                    .offset(x: 1, y: 1)
                            }
                            // v2 placeholder
                            ZStack {
                                Circle()
                                    .fill(Halo.faint)
                                    .frame(width: 30, height: 30)
                                    .overlay(Circle().stroke(Halo.border, lineWidth: 1.5))
                                Image(systemName: "plus")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(Halo.light)
                            }
                        }
                        .padding(.bottom, 10)

                        // Row 2: greeting label
                        Text("Good morning")
                            .font(Halo.sans(10, weight: .regular))
                            .tracking(2.2)
                            .textCase(.uppercase)
                            .foregroundColor(Halo.light)
                            .padding(.bottom, 2)

                        // Row 3: main serif line — full width, single line
                        HStack(spacing: 0) {
                            Text("Angel is doing ")
                                .font(Halo.serif(28, weight: .light))
                                .foregroundColor(Halo.dark)
                            Text("well today")
                                .font(Halo.serif(28, weight: .light))
                                .italic()
                                .foregroundColor(Halo.rose2)
                        }
                        .padding(.bottom, 4)

                        // Row 4: status line
                        Text("Morning meds given · 2 more due at 8pm")
                            .font(Halo.sans(12))
                            .foregroundColor(Halo.mid)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
                    .padding(.bottom, 10)

                    // ── Box 1: How is Angel today? ──
                    DashCollapseBox(
                        icon: "pencil",
                        title: "How is Angel today?",
                        badge: logHistory.isEmpty ? "No log yet" : logHistory[0].summary,
                        expanded: $logExpanded
                    ) {
                        VStack(spacing: 8) {
                            if logHistory.isEmpty {
                                Text("No entries yet. Tap Log today to add your first.")
                                    .font(Halo.sans(12))
                                    .foregroundColor(Halo.light)
                            } else {
                                ForEach(logHistory.prefix(3)) { entry in
                                    HStack(spacing: 8) {
                                        Circle().fill(Halo.rose2).frame(width: 5, height: 5)
                                        Text(entry.summary)
                                            .font(Halo.sans(12))
                                            .foregroundColor(Halo.mid)
                                            .lineLimit(1)
                                        Spacer()
                                        Text(entry.date)
                                            .font(Halo.sans(10))
                                            .foregroundColor(Halo.light)
                                    }
                                }
                            }
                            Button {
                                showSymptomLog = true
                            } label: {
                                Text("LOG TODAY")
                                    .font(Halo.sans(10, weight: .semibold))
                                    .tracking(1.4)
                                    .foregroundColor(Color(hex: "#faf7f2"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Halo.dark)
                                    .cornerRadius(6)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // ── Box 2: Next Dose ──
                    DashCollapseBox(
                        icon: "pill",
                        title: "Next Dose",
                        badge: "In 4h · 8:00pm",
                        expanded: $nextDoseExpanded
                    ) {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach([
                                ("Furosemide", "10mg"),
                                ("Atenolol",   "6.25mg"),
                                ("Taurine",    "250mg"),
                            ], id: \.0) { name, dose in
                                HStack {
                                    Circle().fill(Halo.rose2).frame(width: 6, height: 6)
                                    Text(name)
                                        .font(Halo.sans(13, weight: .medium))
                                        .foregroundColor(Halo.dark)
                                    Spacer()
                                    Text(dose)
                                        .font(Halo.sans(11))
                                        .foregroundColor(Halo.mid)
                                }
                            }
                        }
                    }

                    // ── Box 3: Weight ──
                    DashCollapseBox(
                        icon: "scalemass",
                        title: "Weight",
                        badge: "4.2 kg · Stable",
                        expanded: $weightExpanded
                    ) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(alignment: .firstTextBaseline, spacing: 3) {
                                Text("4.2")
                                    .font(Halo.sans(28, weight: .light))
                                    .foregroundColor(Halo.dark)
                                Text("kg")
                                    .font(Halo.sans(13))
                                    .foregroundColor(Halo.light)
                                Spacer()
                                Text("▲ 0.1 kg since last month")
                                    .font(Halo.sans(10))
                                    .foregroundColor(Color(hex: "#7a9a6a"))
                            }
                            WeightLineChart().frame(height: 70)
                        }
                    }

                    // ── Box 4: Breathing ──
                    DashCollapseBox(
                        icon: "waveform.path",
                        title: "Breathing",
                        badge: "24 bpm · Normal",
                        expanded: $breathingExpanded
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .firstTextBaseline, spacing: 3) {
                                Text("24")
                                    .font(Halo.sans(28, weight: .light))
                                    .foregroundColor(Color(hex: "#7a9a6a"))
                                Text("bpm")
                                    .font(Halo.sans(13))
                                    .foregroundColor(Halo.light)
                                Spacer()
                                Text("Normal · Today 8:04 AM")
                                    .font(Halo.sans(10))
                                    .foregroundColor(Halo.light)
                            }
                            HStack(spacing: 0) {
                                DashStatMini(value: "≤30", label: "Normal",  color: Color(hex: "#7a9a6a"))
                                Divider().frame(height: 24)
                                DashStatMini(value: "30–40", label: "Monitor", color: Halo.accent)
                                Divider().frame(height: 24)
                                DashStatMini(value: "40+", label: "Call vet",  color: Color.red.opacity(0.7))
                            }
                        }
                    }

                    // ── Box 5: Upcoming Events ──
                    DashCollapseBox(
                        icon: "calendar",
                        title: "Upcoming Events",
                        badge: "Cardiology · Jun 22",
                        expanded: $upcomingExpanded
                    ) {
                        VStack(spacing: 0) {
                            DashUpcomingRow(dot: Color(hex: "#e8a898"), title: "Cardiology scan",      sub: "Jun 22 · Dr. Patel")
                            DashUpcomingRow(dot: Halo.accent,           title: "Angel's 7th birthday", sub: "Oct 20")
                            DashUpcomingRow(dot: Halo.faint,            title: "Log breathing rate",   sub: "Due today")
                        }
                    }

                    // Fill to screen height when all collapsed
                    Spacer(minLength: max(20, geo.size.height - 520))
                }
                .padding(.horizontal, 14)
            }
            .background(Halo.bg)
            } // GeometryReader

            if showSymptomLog {
                SymptomLogOverlay(isPresented: $showSymptomLog) { summary, date in
                    withAnimation {
                        logHistory.insert(LogEntry(date: date, summary: summary), at: 0)
                        if logHistory.count > 5 { logHistory = Array(logHistory.prefix(5)) }
                    }
                }
            }
        }
    }
}

// MARK: — Collapsible dash box

struct DashCollapseBox<Content: View>: View {
    let icon: String
    let title: String
    let badge: String
    @Binding var expanded: Bool
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { expanded.toggle() }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.system(size: 15))
                        .foregroundColor(Halo.rose2)
                        .frame(width: 22)
                    Text(title)
                        .font(Halo.sans(15, weight: .semibold))
                        .foregroundColor(Halo.dark)
                    Spacer()
                    Text(badge)
                        .font(Halo.sans(11))
                        .foregroundColor(Halo.mid)
                        .lineLimit(1)
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11))
                        .foregroundColor(Halo.light)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
            }
            .buttonStyle(.plain)

            if expanded {
                Divider().padding(.horizontal, 14)
                content()
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Halo.bg3)
        .cornerRadius(12)
        .shadow(color: Halo.dark.opacity(0.07), radius: 14, y: 4)
    }
}

// MARK: — Small stat cell (breathing box)

struct DashStatMini: View {
    let value: String
    let label: String
    let color: Color
    var body: some View {
        VStack(spacing: 2) {
            Text(value).font(Halo.sans(12, weight: .semibold)).foregroundColor(color)
            Text(label).font(Halo.sans(8)).foregroundColor(Halo.light)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: — Glow tap button

struct GlowTapButton<Content: View>: View {
    let action: () -> Void
    @ViewBuilder let content: () -> Content
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            content()
                .scaleEffect(pressed ? 0.975 : 1.0)
                .shadow(color: Halo.rose.opacity(pressed ? 0.35 : 0), radius: 16, y: 4)
                .animation(.easeInOut(duration: 0.15), value: pressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded   { _ in pressed = false }
        )
    }
}

// MARK: — Symptom log overlay

struct SymptomLogOverlay: View {
    @Binding var isPresented: Bool
    var onSave: (String, String) -> Void = { _, _ in }
    @State private var notes = ""

    let symptoms = [
        ("Lethargy", "moon.zzz"),
        ("Laboured breathing", "wind"),
        ("Reduced appetite", "fork.knife"),
        ("Hiding away", "house"),
        ("Vomiting", "exclamationmark.triangle"),
        ("Coughing", "waveform"),
        ("Wobbly on feet", "figure.walk"),
        ("Pale gums", "eye"),
    ]
    @State private var selected: Set<String> = []

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.28)
                .ignoresSafeArea()
                .onTapGesture { withAnimation { isPresented = false } }

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Halo.border)
                        .frame(width: 36, height: 4)
                    Spacer()
                }
                .padding(.top, 14)
                .padding(.bottom, 20)

                Text("How is Angel today?")
                    .font(Halo.serif(22))
                    .foregroundColor(Halo.dark)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 4)
                Text("Select all that apply, or leave blank if all is well.")
                    .font(Halo.sans(12))
                    .foregroundColor(Halo.mid)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 18)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(symptoms, id: \.0) { symptom in
                        SymptomChip(
                            label: symptom.0,
                            icon: symptom.1,
                            isOn: selected.contains(symptom.0)
                        ) {
                            withAnimation(.spring(response: 0.22)) {
                                if selected.contains(symptom.0) {
                                    selected.remove(symptom.0)
                                } else {
                                    selected.insert(symptom.0)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

                ZStack(alignment: .topLeading) {
                    if notes.isEmpty {
                        Text("Additional notes (optional)…")
                            .font(Halo.sans(13))
                            .foregroundColor(Halo.light)
                            .padding(12)
                    }
                    TextEditor(text: $notes)
                        .font(Halo.sans(13))
                        .foregroundColor(Halo.dark)
                        .frame(height: 64)
                        .padding(8)
                        .scrollContentBackground(.hidden)
                }
                .background(Halo.bg3)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Halo.border, lineWidth: 1))
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

                Button {
                    let tf = DateFormatter(); tf.dateStyle = .none; tf.timeStyle = .short
                    let summary = selected.isEmpty && notes.isEmpty
                        ? "All well"
                        : selected.isEmpty ? notes : selected.sorted().joined(separator: ", ")
                    onSave(summary, "Today \(tf.string(from: Date()))")
                    withAnimation { isPresented = false }
                } label: {
                    Text(selected.isEmpty && notes.isEmpty ? "ALL WELL TODAY" : "SAVE LOG")
                        .font(Halo.sans(11, weight: .semibold))
                        .tracking(2.0)
                        .foregroundColor(Color(hex: "#faf7f2"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Halo.dark)
                        .cornerRadius(2)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
            .background(Halo.bg)
            .cornerRadius(22, corners: [.topLeft, .topRight])
        }
        .ignoresSafeArea()
        .transition(.move(edge: .bottom))
    }
}

struct SymptomChip: View {
    let label: String
    let icon: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 7) {
                Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 14))
                    .foregroundColor(isOn ? Halo.dark : Halo.faint)
                Text(label)
                    .font(Halo.sans(11, weight: isOn ? .semibold : .regular))
                    .foregroundColor(isOn ? Halo.dark : Halo.mid)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .background(isOn ? Halo.roseL : Halo.bg3)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(isOn ? Halo.rose2 : Halo.border, lineWidth: 1.5))
            .shadow(color: isOn ? Halo.rose.opacity(0.2) : .clear, radius: 8, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: — Rounded corners helper

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: — Stat card

struct DashStatCard: View {
    let icon: String
    let label: String
    let value: String
    let unit: String
    let sub: String

    @State private var pressed = false

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(Halo.rose)
                .shadow(color: Halo.rose.opacity(pressed ? 0.4 : 0), radius: 8)
                .padding(.bottom, 2)
            HStack(alignment: .firstTextBaseline, spacing: 1) {
                Text(value)
                    .font(Halo.sans(15, weight: .semibold))
                    .foregroundColor(Halo.dark)
                if !unit.isEmpty {
                    Text(unit)
                        .font(Halo.sans(9))
                        .foregroundColor(Halo.light)
                }
            }
            Text(label)
                .font(Halo.sans(8))
                .foregroundColor(Halo.light)
                .tracking(0.6)
            Text(sub)
                .font(Halo.sans(8))
                .foregroundColor(Halo.accent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Halo.bg3)
        .cornerRadius(12)
        .shadow(color: pressed ? Halo.rose.opacity(0.22) : Halo.dark.opacity(0.07), radius: pressed ? 18 : 12, y: 4)
        .shadow(color: Halo.dark.opacity(0.04), radius: 3, y: 1)
        .scaleEffect(pressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.14), value: pressed)
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded   { _ in pressed = false }
        )
    }
}

// MARK: — Upcoming row

struct DashUpcomingRow: View {
    let dot: Color
    let title: String
    let sub: String

    @State private var pressed = false

    var body: some View {
        HStack(spacing: 10) {
            Circle().fill(dot).frame(width: 7, height: 7)
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(Halo.sans(13, weight: .medium))
                    .foregroundColor(Halo.dark)
                Text(sub)
                    .font(Halo.sans(11))
                    .foregroundColor(Halo.light)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 10))
                .foregroundColor(pressed ? Halo.rose2 : Halo.faint)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 9)
        .background(pressed ? Halo.roseL.opacity(0.5) : Color.clear)
        .scaleEffect(pressed ? 0.985 : 1.0)
        .animation(.easeInOut(duration: 0.14), value: pressed)
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded   { _ in pressed = false }
        )
    }
}

#Preview { DashboardView() }
