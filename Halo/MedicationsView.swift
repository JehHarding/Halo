import SwiftUI

struct Medication: Identifiable {
    let id = UUID()
    let name: String
    let dose: String
    let detail: String
    var taken: Bool
    let info: MedInfo
}

struct MedInfo {
    let purpose: String
    let risks: String
    let howToGive: String
    let timing: String
}

let medInfoMap: [String: MedInfo] = [
    "Pimobendan": MedInfo(
        purpose: "Strengthens the heart muscle and helps it pump more efficiently. One of the most important HCM medications.",
        risks: "Rare: decreased appetite, vomiting, or lethargy. Do not skip or double-dose.",
        howToGive: "Give on an empty stomach (30–60 min before food) for best absorption. Can be hidden in a small treat.",
        timing: "Must be given at consistent intervals — ideally 12 hours apart."
    ),
    "Furosemide": MedInfo(
        purpose: "A diuretic (water tablet) that reduces fluid build-up in the lungs, which HCM cats are prone to.",
        risks: "Increases urination and thirst — always ensure fresh water is available. Watch for dehydration signs: sunken eyes, dry gums.",
        howToGive: "Can be given with food. Crush and mix into a small amount of wet food if needed.",
        timing: "Given morning and evening to maintain steady fluid balance."
    ),
    "Taurine": MedInfo(
        purpose: "An amino acid that supports heart muscle function. Taurine deficiency can worsen cardiomyopathy.",
        risks: "Very well tolerated. No known significant side effects at this dose.",
        howToGive: "Easy to mix into wet food or give in a small piece of treat. Tasteless.",
        timing: "Given twice daily with meals."
    ),
    "Atenolol": MedInfo(
        purpose: "A beta-blocker that slows the heart rate and reduces the workload on the heart. Helps with HCM-related arrhythmias.",
        risks: "Can cause lethargy or reduced exercise tolerance. Do NOT stop suddenly — this must be tapered under vet guidance.",
        howToGive: "Give with a small amount of food to reduce nausea. Handle gently — stress raises heart rate.",
        timing: "Critical: do not skip this dose. Evening timing is important for overnight heart rate control."
    ),
]

struct MedicationsView: View {
    @State private var morning: [Medication] = [
        Medication(name: "Pimobendan", dose: "1.25mg", detail: "given 8:04am",  taken: true,  info: medInfoMap["Pimobendan"]!),
        Medication(name: "Furosemide", dose: "10mg",   detail: "given 8:04am",  taken: true,  info: medInfoMap["Furosemide"]!),
        Medication(name: "Taurine",    dose: "250mg",  detail: "given 8:04am",  taken: true,  info: medInfoMap["Taurine"]!),
    ]
    @State private var evening: [Medication] = [
        Medication(name: "Furosemide", dose: "10mg",   detail: "evening dose",  taken: false, info: medInfoMap["Furosemide"]!),
        Medication(name: "Atenolol",   dose: "6.25mg", detail: "evening dose",  taken: false, info: medInfoMap["Atenolol"]!),
        Medication(name: "Taurine",    dose: "250mg",  detail: "evening dose",  taken: false, info: medInfoMap["Taurine"]!),
    ]
    @State private var selectedMed: Medication?

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Medications")
                            .font(Halo.serif(26, weight: .light))
                            .foregroundColor(Halo.dark)
                        Text("Angel · \(todayString())")
                            .font(Halo.sans(10))
                            .foregroundColor(Halo.light)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 14)

                    MedTimeHeader(dot: Halo.rose2, label: "Morning · 8:00am · Done")
                    ForEach($morning) { $med in
                        MedRow(med: $med, dueTime: "Done") { selectedMed = med }
                    }

                    Rectangle()
                        .fill(Halo.faint.opacity(0.5))
                        .frame(height: 1)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)

                    MedTimeHeader(dot: Halo.faint, label: "Evening · 8:00pm")
                    ForEach($evening) { $med in
                        MedRow(med: $med, dueTime: "8pm") { selectedMed = med }
                    }

                    Spacer(minLength: 80)
                }
            }
            .background(Halo.bg)

            if let med = selectedMed {
                MedDetailOverlay(med: med, isPresented: Binding(
                    get: { selectedMed != nil },
                    set: { if !$0 { selectedMed = nil } }
                ))
            }
        }
    }

    func todayString() -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE d MMMM"
        return f.string(from: Date())
    }
}

// MARK: — Med detail overlay

struct MedDetailOverlay: View {
    let med: Medication
    @Binding var isPresented: Bool

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

                // Med name + dose
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(med.name)
                        .font(Halo.serif(26))
                        .foregroundColor(Halo.dark)
                    Text(med.dose)
                        .font(Halo.sans(14, weight: .semibold))
                        .foregroundColor(Halo.accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Halo.roseL)
                        .cornerRadius(6)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 18)

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        MedInfoBlock(icon: "heart.fill",        title: "What it does",        text: med.info.purpose)
                        MedInfoBlock(icon: "exclamationmark.triangle", title: "Things to watch for", text: med.info.risks)
                        MedInfoBlock(icon: "hand.raised",       title: "How to give",         text: med.info.howToGive)
                        MedInfoBlock(icon: "clock",             title: "Timing",              text: med.info.timing)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .frame(maxHeight: 340)
            }
            .background(Halo.bg)
            .cornerRadius(22, corners: [.topLeft, .topRight])
        }
        .ignoresSafeArea()
        .transition(.move(edge: .bottom))
    }
}

struct MedInfoBlock: View {
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
                .font(Halo.sans(13))
                .foregroundColor(Halo.dark)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(Halo.bg3)
        .cornerRadius(12)
    }
}

// MARK: — Row + header

struct MedTimeHeader: View {
    let dot: Color
    let label: String
    var body: some View {
        HStack(spacing: 8) {
            Circle().fill(dot).frame(width: 8, height: 8)
            Text(label)
                .font(Halo.sans(10, weight: .semibold))
                .tracking(0.6)
                .foregroundColor(Halo.mid)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 6)
    }
}

struct MedRow: View {
    @Binding var med: Medication
    let dueTime: String
    let onTap: () -> Void

    @State private var pressed = false

    var body: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.25)) { med.taken.toggle() }
            } label: {
                ZStack {
                    Circle()
                        .stroke(med.taken ? Halo.rose2 : Halo.border, lineWidth: 1.5)
                        .frame(width: 28, height: 28)
                    if med.taken {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Halo.rose2)
                    }
                }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(med.name)
                    .font(Halo.sans(14, weight: .medium))
                    .foregroundColor(med.taken ? Halo.light : Halo.dark)
                    .strikethrough(med.taken, color: Halo.light.opacity(0.6))
                Text("\(med.dose) · \(med.detail)")
                    .font(Halo.sans(11))
                    .foregroundColor(Halo.light)
            }

            Spacer()

            Text(dueTime)
                .font(Halo.sans(9, weight: med.taken ? .regular : .semibold))
                .foregroundColor(med.taken ? Halo.light : Halo.rose2)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(med.taken ? Color.clear : Halo.roseL)
                .cornerRadius(10)

            Image(systemName: "info.circle")
                .font(.system(size: 14))
                .foregroundColor(Halo.faint)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Halo.bg3
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(pressed ? Halo.rose2 : Color.clear, lineWidth: 1.5))
        )
        .cornerRadius(12)
        .shadow(color: pressed ? Halo.rose.opacity(0.2) : .clear, radius: 12, y: 3)
        .scaleEffect(pressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: pressed)
        .padding(.horizontal, 14)
        .padding(.bottom, 2)
        .onTapGesture { onTap() }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded { _ in pressed = false }
        )
    }
}

#Preview { MedicationsView() }
