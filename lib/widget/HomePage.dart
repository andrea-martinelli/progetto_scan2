import 'package:flutter/material.dart';
import 'package:progetto_scan2/widget/BarcodeScannerPage.dart'; 

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleziona Magazzino'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bottone per Magazzino 1
              SizedBox(
                width: double.infinity, // Rendi il bottone largo quanto possibile
                height: 200, // Altezza maggiore per i bottoni
                child: ElevatedButton(
                  onPressed: () {
                    // Aggiungi l'azione che desideri eseguire (es. navigare a BarcodeScannerPage)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BarcodeScannerPage()),
                    );
                  },
                  child: const Text('MAGAZZINO 1', style: TextStyle(fontSize: 24, color:Colors.green)),
                ),
              ),
              SizedBox(height: 50), // Spazio tra i due bottoni
              // Bottone per Magazzino 2
              SizedBox(
                width: double.infinity, // Rendi il bottone largo quanto possibile
                height: 200, // Altezza maggiore per i bottoni
                child: ElevatedButton(
                  onPressed: () {
                    // Aggiungi l'azione che desideri eseguire (puoi personalizzare la pagina)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BarcodeScannerPage()),
                    );
                  },
                  child: 
                  const Text('MAGAZZINO 2',
                   style: TextStyle(fontSize: 24, color:Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
