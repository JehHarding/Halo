import SwiftUI

struct BreathingReading: Identifiable {
    let id = UUID()
    let bpm: Int
    let time: String
    var statusLabel: String {
        bpm <= 30 ? "Normal" : bpm <= 40 ? "Monitor" : "Call vet"
    }
    var statusColor: Color {
        bpm <= 30 ? Color(hex: "#7a9a6a") : bpm <= 40 ? Halo.accent : Color.red.opacity(0.7)
    }
}

struct VitalsView: View {
    @State private var phase: CountPhase = .idle
    @State private var tapCount = 0
    @State private var secondsLeft = 15
    @State private var timer: Timer?
    @State private var pulseScale: CGFloat = 1.0
    @State private var showCaveat = false
    @State private var readings: [BreathingReading] = [
        BreathingReading(bpm: 24, time: "Today 8:04 AM"),
        BreathingReading(bpm: 26, time: "Yesterday 8 PM"),
    ]

    enum CountPhase { case idle, counting, done }

    let barHeights: [CGFloat] = [0.65, 0.78, 0.60, 0.82, 0.70, 0.50]
    let barLabels = ["W1","W2","W3","W4","W5","Now"]

    var body: some View {
        ZStack {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                VStack(alignment: .leading, spacing: 2) {
                    Text("Vitals")
                        .font(Halo.serif(26, weight: .light))
                        .foregroundColor(Halo.dark)
                    Text("Angel · June 2026")
                        .font(Halo.sans(10))
                        .foregroundColor(Halo.light)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 14)

                // ── Breathing counter ──
                VStack(spacing: 12) {
                    HStack {
                        Text("RESTING BREATHING RATE")
                            .font(Halo.sans(9, weight: .semibold))
                            .tracking(1.6)
                            .foregroundColor(Halo.light)
                        Spacer()
                        Button { showCaveat = true } label: {
                            ZStack {
                                Circle().fill(Halo.roseL).frame(width: 24, height: 24)
                                Image(systemName: "info")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(Halo.rose2)
                            }
                        }
                        .buttonStyle(.plain)
                    }

                    Text("Count while your pet is fully relaxed or asleep")
                        .font(Halo.sans(11))
                        .foregroundColor(Halo.mid)
                        .multilineTextAlignment(.center)

                    // Circle tap target
                    ZStack {
                        // Outer ambient glow
                        Circle()
                            .fill(phase == .counting
                                  ? Halo.rose.opacity(0.12)
                                  : Halo.roseL.opacity(0.35))
                            .frame(width: 170, height: 170)
                            .blur(radius: 14)
                            .animation(.easeInOut(duration: 0.4), value: phase == .counting)
                        // Outer stroke ring
                        Circle()
                            .stroke(phase == .counting ? Halo.rose.opacity(0.15) : Halo.border.opacity(0.6), lineWidth: 16)
                            .frame(width: 150, height: 150)
                            .animation(.easeInOut(duration: 0.4), value: phase == .counting)

                        // Background fill — fills as time progresses
                        Circle()
                            .fill(phase == .counting ? Halo.roseL.opacity(0.6) : Color.clear)
                            .frame(width: 118, height: 118)
                            .animation(.easeInOut(duration: 0.3), value: phase == .counting)

                        // Progress arc
                        if phase == .counting {
                            Circle()
                                .trim(from: 0, to: CGFloat(15 - secondsLeft) / 15)
                                .stroke(Halo.rose2, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                .frame(width: 140, height: 140)
                                .rotationEffect(.degrees(-90))
                                .animation(.linear(duration: 0.9), value: secondsLeft)
                        } else if phase == .done {
                            Circle()
                                .stroke(resultColor, lineWidth: 3)
                                .frame(width: 140, height: 140)
                        }

                        // Border ring
                        Circle()
                            .stroke(phase == .idle ? Halo.border : Halo.rose2.opacity(0.5), lineWidth: 1.5)
                            .frame(width: 118, height: 118)

                        // Content
                        VStack(spacing: 3) {
                            if phase == .idle {
                                Text("0:15")
                                    .font(Halo.sans(26, weight: .light))
                                    .foregroundColor(Halo.dark)
                                Text("tap to start")
                                    .font(Halo.sans(10))
                                    .foregroundColor(Halo.light)
                            } else if phase == .counting {
                                Text(formatTime(secondsLeft))
                                    .font(Halo.sans(26, weight: .light))
                                    .foregroundColor(Halo.dark)
                                    .contentTransition(.numericText())
                                HStack(spacing: 2) {
                                    Text("\(tapCount)")
                                        .font(Halo.sans(18, weight: .semibold))
                                        .foregroundColor(Halo.rose2)
                                    Text("breaths")
                                        .font(Halo.sans(11))
                                        .foregroundColor(Halo.mid)
                                }
                            } else {
                                Text("\(tapCount * 4)")
                                    .font(Halo.sans(32, weight: .semibold))
                                    .foregroundColor(resultColor)
                                Text("per minute")
                                    .font(Halo.sans(10))
                                    .foregroundColor(Halo.light)
                            }
                        }
                    }
                    .scaleEffect(pulseScale)
                    .contentShape(Circle())
                    .onTapGesture { handleTap() }
                    .padding(.vertical, 4)

                    // Status text
                    if phase == .idle {
                        Text("Tap the circle once for each breath you see")
                            .font(Halo.sans(11))
                            .foregroundColor(Halo.light)
                            .multilineTextAlignment(.center)
                    } else if phase == .counting {
                        Text("Keep tapping — one tap per chest rise")
                            .font(Halo.sans(11))
                            .foregroundColor(Halo.mid)
                    } else {
                        VStack(spacing: 6) {
                            Text(resultMessage)
                                .font(Halo.sans(13, weight: .semibold))
                                .foregroundColor(resultColor)
                                .multilineTextAlignment(.center)

                            Text(resultGuidance)
                                .font(Halo.sans(11))
                                .foregroundColor(Halo.mid)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 10)

                            GlowTapButton(action: { withAnimation { reset() } }) {
                                Text("Count again")
                                    .font(Halo.sans(11, weight: .medium))
                                    .foregroundColor(Halo.mid)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 7)
                                    .background(Halo.bg3)
                                    .cornerRadius(20)
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Halo.border, lineWidth: 1))
                            }
                        }
                    }

                    // Thresholds legend
                    HStack(spacing: 0) {
                        VStatCell(value: "≤30", label: "Normal", valueColor: Color(hex: "#7a9a6a"))
                        Divider().frame(height: 24)
                        VStatCell(value: "30–40", label: "Monitor", valueColor: Halo.accent)
                        Divider().frame(height: 24)
                        VStatCell(value: "40+", label: "Call vet", valueColor: Color.red.opacity(0.7))
                    }
                    .padding(.top, 6)
                }
                .padding(16)
                .background(Halo.bg3)
                .cornerRadius(14)
                .shadow(color: Halo.dark.opacity(0.08), radius: 16, y: 4)
                .padding(.horizontal, 14)
                .padding(.bottom, 10)

                // ── Recent readings ──
                if !readings.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("RECENT READINGS")
                            .font(Halo.sans(9, weight: .semibold))
                            .tracking(1.4)
                            .foregroundColor(Halo.light)
                            .padding(.horizontal, 16)

                        ForEach(readings) { r in
                            HStack(spacing: 10) {
                                Circle().fill(r.statusColor).frame(width: 7, height: 7)
                                Text(r.time)
                                    .font(Halo.sans(12))
                                    .foregroundColor(Halo.mid)
                                Spacer()
                                Text("\(r.bpm) bpm")
                                    .font(Halo.sans(13, weight: .semibold))
                                    .foregroundColor(Halo.dark)
                                Text(r.statusLabel)
                                    .font(Halo.sans(10))
                                    .foregroundColor(r.statusColor)
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 3)
                                    .background(r.statusColor.opacity(0.1))
                                    .cornerRadius(6)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Halo.bg3)
                            .cornerRadius(10)
                            .padding(.horizontal, 14)
                        }
                    }
                    .padding(.bottom, 10)
                }

                // ── Breathing bar chart ──
                VStack(alignment: .leading, spacing: 8) {
                    Text("Breathing · 6-week trend")
                        .font(Halo.sans(12, weight: .medium))
                        .foregroundColor(Halo.dark)
                    Text("Resting breaths per minute")
                        .font(Halo.sans(10))
                        .foregroundColor(Halo.light)
                        .padding(.bottom, 4)

                    HStack(alignment: .bottom, spacing: 6) {
                        ForEach(0..<6, id: \.self) { i in
                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(i == 5
                                          ? LinearGradient(colors: [Halo.rose2, Halo.accent], startPoint: .top, endPoint: .bottom)
                                          : LinearGradient(colors: [Halo.faint, Halo.faint.opacity(0.7)], startPoint: .top, endPoint: .bottom))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: barHeights[i] * 80)
                                    .shadow(color: i == 5 ? Halo.rose.opacity(0.25) : .clear, radius: 6, y: 3)
                                Text(barLabels[i])
                                    .font(Halo.sans(8))
                                    .foregroundColor(i == 5 ? Halo.dark : Halo.light)
                                    .fontWeight(i == 5 ? .semibold : .regular)
                            }
                        }
                    }
                    .frame(height: 100)
                }
                .padding(14)
                .background(Halo.bg3)
                .cornerRadius(14)
                .padding(.horizontal, 14)
                .padding(.bottom, 10)

                // ── Weight card ──
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("WEIGHT")
                                .font(Halo.sans(9, weight: .semibold))
                                .tracking(1.4)
                                .foregroundColor(Halo.light)
                            HStack(alignment: .firstTextBaseline, spacing: 2) {
                                Text("4.2")
                                    .font(Halo.sans(26, weight: .light))
                                    .foregroundColor(Halo.dark)
                                Text("kg")
                                    .font(Halo.sans(13))
                                    .foregroundColor(Halo.light)
                            }
                            Text("▲ 0.1 kg since last month · Stable")
                                .font(Halo.sans(10))
                                .foregroundColor(Color(hex: "#7a9a6a"))
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            ForEach(["3M","6M","1Y"], id: \.self) { p in
                                Text(p)
                                    .font(Halo.sans(9, weight: .medium))
                                    .foregroundColor(p == "3M" ? Halo.dark : Halo.light)
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 4)
                                    .background(p == "3M" ? Halo.faint : Color.clear)
                                    .cornerRadius(4)
                            }
                        }
                    }

                    WeightLineChart()
                        .frame(height: 70)
                }
                .padding(14)
                .background(Halo.bg3)
                .cornerRadius(14)
                .padding(.horizontal, 14)
                .padding(.bottom, 10)

                Spacer(minLength: 120)
            }
        }
        .background(Halo.bg)

        if showCaveat {
            VitalsCaveatOverlay(isPresented: $showCaveat)
        }
        } // end ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: — Computed result props

    var resultBpm: Int { tapCount * 4 }

    var resultColor: Color {
        resultBpm <= 30 ? Color(hex: "#7a9a6a") : resultBpm <= 40 ? Halo.accent : Color.red.opacity(0.8)
    }

    var resultMessage: String {
        if resultBpm <= 30 { return "Normal — \(resultBpm) breaths/min ✓" }
        if resultBpm <= 40 { return "Slightly elevated — \(resultBpm) breaths/min" }
        return "Above range — \(resultBpm) breaths/min"
    }

    var resultGuidance: String {
        if resultBpm <= 30 { return "This is within the healthy range for a resting cat." }
        if resultBpm <= 40 { return "Monitor closely. Re-check after 30 minutes of rest. If it stays elevated, contact your vet." }
        return "Contact your vet or emergency clinic promptly. Do not wait if your pet seems distressed."
    }

    // MARK: — Actions

    func handleTap() {
        switch phase {
        case .idle:
            phase = .counting
            tapCount = 1
            secondsLeft = 15
            triggerPulse()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
                secondsLeft -= 1
                if secondsLeft <= 0 { t.invalidate(); finish() }
            }
        case .counting:
            tapCount += 1
            triggerPulse()
        case .done:
            break
        }
    }

    func triggerPulse() {
        withAnimation(.easeOut(duration: 0.12)) { pulseScale = 0.94 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.55)) { pulseScale = 1.0 }
        }
    }

    func finish() {
        phase = .done
        let bpm = tapCount * 4
        let tf = DateFormatter()
        tf.timeStyle = .short
        tf.dateStyle = .none
        readings.insert(BreathingReading(bpm: bpm, time: "Today \(tf.string(from: Date()))"), at: 0)
        if readings.count > 5 { readings = Array(readings.prefix(5)) }
    }

    func reset() {
        timer?.invalidate()
        phase = .idle; tapCount = 0; secondsLeft = 15
    }

    func formatTime(_ s: Int) -> String { "0:\(String(format: "%02d", s))" }
}

// MARK: — Caveat overlay

struct VitalsCaveatOverlay: View {
    @Binding var isPresented: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.3)
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

                Text("About this tool")
                    .font(Halo.serif(22))
                    .foregroundColor(Halo.dark)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 4)

                Text("How to count · Thresholds · Important information")
                    .font(Halo.sans(11))
                    .foregroundColor(Halo.mid)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 18)

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        CaveatBlock(
                            icon: "moon.zzz",
                            title: "Before you count",
                            text: "Your pet must be completely at rest — lying still, ideally asleep. Do not count while they are purring (this changes chest movement), grooming, eating, standing, playing, or stressed."
                        )
                        CaveatBlock(
                            icon: "hand.tap",
                            title: "The 15-second method",
                            text: "Count each visible chest rise for exactly 15 seconds, then multiply by 4. This is the home monitoring method recommended by veterinary cardiologists for cats with HCM."
                        )
                        CaveatBlock(
                            icon: "heart",
                            title: "What the numbers mean",
                            text: "≤30 bpm — Normal resting rate for an adult cat.\n30–40 bpm — Mildly elevated. Re-check after 30 min of full rest. Contact your vet if it remains elevated.\n40+ bpm — Significantly elevated. Contact your vet or emergency clinic promptly."
                        )
                        CaveatBlock(
                            icon: "exclamationmark.shield",
                            title: "Important disclaimer",
                            text: "Halo is a home monitoring companion, not a diagnostic or medical device. These thresholds are general guidelines for cats with known cardiac conditions — individual baselines vary. Always follow your veterinary cardiologist's specific guidance for your pet. In any emergency, call your vet immediately."
                        )
                        HStack(spacing: 4) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 9))
                                .foregroundColor(Halo.light)
                            Text("Cornell Feline Health Center · ACVIM Consensus Guidelines (2020) · International Cat Care (icatcare.org)")
                                .font(Halo.sans(9))
                                .foregroundColor(Halo.light)
                                .lineSpacing(3)
                        }
                        .padding(.top, 4)
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 20)
                }
                .frame(maxHeight: .infinity)
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.65)
            .background(Halo.bg)
            .cornerRadius(22, corners: [.topLeft, .topRight])
        }
        .ignoresSafeArea()
        .transition(.move(edge: .bottom))
    }
}

struct CaveatBlock: View {
    let icon: String
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11))
                    .foregroundColor(Halo.rose2)
                Text(title.uppercased())
                    .font(Halo.sans(9, weight: .semibold))
                    .tracking(1.4)
                    .foregroundColor(Halo.mid)
            }
            Text(text)
                .font(Halo.sans(12))
                .foregroundColor(Halo.dark)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(Halo.bg3)
        .cornerRadius(12)
    }
}

// MARK: — Subviews

struct VStatCell: View {
    let value: String
    let label: String
    var valueColor: Color = Halo.dark
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(Halo.sans(14, weight: .semibold))
                .foregroundColor(valueColor)
            Text(label)
                .font(Halo.sans(8))
                .foregroundColor(Halo.light)
        }
        .frame(maxWidth: .infinity)
    }
}

struct WeightLineChart: View {
    let points: [CGFloat] = [3.95, 4.0, 4.05, 4.1, 4.1, 4.15, 4.2]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let minV: CGFloat = 3.8
            let maxV: CGFloat = 4.4
            let xs = points.enumerated().map { i, _ in CGFloat(i) / CGFloat(points.count - 1) * w }
            let ys = points.map { h - (($0 - minV) / (maxV - minV)) * h * 0.8 - h * 0.1 }

            Path { p in
                p.move(to: CGPoint(x: xs[0], y: h))
                for i in 0..<xs.count { p.addLine(to: CGPoint(x: xs[i], y: ys[i])) }
                p.addLine(to: CGPoint(x: xs.last!, y: h))
                p.closeSubpath()
            }
            .fill(LinearGradient(colors: [Halo.rose.opacity(0.15), Halo.rose.opacity(0)], startPoint: .top, endPoint: .bottom))

            Path { p in
                p.move(to: CGPoint(x: xs[0], y: ys[0]))
                for i in 1..<xs.count { p.addLine(to: CGPoint(x: xs[i], y: ys[i])) }
            }
            .stroke(Halo.rose2, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))

            Circle()
                .fill(Halo.rose2)
                .frame(width: 6, height: 6)
                .position(x: xs.last!, y: ys.last!)
        }
    }
}

#Preview { VitalsView() }
