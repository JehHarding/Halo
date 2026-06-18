import SwiftUI

struct OnboardingView: View {
    @Environment(AppState.self) var state
    @State private var step = 0

    @State private var petName = ""
    @State private var petType = "Cat"
    @State private var breed = ""
    @State private var meds: [String] = ["Pimobendan 1.25mg", "Furosemide 10mg", "Taurine 250mg", "Atenolol 6.25mg"]
    @State private var newMedName = ""
    @State private var newMedDose = ""
    @State private var morningDate = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
    @State private var eveningDate = Calendar.current.date(from: DateComponents(hour: 18, minute: 0)) ?? Date()

    let petTypes = ["Cat", "Dog", "Other"]
    let totalSteps = 6

    var body: some View {
        ZStack {
            Halo.bg.ignoresSafeArea()
            VStack(spacing: 0) {
                // Top nav
                HStack {
                    if step > 0 {
                        Button {
                            withAnimation { step -= 1 }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 13))
                                Text("Back")
                                    .font(Halo.sans(12))
                            }
                            .foregroundColor(Halo.mid)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Spacer().frame(width: 60)
                    }
                    Spacer()
                    Button {
                        withAnimation { state.screen = .dashboard }
                    } label: {
                        Text("Skip")
                            .font(Halo.sans(11))
                            .foregroundColor(Halo.light)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 14)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(Halo.border).frame(height: 2)
                        Rectangle()
                            .fill(Halo.dark)
                            .frame(width: geo.size.width * CGFloat(step + 1) / CGFloat(totalSteps), height: 2)
                            .animation(.easeInOut(duration: 0.3), value: step)
                    }
                }
                .frame(height: 2)
                .padding(.horizontal, 20)
                .padding(.bottom, 28)

                // Step label
                Text("Step \(step + 1) of \(totalSteps)")
                    .font(Halo.sans(10, weight: .semibold))
                    .tracking(1.8)
                    .textCase(.uppercase)
                    .foregroundColor(Halo.light)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 22)
                    .padding(.bottom, 12)

                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        switch step {
                        case 0: OBStep1(petName: $petName)
                        case 1: OBStep2(petType: $petType, breed: $breed, petTypes: petTypes)
                        case 2: OBStep3()
                        case 3: OBStep4(meds: $meds, newMedName: $newMedName, newMedDose: $newMedDose)
                        case 4: OBStep5(morningDate: $morningDate, eveningDate: $eveningDate)
                        default: OBStep6()
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 20)
                }

                Spacer(minLength: 0)

                // Continue button
                OBContinueButton(
                    label: step == totalSteps - 1 ? "LET'S GO" : "CONTINUE",
                    enabled: !(step == 0 && petName.isEmpty)
                ) {
                    withAnimation {
                        if step < totalSteps - 1 {
                            step += 1
                        } else {
                            if !petName.isEmpty { state.petName = petName }
                            state.screen = .dashboard
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: — Step 1: Pet name

struct OBStep1: View {
    @Binding var petName: String
    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("What's your pet's")
                    .font(Halo.serif(30))
                    .foregroundColor(Halo.dark)
                Text("name?")
                    .font(Halo.serif(30))
                    .italic()
                    .foregroundColor(Halo.rose2)
            }
            Text("You can change this later in settings.")
                .font(Halo.sans(13))
                .foregroundColor(Halo.mid)
                .padding(.bottom, 4)

            TextField("e.g. Angel", text: $petName)
                .font(Halo.serif(22))
                .foregroundColor(Halo.dark)
                .focused($focused)
                .padding(14)
                .background(Halo.bg3)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(petName.isEmpty ? Halo.border : Halo.dark, lineWidth: 1.5))
                .cornerRadius(10)
                .submitLabel(.done)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                focused = true
            }
        }
    }
}

// MARK: — Shared continue button

struct OBContinueButton: View {
    let label: String
    let enabled: Bool
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Halo.sans(12, weight: .semibold))
                .tracking(2.0)
                .foregroundColor(Color(hex: "#faf7f2"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(enabled ? (pressed ? Halo.dark.opacity(0.82) : Halo.dark) : Halo.faint)
                .cornerRadius(2)
                .scaleEffect(pressed ? 0.985 : 1.0)
                .animation(.easeInOut(duration: 0.12), value: pressed)
        }
        .buttonStyle(.plain)
        .hoverEffect(.highlight)
        .disabled(!enabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in if enabled { pressed = true } }
                .onEnded   { _ in pressed = false }
        )
    }
}

// MARK: — Step 2: Type + breed

struct OBStep2: View {
    @Binding var petType: String
    @Binding var breed: String
    let petTypes: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("What kind of")
                    .font(Halo.serif(30))
                    .foregroundColor(Halo.dark)
                Text("pet are they?")
                    .font(Halo.serif(30))
                    .italic()
                    .foregroundColor(Halo.rose2)
            }
            HStack(spacing: 8) {
                ForEach(petTypes, id: \.self) { type in
                    OBPetTypeButton(type: type, isSelected: petType == type, icon: iconFor(type)) {
                        withAnimation(.spring(response: 0.22)) { petType = type }
                    }
                }
            }
            .padding(.bottom, 4)

            Text("Breed")
                .font(Halo.sans(11, weight: .semibold))
                .tracking(1.4)
                .textCase(.uppercase)
                .foregroundColor(Halo.light)
            TextField("e.g. British Shorthair", text: $breed)
                .font(Halo.sans(15))
                .foregroundColor(Halo.dark)
                .padding(14)
                .background(Halo.bg3)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Halo.border, lineWidth: 1.5))
                .cornerRadius(10)
        }
    }

    func iconFor(_ type: String) -> String {
        switch type {
        case "Cat": return "🐱"
        case "Dog": return "🐶"
        default: return "🐾"
        }
    }
}

struct OBPetTypeButton: View {
    let type: String
    let isSelected: Bool
    let icon: String
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(icon).font(.system(size: 22))
                Text(type)
                    .font(Halo.sans(10, weight: .semibold))
                    .tracking(0.5)
                    .foregroundColor(isSelected ? Color(hex: "#faf7f2") : Halo.dark)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(isSelected ? Halo.dark : (pressed ? Halo.bg2 : Halo.bg3))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Halo.dark : Halo.border, lineWidth: 1.5))
            .scaleEffect(pressed ? 0.955 : (isSelected ? 1.02 : 1.0))
            .shadow(color: isSelected ? Halo.dark.opacity(0.2) : .clear, radius: 8, y: 3)
            .animation(.spring(response: 0.22, dampingFraction: 0.65), value: isSelected)
            .animation(.easeInOut(duration: 0.1), value: pressed)
        }
        .buttonStyle(.plain)
        .hoverEffect(.highlight)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded   { _ in pressed = false }
        )
    }
}

// MARK: — Step 3: Photo

struct OBStep3: View {
    @State private var selectedSource: String? = nil
    @State private var circlePulsed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Add a photo of")
                    .font(Halo.serif(30))
                    .foregroundColor(Halo.dark)
                Text("your pet")
                    .font(Halo.serif(30))
                    .italic()
                    .foregroundColor(Halo.rose2)
            }
            Text("A face photo works best for the home screen.")
                .font(Halo.sans(13))
                .foregroundColor(Halo.mid)

            // Tappable upload circle
            Button {
                withAnimation(.spring(response: 0.25)) {
                    selectedSource = selectedSource == nil ? "picker" : nil
                    circlePulsed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { circlePulsed = false }
            } label: {
                ZStack {
                    Circle()
                        .fill(selectedSource != nil ? Halo.roseL : Halo.bg3)
                        .frame(width: 110, height: 110)
                    Circle()
                        .strokeBorder(
                            selectedSource != nil ? Halo.rose2 : Halo.border,
                            style: StrokeStyle(lineWidth: 2, dash: selectedSource != nil ? [] : [6, 4])
                        )
                        .frame(width: 110, height: 110)
                    VStack(spacing: 6) {
                        Image(systemName: "camera")
                            .font(.system(size: 22))
                            .foregroundColor(selectedSource != nil ? Halo.rose2 : Halo.light)
                        Text("ADD PHOTO")
                            .font(Halo.sans(8, weight: .semibold))
                            .tracking(1.2)
                            .foregroundColor(selectedSource != nil ? Halo.rose2 : Halo.light)
                    }
                }
                .scaleEffect(circlePulsed ? 0.94 : 1.0)
                .shadow(color: selectedSource != nil ? Halo.rose.opacity(0.25) : .clear, radius: 14)
                .animation(.easeInOut(duration: 0.15), value: circlePulsed)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .padding(.top, 8)

            // Source buttons — appear animated
            HStack(spacing: 10) {
                OBPhotoBtn(label: "Camera", icon: "camera.fill",
                           isActive: selectedSource == "camera") {
                    withAnimation { selectedSource = "camera" }
                }
                OBPhotoBtn(label: "Photo Library", icon: "photo.on.rectangle",
                           isActive: selectedSource == "library") {
                    withAnimation { selectedSource = "library" }
                }
            }
            .opacity(selectedSource != nil ? 1 : 0.6)

            if let src = selectedSource, src != "picker" {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#7a9a6a"))
                    Text(src == "camera" ? "Camera selected — tap Continue" : "Library selected — tap Continue")
                        .font(Halo.sans(11))
                        .foregroundColor(Halo.mid)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

struct OBPhotoBtn: View {
    let label: String
    let icon: String
    let isActive: Bool
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(isActive ? Halo.dark : Halo.mid)
                Text(label.uppercased())
                    .font(Halo.sans(10, weight: .semibold))
                    .tracking(0.8)
                    .foregroundColor(isActive ? Halo.dark : Halo.mid)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(isActive ? Halo.roseL : (pressed ? Halo.bg2 : Halo.bg3))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(isActive ? Halo.rose2 : Halo.border, lineWidth: isActive ? 1.5 : 1))
            .scaleEffect(pressed ? 0.96 : 1.0)
            .shadow(color: isActive ? Halo.rose.opacity(0.2) : .clear, radius: 8, y: 2)
            .animation(.easeInOut(duration: 0.12), value: pressed)
            .animation(.easeInOut(duration: 0.15), value: isActive)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded   { _ in pressed = false }
        )
    }
}

// MARK: — Step 4: Medications

struct OBStep4: View {
    @Binding var meds: [String]
    @Binding var newMedName: String
    @Binding var newMedDose: String
    @FocusState private var focusedField: OBMedField?

    enum OBMedField { case name, dose }

    var canAdd: Bool { !newMedName.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("What medications")
                    .font(Halo.serif(30))
                    .foregroundColor(Halo.dark)
                Text("do they take?")
                    .font(Halo.serif(30))
                    .italic()
                    .foregroundColor(Halo.rose2)
            }
            Text("You can edit these anytime.")
                .font(Halo.sans(13))
                .foregroundColor(Halo.mid)

            ForEach(meds.indices, id: \.self) { idx in
                HStack(spacing: 10) {
                    Circle().fill(Halo.rose2).frame(width: 7, height: 7)
                    Text(meds[idx])
                        .font(Halo.sans(13, weight: .medium))
                        .foregroundColor(Halo.dark)
                    Spacer()
                    Button {
                        let i = idx
                        withAnimation { meds.remove(at: i) }
                    } label: {
                        Image(systemName: "minus.circle")
                            .foregroundColor(Halo.light)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(.plain)
                }
                .padding(12)
                .background(Halo.bg3)
                .cornerRadius(10)
                .shadow(color: Halo.dark.opacity(0.05), radius: 8, y: 2)
            }

            // Add row — name + dose + plus
            VStack(spacing: 0) {
                Text("ADD MEDICATION")
                    .font(Halo.sans(8, weight: .semibold))
                    .tracking(1.4)
                    .foregroundColor(Halo.light)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.top, 10)
                    .padding(.bottom, 6)

                HStack(spacing: 8) {
                    TextField("Name (e.g. Furosemide)", text: $newMedName)
                        .font(Halo.sans(13))
                        .foregroundColor(Halo.dark)
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .dose }
                        .frame(maxWidth: .infinity)

                    Rectangle()
                        .fill(Halo.border)
                        .frame(width: 1, height: 18)

                    TextField("Dose", text: $newMedDose)
                        .font(Halo.sans(13))
                        .foregroundColor(Halo.dark)
                        .focused($focusedField, equals: .dose)
                        .submitLabel(.done)
                        .onSubmit { addMed() }
                        .frame(width: 72)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 10)

                Divider().padding(.horizontal, 12)

                Button(action: addMed) {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(canAdd ? Halo.dark : Halo.faint)
                                .frame(width: 26, height: 26)
                            Image(systemName: "plus")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(hex: "#faf7f2"))
                        }
                        Text(canAdd ? "Add \(newMedName.trimmingCharacters(in: .whitespaces))" : "Enter a name above")
                            .font(Halo.sans(12, weight: canAdd ? .medium : .regular))
                            .foregroundColor(canAdd ? Halo.dark : Halo.light)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
                .disabled(!canAdd)
            }
            .background(Halo.bg3)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(focusedField != nil ? Halo.rose2.opacity(0.4) : Halo.border, lineWidth: 1.5)
            )
            .shadow(color: Halo.dark.opacity(0.05), radius: 10, y: 3)
        }
    }

    func addMed() {
        let name = newMedName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        let dose = newMedDose.trimmingCharacters(in: .whitespaces)
        meds.append(dose.isEmpty ? name : "\(name) \(dose)")
        newMedName = ""; newMedDose = ""
        focusedField = nil
    }
}

// MARK: — Step 5: Medication times

struct OBStep5: View {
    @Binding var morningDate: Date
    @Binding var eveningDate: Date
    @State private var editingMorning = false
    @State private var editingEvening = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("When do they")
                    .font(Halo.serif(30))
                    .foregroundColor(Halo.dark)
                Text("take their meds?")
                    .font(Halo.serif(30))
                    .italic()
                    .foregroundColor(Halo.rose2)
            }
            Text("We'll remind you at these times each day.")
                .font(Halo.sans(13))
                .foregroundColor(Halo.mid)
                .padding(.bottom, 4)

            OBTimeCard(
                label: "Morning dose",
                date: morningDate,
                isEditing: editingMorning
            ) {
                withAnimation { editingMorning.toggle(); editingEvening = false }
            } picker: {
                DatePicker("", selection: $morningDate, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
            }

            OBTimeCard(
                label: "Evening dose",
                date: eveningDate,
                isEditing: editingEvening
            ) {
                withAnimation { editingEvening.toggle(); editingMorning = false }
            } picker: {
                DatePicker("", selection: $eveningDate, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct OBTimeCard<Picker: View>: View {
    let label: String
    let date: Date
    let isEditing: Bool
    let onTap: () -> Void
    @ViewBuilder let picker: () -> Picker

    var formattedTime: String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(label.uppercased())
                            .font(Halo.sans(9, weight: .semibold))
                            .tracking(1.6)
                            .foregroundColor(Halo.light)
                        Text(formattedTime)
                            .font(Halo.serif(38, weight: .light))
                            .foregroundColor(Halo.dark)
                    }
                    Spacer()
                    Image(systemName: isEditing ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(Halo.light)
                }
                .padding(16)
            }
            .buttonStyle(.plain)

            if isEditing {
                Divider().padding(.horizontal, 16)
                picker()
                    .padding(.vertical, 8)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Halo.bg3)
        .cornerRadius(12)
        .shadow(color: Halo.dark.opacity(isEditing ? 0.1 : 0.06), radius: isEditing ? 18 : 12, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isEditing ? Halo.rose2.opacity(0.4) : Color.clear, lineWidth: 1.5)
        )
    }
}

// MARK: — Step 6: All set

struct OBStep6: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("You're all set")
                    .font(Halo.serif(30))
                    .foregroundColor(Halo.dark)
                Text("for Angel")
                    .font(Halo.serif(30))
                    .italic()
                    .foregroundColor(Halo.rose2)
            }
            Text("Enable notifications on Halo. It can remind you about medications, flag changes in breathing, and keep you informed about Angel's health.")
                .font(Halo.sans(14))
                .foregroundColor(Halo.mid)
                .lineSpacing(4)
                .padding(.bottom, 8)

            // Notification preview card
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Halo.dark)
                            .frame(width: 28, height: 28)
                        Ellipse()
                            .stroke(Color(hex: "#f5eae4"), lineWidth: 1.4)
                            .frame(width: 18, height: 7)
                    }
                    Text("HALO")
                        .font(Halo.sans(11, weight: .semibold))
                        .tracking(1.6)
                        .foregroundColor(Halo.dark)
                    Spacer()
                    Text("now")
                        .font(Halo.sans(10))
                        .foregroundColor(Halo.light)
                }
                Text("Please enable notifications by clicking below")
                    .font(Halo.sans(13, weight: .medium))
                    .foregroundColor(Halo.dark)
                Text("Halo will remind you about Angel's medications and alert you to any changes.")
                    .font(Halo.sans(12))
                    .foregroundColor(Halo.mid)
                    .lineSpacing(3)
                Divider()
                HStack(spacing: 0) {
                    // "Later" — quiet, no animation
                    Text("Later")
                        .font(Halo.sans(12))
                        .foregroundColor(Halo.light)
                        .frame(maxWidth: .infinity)

                    Divider().frame(height: 20)

                    // "Enable" — static soft glow only
                    ZStack {
                        Circle()
                            .fill(Halo.roseL)
                            .frame(width: 72, height: 72)
                            .blur(radius: 16)
                        Text("Enable")
                            .font(Halo.sans(13, weight: .semibold))
                            .foregroundColor(Halo.dark)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }
            }
            .padding(16)
            .background(Halo.bg3)
            .cornerRadius(16)
            .shadow(color: Halo.rose.opacity(0.14), radius: 22, y: 8)
            .shadow(color: Halo.dark.opacity(0.06), radius: 8, y: 2)
        }
    }
}

#Preview {
    OnboardingView().environment(AppState())
}
