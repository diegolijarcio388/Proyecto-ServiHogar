import SwiftUI

// MARK: - VISTA PRINCIPAL
/// Vista `ContentView`: Pantalla principal de la aplicación (o sección de servicios).
/// Muestra un encabezado personalizado y un listado navegable con las diferentes categorías de servicios.
struct ContentView: View {
    var body: some View {
        // Contenedor principal para habilitar la navegación hacia otras pantallas
        NavigationStack {
            ZStack {
                // 1. FONDO
                // Imagen corporativa que ocupa toda la pantalla ignorando los bordes seguros
                Image("fondo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // ==========================================
                    // --- BARRA SUPERIOR (HEADER) ---
                    // ==========================================
                    HStack {
                        // 1. Flecha Izquierda (Simulación de botón de retroceso o menú)
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .bold)) // Un pelín más fino queda más elegante
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                        
                        Spacer() // Empuja los elementos hacia los bordes
                        
                        // 2. Iconos Derecha (Accesos rápidos a Calendario y Perfil)
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
                    .ignoresSafeArea() // Extiende el color de fondo hasta el notch/isla superior
                    
                    // -------------------------------
                    
                    // 2. TÍTULO SECCIÓN
                    // Encabezado descriptivo de la lista de categorías
                    HStack(spacing: 10) {
                        Image("storagebox") // Icono personalizado extraído de los assets
                            .resizable()
                            .renderingMode(.template) // Permite tintar el icono
                            .foregroundColor(.figmaBlue)
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Text("Servicios")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.figmaBlue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    
                    // 3. LISTA DE SERVICIOS
                    // Contenedor con scroll para las tarjetas de cada categoría
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 25) {
                            
                            // Cada bloque es un enlace que navega a 'TipoServicioView'
                            // Usamos el componente personalizado 'ServiceCard' para el diseño visual
                            NavigationLink(destination: TipoServicioView()) {
                                ServiceCard(title: "Fontanería", imageName: "font 1")
                            }
                            NavigationLink(destination: TipoServicioView()) {
                                ServiceCard(title: "Limpieza", imageName: "limp 1")
                            }
                            NavigationLink(destination: TipoServicioView()) {
                                ServiceCard(title: "Electricidad", imageName: "elec 1")
                            }
                            NavigationLink(destination: TipoServicioView()) {
                                ServiceCard(title: "Carpintería", imageName: "carp 1")
                            }
                        }
                        .padding(.bottom, 50) // Espacio extra al final para que el último elemento respire
                    }
                    // Este estilo evita que iOS tinte todo el contenido del NavigationLink del color azul por defecto
                    .buttonStyle(PlainButtonStyle())
                }
            }
            // Ocultamos la barra de navegación nativa de iOS para que brille nuestro propio Header
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    ContentView()
}
