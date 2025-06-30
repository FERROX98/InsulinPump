# Insulin Pump Simulation
_Model-Based Software Engineering Project_

**Authors**  
- Daniel Ferro  
- Edoardo L.  
- Mateo L.

## 📖 Overview

Questo progetto propone un modello di **pompa di insulina** che simula il comportamento di un paziente con diabete di tipo 2 prima, durante e dopo i pasti.  
La pompa eroga insulina a velocità variabile durante la giornata per adeguarsi ai fabbisogni glicemici del paziente, migliorando il controllo metabolico e riducendo il rischio di ipoglicemia.

Il sistema è implementato utilizzando Modelica, con il supporto di script Python per la generazione di scenari di test.

---

## 🩺 Sistema simulato

Il sistema è composto dalle seguenti componenti principali:

- **Paziente**: modella le caratteristiche fisiologiche individuali, come livelli di insulina e glucosio.
- **Ambiente**: rappresenta l’assunzione di cibo e la tempistica dei pasti.
- **Pompa di insulina**: regola la somministrazione di insulina in base al livello di glucosio misurato.
- **Monitor**: verifica che il glucosio rimanga in un intervallo di sicurezza (50-200 mg/dL).

---

## ⚙️ Architettura del sistema

Le componenti principali modellate in Modelica sono:

- `mealgen.mo`: gestisce la generazione e la simulazione dei pasti (un pasto ogni 8 ore, durata 1 ora).
- `Pump.mo`: implementa la strategia di somministrazione dell’insulina in base al livello di glucosio.
- `patient.mo`: calcola i livelli di glucosio nel sangue in funzione del cibo ingerito e dell’insulina somministrata.
- `Monitor.mo`: controlla i limiti di sicurezza per i livelli di glucosio; se i valori escono dall’intervallo, il paziente è dichiarato “morto” e il test fallisce.
- `Connectors.mo`: definisce i connettori per collegare ingressi e uscite delle componenti.
- `Ragmeal.mo`: modella il rate appearance del glucosio con un delta variabile tra 10 e 30.

---

## 🎯 Requisiti del sistema

### Requisiti funzionali
- Il glucosio **non deve mai scendere sotto 50 mg/dL**.
- Il glucosio deve rimanere **il più vicino possibile a 100 mg/dL**.
- La pompa deve funzionare correttamente anche in presenza di rumore sui dati.

### Requisiti non funzionali
- Minimizzare la quantità totale di insulina iniettata.
- Massimizzare l’intervallo di campionamento (sampling time) della pompa.

---

## 🧪 Modellazione dei requisiti

- La modellazione dei requisiti funzionali avviene principalmente tramite:
  - Il modello del paziente (calcolo glicemia in ogni momento).
  - Il modello della pompa (erogazione insulina in funzione della glicemia).
  - Il monitor (verifica violazioni di safety/liveness).
- Per i requisiti non funzionali abbiamo implementato lo script `synth.py`, che cerca le combinazioni di parametri della pompa (parametri `a` e `ref`) per minimizzare l’insulina iniettata mantenendo il paziente in un intervallo sicuro di glicemia.

---

## 🔬 Testing

- Lo script `verify.py` simula scenari realistici generando età, altezza, peso e sesso coerenti. Sono stati eseguiti test su **100, 1000 e 10.000 pazienti**, i cui risultati sono riportati nei file:
  - `100_log`
  - `1000_log`
  - `10000_log`

- Lo script `synth.py` esplora combinazioni di parametri di controllo simulando su 100 e 1000 campioni. I risultati sono nei file:
  - `100_synth_log`
  - `1000_synth_log`

---

## 📊 Rumore nei dati

Per simulare l’imprecisione dei sensori, abbiamo introdotto un rumore casuale nei dati del paziente, variabile tra -10% e +10% del valore reale.  
La pompa è stata verificata con questo rumore su un ampio numero di simulazioni, confermandone il corretto funzionamento.

---

## 📁 Allegati

I risultati sperimentali sono allegati nella cartella `/results`, contenente i file di log delle simulazioni.

---

## ✅ Conclusioni

Il sistema simulato mostra che la pompa di insulina è in grado di mantenere i pazienti entro un range di sicurezza, anche in presenza di variabilità dei parametri e rumore sui dati.

---

