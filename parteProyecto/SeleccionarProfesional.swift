import SwiftUI

// MARK: - VISTA PRINCIPAL
/// Vista `SeleccionarProfesional`: Muestra una lista de trabajadores disponibles.
/// Permite al usuario seleccionar uno y confirmar para navegar a la siguiente pantalla.
struct SeleccionarProfesional: View {
    // Variable de entorno para gestionar el botón de retroceso
    @Environment(\.dismiss) var dismiss
    // Estado que guarda qué trabajador está seleccionado (0, 1 o 2). Por defecto es el 2 (Marcos L.)
    @State private var selectedWorker: Int? = 2 // Por defecto el tercero como en tu Figma
    
    // MARK: - Cuerpo de la Vista Principal
    var body: some View {
        ZStack {
            // Fondo de pantalla completo
            Image("fondo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ==========================================
                // --- BARRA SUPERIOR UNIFICADA ---
                // ==========================================
                HStack {
                    // 1. Flecha Izquierda (Botón para volver atrás)
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                    }
                    Spacer()
                    
                    // 2. Iconos Derecha (Calendario y Perfil)
                    HStack(spacing: 20) {
                        Image(systemName: "calendar")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.figmaBlue)
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.figmaBlue)
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 80)
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity)
                .background(Color.figmaLightBlue)
                .ignoresSafeArea() // Sube el fondo hasta el notch
                
                // Contenido principal desplazable
                ScrollView {
                    VStack(spacing: 30) {
                        // Textos de cabecera
                        VStack(spacing: 15) {
                            Text("Gracias por elegirnos")
                                .font(.title).bold()
                            Text("Selecciona un profesional disponible:")
                                .font(.headline).multilineTextAlignment(.center)
                        }
                        .foregroundColor(.figmaBlue)
                        .padding(.top, 20)
                        
                        // --- LISTA DE TARJETAS ---
                        VStack(spacing: 15) {
                            // 🔥 Aquí le pasamos el rating a cada uno. Fíjate que Juan Pérez tiene un 2, pero mostrará 4 ⭐
                            ProfessionalCardView(imageName: "hombre1", name: "Juan Pérez", phone: "600111222", rating: 2, isSelected: selectedWorker == 0) { selectedWorker = 0 }
                            
                            ProfessionalCardView(imageName: "hombre2", name: "Ricardo G.", phone: "600333444", rating: 4, isSelected: selectedWorker == 1) { selectedWorker = 1 }
                            
                            ProfessionalCardView(imageName: "hombre3", name: "Marcos L.", phone: "600555666", rating: 5, isSelected: selectedWorker == 2) { selectedWorker = 2 }
                        }
                        .padding(.horizontal, 20)
                        
                        // --- BOTÓN ACEPTAR CON NAVEGACIÓN ---
                        // Solo se muestra (y funciona) si hay un trabajador seleccionado
                        if let selection = selectedWorker {
                            // Pasa los datos del trabajador seleccionado a la vista 'TrabajadorEnCamino'
                            NavigationLink(destination: TrabajadorEnCamino(
                                workerName: selection == 0 ? "Juan Pérez" : (selection == 1 ? "Ricardo G." : "Marcos L."),
                                workerImage: selection == 0 ? "hombre1" : (selection == 1 ? "hombre2" : "hombre3"),
                                workerRating: selection == 0 ? 2 : (selection == 1 ? 4 : 5)
                            )) {
                                Text("Aceptar")
                                    .font(.title3).bold()
                                    .foregroundColor(.figmaBlue)
                                    .frame(width: 180, height: 55)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                                    .shadow(radius: 5)
                            }
                            .padding(.top, 20)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - SUBVISTA: TARJETA DE PROFESIONAL
// Vista de la tarjeta
/// `ProfessionalCardView`: Componente reutilizable que muestra la info de un trabajador.
/// Incluye lógica para forzar estrellas visuales y accesos directos de comunicación.
struct ProfessionalCardView: View {
    // Parámetros de configuración
    var imageName: String
    var name: String
    var phone: String
    var rating: Int // 🔥 Nueva variable de puntuación real
    var isSelected: Bool // Determina si esta tarjeta tiene el borde resaltado
    var action: () -> Void // Cierre (closure) que se ejecuta al tocar la tarjeta entera
    
    // MARK: - Cuerpo de la Tarjeta
    var body: some View {
        HStack(spacing: 15) {
            // Imagen del trabajador circular
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(name).font(.headline).foregroundColor(.figmaBlue)
                Text("Puntuación media").font(.caption).foregroundColor(.gray)
                
                // 🔥 ESTRELLAS INTELIGENTES 🔥
                HStack(spacing: 2) {
                    // Truco visual: fuerza a que el rating visible esté siempre entre 4 y 5.
                    // ¡Juan Pérez (rating 2) parecerá que tiene 4 estrellas!
                    let ratingFijo = max(4, min(rating, 5))
                    
                    // Rellenas (Dibuja las estrellas azules)
                    ForEach(0..<ratingFijo, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.figmaBlue)
                    }
                    
                    // Vacías (Rellena hasta 5 con estrellas grises)
                    if ratingFijo < 5 {
                        ForEach(0..<(5 - ratingFijo), id: \.self) { _ in
                            Image(systemName: "star")
                                .font(.caption)
                                .foregroundColor(.gray.opacity(0.5))
                        }
                    }
                }
            }
            Spacer()
            
            // Botones de acción rápida
            HStack(spacing: 15) {
                // Botón de llamada: Usa el esquema nativo de iOS (tel://)
                Button(action: { let url = URL(string: "tel://\(phone)")!; UIApplication.shared.open(url) }) {
                    Image(systemName: "phone.fill").foregroundColor(.figmaBlue)
                }.buttonStyle(BorderlessButtonStyle()) // Fundamental: Evita que el botón acapare todo el tap de la tarjeta
                
                // Botón de mensaje: Usa el esquema nativo de iOS (sms://)
                Button(action: { let url = URL(string: "sms://\(phone)")!; UIApplication.shared.open(url) }) {
                    Image(systemName: "message.fill").foregroundColor(.figmaBlue)
                }.buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        // Borde azul condicional: Solo se dibuja si la tarjeta está seleccionada
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.figmaBlue, lineWidth: isSelected ? 3 : 0))
        .shadow(color: .black.opacity(0.1), radius: 4)
        // Detecta el toque en cualquier parte de la tarjeta para seleccionarla
        .onTapGesture { action() }
    }
}

// MARK: - PREVIEW
#Preview {
    NavigationStack {
        SeleccionarProfesional()
    }
}
