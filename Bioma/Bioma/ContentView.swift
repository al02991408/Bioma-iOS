import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.cuarto)
                    Text("Hello, world!")
                        .font(.title)
                        .padding(.bottom, 20)

                    // Botón para ir a los reportes
                    NavigationLink(destination: ReportesView()) {
                        Text("Ir a Reportes")
                            .font(.title2)
                            .padding()
                            .background(.secundario)
                            .foregroundColor(.tercero)
                            .cornerRadius(10)
                            .padding(.top, 20)
                    }
                    
                    // Botón para ir a la pantalla del clima
                    NavigationLink(destination: ClimaView()) {
                        Text("Ir al Clima")
                            .font(.title2)
                            .padding()
                            .background(.tercero)
                            .foregroundColor(.primario)
                            .cornerRadius(10)
                            .padding(.top, 20)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity) // Hace que el contenido se ajuste al ancho de la pantalla
            }
            .navigationTitle("Bioma")
        }
    }
}

#Preview {
    ContentView()
}
