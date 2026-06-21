import SwiftUI

struct CarersPackView: View {
    @State private var selectedTab = 0
    @State private var showShare = false
    private let tabs = ["Medications", "Contacts", "Feeding"]

    var body: some View {
        ZStack {
            Halo.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Carer's Pack")
                            .font(Halo.serif(28, weight: .light))
                            .foregroundColor(Halo.dark)
                        Text("Angel · share with your carer")
                            .font(Halo.sans(11))
                            .foregroundColor(Halo.light)
                    }
                    Spacer()
                    // Share button
                    Button { withAnimation { showShare = true } } label: {
                        ZStack {
                            Circle()
                                .fill(Halo.bg3)
                                .frame(width: 36, height: 36)
                                .shadow(color: Halo.dark.opacity(0.1), radius: 8, y: 2)
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Halo.dark)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 16)

                // Tab bar
                HStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { i in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) { selectedTab = i }
                        } label: {
                            VStack(spacing: 6) {
                                Text(tabs[i])
                                    .font(Halo.sans(12, weight: selectedTab == i ? .semibold : .regular))
                                    .foregroundColor(selectedTab == i ? Halo.dark : Halo.light)
                                Rectangle()
                                    .fill(selectedTab == i ? Halo.rose2 : Color.clear)
                                    .frame(height: 2)
                                    .cornerRadius(1)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)

                Rectangle()
                    .fill(Halo.border)
                    .frame(height: 1)

                Group {
                    switch selectedTab {
                    case 0: PackMedsPanel()
                    case 1: PackContactsPanel()
                    default: PackFeedingPanel()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            if showShare {
                PackShareOverlay(isPresented: $showShare)
            }
        }
    }
}

// MARK: — Meds panel

struct PackMedsPanel: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                PackSectionLabel(text: "MORNING — 8:00 AM")
                PackMedCard(name: "Pimobendan",  dose: "1.25 mg", note: "Give 30–60 min before food on an empty stomach", icon: "heart.fill",   colour: Halo.rose2)
                PackMedCard(name: "Furosemide",  dose: "10 mg",   note: "Watch for increased thirst — always provide fresh water", icon: "drop.fill",   colour: Halo.accent)
                PackMedCard(name: "Taurine",     dose: "250 mg",  note: "Can be mixed into food", icon: "leaf.fill",   colour: Color(hex: "#8aaa7a"))

                PackSectionLabel(text: "EVENING — 6:00 PM")
                PackMedCard(name: "Furosemide",  dose: "10 mg",   note: "Watch for increased thirst — always provide fresh water", icon: "drop.fill",   colour: Halo.accent)
                PackMedCard(name: "Atenolol",    dose: "6.25 mg", note: "Critical heart medication — do not skip or delay", icon: "bolt.heart.fill", colour: Color(hex: "#b08090"))
                PackMedCard(name: "Taurine",     dose: "250 mg",  note: "Can be mixed into food", icon: "leaf.fill",   colour: Color(hex: "#8aaa7a"))

                // Alert note
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 13))
                        .foregroundColor(Halo.accent)
                    Text("Never skip a dose without calling the vet first. If Angel refuses food, contact the vet before giving Pimobendan.")
                        .font(Halo.sans(12))
                        .foregroundColor(Halo.mid)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .background(Halo.roseL)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Halo.rose2.opacity(0.3), lineWidth: 1))

                Spacer(minLength: 80)
            }
            .padding(18)
        }
    }
}

// MARK: — Contacts panel

struct PackContactsPanel: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                PackSectionLabel(text: "OWNERS")
                PackContactCard(name: "Jeh Harding",     role: "Owner",                   phone: "+44 7700 900 111", icon: "person.fill",       colour: Halo.rose2)
                PackContactCard(name: "Theo",            role: "Owner's husband",          phone: "+44 7700 900 222", icon: "person.fill",       colour: Halo.rose2)
                PackContactCard(name: "Jessica Newton",  role: "Owner's sister",           phone: "+44 7700 900 333", icon: "person.fill",       colour: Halo.rose2)

                PackSectionLabel(text: "VETERINARY TEAM")
                PackContactCard(name: "Dr Nguyen",           role: "Cardiologist",     phone: "020 7946 0000", icon: "stethoscope",      colour: Halo.accent)
                PackContactCard(name: "Mayfair Vet Clinic",  role: "Primary vet",      phone: "020 7946 0001", icon: "cross.fill",       colour: Halo.accent)

                PackSectionLabel(text: "EMERGENCY")
                PackContactCard(name: "Animal Emergency",    role: "24hr emergency",   phone: "020 7946 9999", icon: "light.beacon.max.fill", colour: Color.red.opacity(0.7))

                // HCM note
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Halo.rose2)
                    Text("In an emergency, always tell the vet that Angel has HCM (hypertrophic cardiomyopathy). She is on Pimobendan, Furosemide, Atenolol, and Taurine.")
                        .font(Halo.sans(12))
                        .foregroundColor(Halo.mid)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .background(Halo.roseL)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Halo.rose2.opacity(0.3), lineWidth: 1))

                Spacer(minLength: 80)
            }
            .padding(18)
        }
    }
}

// MARK: — Feeding panel

struct PackFeedingPanel: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                PackSectionLabel(text: "DAILY SCHEDULE")
                PackFeedCard(time: "8:00 AM",  title: "Morning meal", note: "Royal Canin Cardiac — 50g with medications")
                PackFeedCard(time: "6:00 PM",  title: "Evening meal", note: "Royal Canin Cardiac — 50g with medications")
                PackFeedCard(time: "Always",   title: "Fresh water",  note: "Change daily. Angel drinks more than usual due to Furosemide — this is normal.")
                PackFeedCard(time: "Treats",   title: "Treats",       note: "Small amounts only. No salty treats. Dreamies occasionally are fine.")

                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Halo.accent)
                    Text("Pimobendan must be given 30–60 min before food. All other medications can be mixed into food or hidden in treats.")
                        .font(Halo.sans(12))
                        .foregroundColor(Halo.mid)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .background(Halo.bg2)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Halo.border, lineWidth: 1))

                Spacer(minLength: 80)
            }
            .padding(18)
        }
    }
}

// MARK: — Components

struct PackSectionLabel: View {
    let text: String
    var body: some View {
        Text(text)
            .font(Halo.sans(9, weight: .semibold))
            .tracking(1.8)
            .foregroundColor(Halo.light)
            .padding(.top, 10)
    }
}

struct PackMedCard: View {
    let name: String
    let dose: String
    let note: String
    let icon: String
    let colour: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(colour.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(colour)
            }
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(name)
                        .font(Halo.sans(14, weight: .semibold))
                        .foregroundColor(Halo.dark)
                    Spacer()
                    Text(dose)
                        .font(Halo.sans(11, weight: .semibold))
                        .foregroundColor(colour)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(colour.opacity(0.1))
                        .cornerRadius(6)
                }
                Text(note)
                    .font(Halo.sans(12))
                    .foregroundColor(Halo.mid)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .background(Halo.bg3)
        .cornerRadius(14)
        .shadow(color: colour.opacity(0.12), radius: 12, y: 3)
        .shadow(color: Halo.dark.opacity(0.04), radius: 4, y: 1)
    }
}

struct PackContactCard: View {
    let name: String
    let role: String
    let phone: String
    let icon: String
    let colour: Color

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(colour.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(colour)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(Halo.sans(14, weight: .semibold))
                    .foregroundColor(Halo.dark)
                Text(role)
                    .font(Halo.sans(11))
                    .foregroundColor(Halo.mid)
            }
            Spacer()
            if !phone.isEmpty {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(phone)
                        .font(Halo.sans(11, weight: .medium))
                        .foregroundColor(colour)
                    Image(systemName: "phone.fill")
                        .font(.system(size: 10))
                        .foregroundColor(colour.opacity(0.6))
                }
            }
        }
        .padding(14)
        .background(Halo.bg3)
        .cornerRadius(14)
        .shadow(color: colour.opacity(0.1), radius: 10, y: 3)
        .shadow(color: Halo.dark.opacity(0.04), radius: 3, y: 1)
    }
}

struct PackFeedCard: View {
    let time: String
    let title: String
    let note: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(time)
                .font(Halo.sans(9, weight: .semibold))
                .tracking(0.4)
                .foregroundColor(Halo.rose2)
                .frame(width: 48, alignment: .leading)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(Halo.sans(13, weight: .semibold))
                    .foregroundColor(Halo.dark)
                Text(note)
                    .font(Halo.sans(12))
                    .foregroundColor(Halo.mid)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .background(Halo.bg3)
        .cornerRadius(14)
        .shadow(color: Halo.dark.opacity(0.06), radius: 10, y: 3)
    }
}

// MARK: — Share overlay

struct PackShareOverlay: View {
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

                HStack {
                    Text("Share Care Guide")
                        .font(Halo.serif(22))
                        .foregroundColor(Halo.dark)
                    Spacer()
                    Button { withAnimation { isPresented = false } } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Halo.light)
                            .padding(8)
                            .background(Circle().fill(Halo.bg2))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 4)

                Text("Angel's full care guide — medications, contacts & feeding — ready to send.")
                    .font(Halo.sans(12))
                    .foregroundColor(Halo.mid)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                VStack(spacing: 10) {
                    ShareButton(
                        icon: "whatsapp",
                        systemIcon: "message.fill",
                        label: "WhatsApp",
                        bg: Color(hex: "#d4e8d4"),
                        fg: Color(hex: "#2a5a2a")
                    )
                    ShareButton(
                        icon: "envelope",
                        systemIcon: "envelope.fill",
                        label: "Email",
                        bg: Halo.roseL,
                        fg: Halo.dark
                    )
                    ShareButton(
                        icon: "doc",
                        systemIcon: "doc.fill",
                        label: "Save as PDF",
                        bg: Halo.bg2,
                        fg: Halo.dark
                    )
                }
                .padding(.horizontal, 18)

                // QR code
                VStack(spacing: 10) {
                    Text("OR SCAN TO OPEN ON ANOTHER DEVICE")
                        .font(Halo.sans(8, weight: .semibold))
                        .tracking(1.4)
                        .foregroundColor(Halo.light)
                    QRCodeView()
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Halo.border, lineWidth: 1))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 18)
                .padding(.bottom, 40)
            }
            .background(Halo.bg)
            .cornerRadius(22, corners: [.topLeft, .topRight])
        }
        .ignoresSafeArea()
        .transition(.move(edge: .bottom))
    }
}

struct ShareButton: View {
    let icon: String
    let systemIcon: String
    let label: String
    let bg: Color
    let fg: Color
    @State private var pressed = false

    var body: some View {
        Button {
            // Share action placeholder
        } label: {
            HStack(spacing: 12) {
                Image(systemName: systemIcon)
                    .font(.system(size: 18))
                    .foregroundColor(fg)
                    .frame(width: 24)
                Text(label)
                    .font(Halo.sans(14, weight: .medium))
                    .foregroundColor(fg)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11))
                    .foregroundColor(fg.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(bg)
            .cornerRadius(12)
            .scaleEffect(pressed ? 0.97 : 1.0)
            .shadow(color: fg.opacity(pressed ? 0.15 : 0), radius: 10, y: 3)
            .animation(.easeInOut(duration: 0.12), value: pressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded { _ in pressed = false }
        )
    }
}

struct QRCodeView: View {
    var body: some View {
        Canvas { ctx, size in
            let s = size.width / 10
            let dark = Color(hex: "#4a3828")
            func sq(_ x: Int, _ y: Int, _ w: Int = 1, _ h: Int = 1) {
                ctx.fill(Path(CGRect(x: CGFloat(x)*s, y: CGFloat(y)*s, width: CGFloat(w)*s, height: CGFloat(h)*s)), with: .color(dark))
            }
            // Corner squares
            sq(0,0,3,3); sq(1,1,1); ctx.fill(Path(CGRect(x: s, y: s, width: s, height: s)), with: .color(.white))
            sq(7,0,3,3); sq(8,1,1); ctx.fill(Path(CGRect(x: 8*s, y: s, width: s, height: s)), with: .color(.white))
            sq(0,7,3,3); sq(1,8,1); ctx.fill(Path(CGRect(x: s, y: 8*s, width: s, height: s)), with: .color(.white))
            // Data dots
            let dots = [(4,0),(5,0),(4,2),(6,2),(4,4),(5,4),(6,4),(7,4),(8,4),(9,4),(0,4),(2,4),(0,5),(2,5),(4,5),(6,5),(8,5),(4,6),(6,7),(8,7),(5,8),(7,8),(9,8),(6,9),(8,9)]
            for (x,y) in dots { sq(x,y) }
        }
        .frame(width: 100, height: 100)
    }
}

#Preview { CarersPackView() }
