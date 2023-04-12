
record KPar "system parameters"
parameter Real Dose=105;
parameter Real b=0.73;
parameter Real d=0.10;
parameter Real kmax=0.0426 ;
parameter Real kmin=0.0076 ;
parameter Real kabs=0.0542 ;

parameter Real f=0.9;
end KPar;


function k_empt
input KPar K;
input Real Q;
output Real y;

protected Real alpha, beta;

algorithm

alpha := 5/(2*K.Dose*(1-K.b));

beta := 5/(2*K.Dose*K.d);

y := K.kmin + ((K.kmax - K.kmin)/2)*(tanh(alpha*(Q - beta*K.Dose)) - tanh(beta*(Q - K.d*K.Dose)) + 2);

end k_empt;


model Rate_Appearance_Glucose
InputReal delta;
OutputReal Rameal;

parameter Real BW=96;
KPar K;
Real Qsto;
Real Qsto1;
Real Qsto2;
Real Qgut;

initial equation
Qsto1 = 0;
Qsto2 = 0;
Qgut = 0;
equation

Qsto = Qsto1 + Qsto2;

der(Qsto1) =(-K.kmax)*Qsto1 + K.Dose*delta;

der(Qsto2) = - k_empt(K, Qsto)*Qsto2 + K.kmax*Qsto1;

der(Qgut) =(-K.kabs)*Qgut +k_empt(K, Qsto)*Qsto2;

Rameal = (K.f*K.kabs*Qgut)/BW;

end Rate_Appearance_Glucose;

