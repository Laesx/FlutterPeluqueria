import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_peluqueria/models/models.dart';

class ReservaCard extends StatelessWidget {
  final String nombrePeluqueria = "Barbershop Ali";
  final String direccionPeluqueria = "C. Primavera, 26, Genil, 18008 Granada";
  final Reserva reserva;

  const ReservaCard({
    Key? key,
    required this.reserva,
  }) : super(key: key);

  double calculateTotal() {
    double total = 0.0;
    for (var service in reserva.servicios.entries) {
      // Assuming the service has a price property
      total += service.value;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final double total = calculateTotal();

    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nombrePeluqueria,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 8.0),
              Text(
                direccionPeluqueria,
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                reserva.peluquero,
                style: const TextStyle(color: Colors.grey),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('HH:mm').format(reserva
                        .fecha[0]), // Mostrar solo la hora del primer elemento
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(reserva
                        .fecha[0]), // Mostrar solo la fecha del primer elemento
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Divider(),
              const SizedBox(height: 16.0),
              if (!reserva.cancelada)
                Column(
                  children: [
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('SERVICIO')),
                        DataColumn(label: Text('PRECIO')),
                      ],
                      rows: reserva.servicios.entries
                          .map(
                            (service) => DataRow(
                              cells: [
                                DataCell(Text(service.key,
                                    style:
                                        const TextStyle(color: Colors.grey))),
                                DataCell(Text(service.value.toString(),
                                    style:
                                        const TextStyle(color: Colors.grey))),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(total.toString()),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Método de pago: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(reserva.pago),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Código: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(reserva.id!,
                              style: TextStyle(color: Colors.grey)),
                        ]),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (reserva.pagada)
                          const Text('PAGO VERIFICADO',
                              style: TextStyle(color: Colors.green)),
                        if (!reserva.pagada)
                          const Text('PAGO NO VERIFICADO',
                              style: TextStyle(color: Colors.red)),
                      ],
                    )
                  ],
                )
              else
                const Text('CITA CANCELADA',
                    style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
