<a name="br1"></a> 

Progeto di

Model Based Sofware Engineering

**Insulin Pump**

Daniel Ferro

Edoardo L.

Mateo L.



<a name="br2"></a> 

**1 Il sistema**

Questo documento descrive un possibile modello per Insulin Pump, cioè un

sistema che simula il comportamento di pazient con diabete di tpo due prima,

dopo e durante i past.

Il microinfusore consente di infondere insulina a velocità variabile durante la

giornata permetendo di creare un dose insulinica il più aderente possibile alle reali

esigenze di ogni singolo individuo nei diversi moment della sua vita quotdiana.

Questo comporta da un lato la possibilità di controllare in maniera più precisa la

glicemia nelle diverse fasi della giornata, migliorando il controllo metabolico

globale. Dall'altro, il poter infondere insulina a velocità variabile consente di

ridurre il rischio di ipoglicemia perché consente di infondere minor quanttà di

insulina in quei moment della giornata dove il fabbisogno è minimo, come ad

esempio durante la note.

Abbiamo simulato e modellato il sistema atraverso le seguent component in

modo da veriﬁcare piu’ casi possibili:

• Paziente, modella le carateristche di una persona in base all’insulina ed il

glucosio present;

• Ambiente, modella il cibo ingerito dal paziente e i vari intervalli tra i past in

una giornata;

• Pompa di insulina, modella il sistema che controlla l’insulina inietata sulla

base del glucosio del paziente, cercando di minimizzarne l’uso e tenere il

paziente lontano da situazioni di ipo e iperglicemia.

**2 Scenari Operatii**

Gli scenari operatvi per questo sistema sono tute le possibili combinazioni delle

carateristche di una persona, quali altezza, peso, età, genere; gli scenari variano

poichè la pompa è pensata per essere utlizzata da una persona qualsiasi, cioè

senza delle carateristche partcolari.

1



<a name="br3"></a> 

**2.1 Modellazione atraverso Modelica**

Lo script verify.py simula il sistema della pompa generando in maniere pseudo-

intelligente delle possibili carateristche che rappresentano un paziente come:

età,altezza,peso,sesso.

Le carateristche quindi non vengono generate in maniera totalmente random.

Abbiamo sviluppato una funzione che generà età,altezza,peso,sesso in funzione

dell’età cosi da tagliare fuori dai test tut quei modelli di pazient che nellà realtà

non sarebbero possibili.

Come: Età 50, Peso, 10Kg

Qui viene rappresentata la funzione di cui parliamo:

**3 Architetura del sistema**

Abbiamo modellato le seguent component:

• **mealgen.mo**, questa componente gestsce l’ingestone di cibo che verrà data

in pasto al modello del Paziente. Il paziente eﬀetuerà un pasto ogni 8 ore, di

cui ogni pasto dura un’ora.

• **Pump.mo**, questa componente gestsce la strategia con la quale viene

inietata l’insulina al paziente. Controlla il livello di glucosio atualmente

presente nel paziente e con delle formule calcola la dose di insulina da

inietare.

• **patent.mo**, Il paziente ha in input la dose di insulina da pump.mo e la dose

di cibo da mealgen.mo e calcola il glucosio nel sangue atraverso delle

equazioni.

• **Monitor.mo**, E’ il monitor che controlla se il glucosio del paziente non

scenda mai soto i 50 mg/dL o superi i 200 mg/dL altriment il monitor

dichiara il paziente morto e il test fallisce.

2



<a name="br4"></a> 

• **Connectors.mo**, E’ un modello che permete di creare il tpo che connete gli

input agli output.

• **Ragmeal.mo**, Modella il rate appareance glucose con un valore delta

compreso tra 10 e 30.

3



<a name="br5"></a> 

**4 Requisit del sistema**

• **Requisit Funzionali**

• Il glucosio non dovrebbe mai scendere soto i 50 mg/dL;

• Il glucosio dovrebbe stare piu’ vicino possibile ai 100 mg/dL.

• La pompa di insulina deve contnuare a funzionare anche con una

percentuale di rumore

**4.1 Requisit non Funzionali**

• L’insulina inietata deve essere minimizzata;

• Il sampling tme della pompa di insulina deve essere massimizzato.

**4.2 Modellazione requisit con Modelica**

Abbiamo modellato i requisit funzionali servendoci principalmente di tre modelli:

\- Il modello del paziente, che atraverso le formule del paper calcola in ogni

momento il livello di glucosio nel sangue.

\- Il modello della pompa di insulina, che in base a quanto glucosio è già presente

nel sangue del paziente, eroga insulina.

\- Il monitor, che controlla se i requisit di liveness e safety sono violat.

Per quanto riguarda i requisit non funzionali, abbiamo creato uno script sinth.py

per cercare quali parametri della strategia della pompa è possibile variare per

otenere una quanttà di insulina da inietare minima, ma tenendo comunque il

paziente nei range ragionevoli di glucosio.

**Nel nostro sinth.py iteriamo simulando il modello con una combinazione dei**

**parametri "a" e "ref" della pompa di insulina (ControlloGlu). Nello script si prova**

**a simulare variando la "a" tra 0,5 e 1 e "ref" tra 90 e 115 per il log\_100 e “a” tra**

**0,1 e 1.2 e “ref” tra 60 e 160 per log\_1000.**

**Con la variazione di quest parametri possiamo osservare le diverse quanttà di**

**insulina inietate ad un paziente con la stesse carateristche.**

4



<a name="br6"></a> 

**5 Extra**

Abbiamo introdoto una percentuale di rumore che va ad inﬂuire diretamente

sui valori del paziente. Questo rumore inﬂuenza i dat per un intervallo che

oscilla tra -10% e +10% del valore stesso.

Per simulare che la pompa contnui a funzionare nonostante il rumore abbiamo

randomizzato i valori nel ﬁle verify.py e testato su 100/1000/10000 pazient.

Dai risultat che abbiamo allegato in fondo siamo in grado di aﬀermare che la

pompa contnui a funzionare corretamente.

**6 Risultat Sperimentali**

**6.1 run.mos**

Glucosia e insulina

5



<a name="br7"></a> 

Glucosio, Rameal e Delta:

Glucosio,Insulina e Delta:

6



<a name="br8"></a> 

**6.2 verify.py**

Abbiamo eﬀetuato test utlizzato il nostro verify.py eseguendolo su 100, 1000 e

10000 samples.

• 100 samples:

• 1000 samples:

• 10000 samples:

7



<a name="br9"></a> 

In allegato i ﬁle contenent i risultat, rispetvamente 100\_log, 1000\_log,

10000\_log

**6.3 synth.py**

Abbiamo eﬀetuato test utlizzato il nostro synth.py eseguendolo su 100, 1000

samples.

• 100 samples:

• 1000 samples:

In allegato i ﬁle contenent i risultat, rispetvamente 100\_synth\_log,

1100\_synth\_log

8
