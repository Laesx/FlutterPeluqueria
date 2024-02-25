import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  final String name;
  final String time;
  final String date;
  final List<Map<String, String>> services;
  final String paymentMethod;
  final bool verified;

  const AppointmentCard({super.key, 
    required this.name,
    required this.time,
    required this.date,
    required this.services,
    required this.paymentMethod,
    required this.verified,
  });


  double calculateTotal() {
    double total = 0.0;
    for (var service in services) {
      if (service['price'] != null) {
        total += double.parse(service['price']!);
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
  final double total = calculateTotal();

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nombre peluquería',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Dirección Peluquería',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              name,
              style: const TextStyle(color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time, style: const TextStyle(color: Colors.grey)),
                Text(date, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),
            DataTable(
              columns: const [
                DataColumn(label: Text('SERVICIO')),
                DataColumn(label: Text('PRECIO')),
              ],
              rows: services
                  .map(
                    (service) => DataRow(
                      cells: [
                        DataCell(Text(service['name'] ?? '', style: const TextStyle(color: Colors.grey))),
                        DataCell(Text(service['price'] ?? '', style: const TextStyle(color: Colors.grey))),
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
                Text(paymentMethod),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text('Código', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16.0),
            if(verified)
            const Text('PAGO VERIFICADO', style: TextStyle(color: Colors.green)),
            if(!verified)
            const Text('PAGO NO VERIFICADO', style: TextStyle(color: Colors.red))
          ],
        ),
      ),
    );
  }

}
