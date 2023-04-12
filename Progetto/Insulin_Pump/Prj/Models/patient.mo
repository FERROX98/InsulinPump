block Patient

InputReal Rameal;                 // food intake
InputReal insulin_from_pump;     //insulin from the pump
OutputReal G;                    // blood glucose measured by the pump

parameter Real  ki= 0.0075;
parameter Real kp2= 0.0008;
parameter Real kp3 = 0.006;
parameter Real kp4= 0.0484;
parameter Real  Vg = 1;
parameter Real  Vmx = 0.034;
parameter Real Km0 = 466.2;
parameter Real  k2 = 0.043;
parameter Real  k1 = 0.066;
parameter Real  p2U = 0.058;
parameter Real  alpha = 0.034;
parameter Real PHId =286;
parameter Real PHIs=20.3;
parameter Real  Vi = 0.041;
parameter Real  aG=0.005;
parameter Real  m4 = 0.443;
parameter Real  m5 = 0.260;
parameter Real  m6 = 0.017;
parameter Real  m1 = 0.314;
parameter Real Gb = 127;
parameter Real EGPb = 1.59;
parameter Real  Ib =54;
parameter Real K01 = FRA * b1 + (1 - FRA) * a1;//0.06;
parameter Real K21 = a1+b1-k12-k01;//0.064;
parameter Real K12 = (a1 * b1) /k12;//0.048;

//da randomizzare-------------
parameter Integer sex= 0;
parameter Integer age = 55;
parameter Integer Weight = 96;
parameter Integer Height = 168;
parameter Integer BW=Weight;
//
parameter Real Fcns = 1; 
//----------------------------
parameter Real h = 98.7;
parameter Real  r1 = 0.7419;
parameter Real r2 = 0.0807;
parameter Real Gth = 50;
parameter Real Cpb = 200;
parameter Real  aOG = HEb+aG*Gb;

//
//---parametri derivati e condizioni iniziali------------------------------------------
parameter Real Gpb=Gb*Vg;
parameter Real ke1=0.0005; 
parameter Real  ke2=339; 
parameter Real Gtb = if (Gpb<=ke2) then (Fcns-EGPb+k1*Gpb)/k2 else ((Fcns-EGPb+ke1*(Gpb-ke2))/Vg+k1*Gpb)/k2;
parameter Real Vm0 = if (Gpb<=ke2) then (EGPb-Fcns)*(Km0+Gtb)/Gtb else (EGPb-Fcns-ke1*(Gpb-ke2))*(Km0+Gtb)/Gtb;
parameter Real kp1=EGPb+kp2*Gpb+kp3*Ib+kp4*Ilb;
parameter Real Ipb=Ib*Vi;
parameter Real m2=0.268;
parameter Real HEb=(SRb-m4*Ipb)/(SRb+m2*Ipb);
//parameter Real HEb = max(HEb,0);
parameter Real m30=HEb*m1/(1-HEb);
parameter Real Ilb=(Ipb*m2+SRb)/(m1+m30);
parameter Real Ievb=Ipb*m5/m6;
parameter Real b1=log(2)/(0.14*age+29.16);
parameter Real BMI=BW/(Height/100)^2;
parameter Real a1 = if (BMI <= 27) then 0.14 else 0.152;
parameter Real FRA = if (BMI <= 27) then 0.76 else 0.78;
parameter Real k12=FRA*b1+(1-FRA)*a1;
parameter Real k01=(a1*b1)/k12;
parameter Real k21=a1+b1-k12-k01;
parameter Real BSA=0.007194*(Height^(0.725))*(BW^(0.425));
parameter Real Vc = if (sex == 1) then 1.92*BSA+0.64 else 1.11*BSA+2.04;
parameter Real Cp2b=Cpb*k21/k12;
parameter Real SRb=Cpb/BW*Vc*k01;
parameter Real phi_s=20.30;
parameter Real phi_d=286.0;
//--------------------------------------------------

Real Gp;
Real Ip;
Real I;
Real HE;
Real m3;
Real Il;
Real Iev;
Real Gt; 
//-------------------
Real ISR; 
Real ISRs;
Real ISRd;
Real ISRb;
// 
Real CP1;
Real CP2;
Real Xl;
Real I_i; // I'
Real X;
Real EGP;
Real Uii;
Real E;
Real Uid;
Real risk;
//-----

initial equation       
Gp = Gpb;
Gt=Gtb;
Il=Ilb;
Ip=Ipb;
Iev=Ievb;
ISRs=0;
CP1=Cpb;
CP2=k21/k12*Cpb;
Xl=Ib;
I_i=Ib;//I'
X=0;

equation

ISRb = Cpb * k01 * Vc; //A22

if(der(G) >= 0) then //A21
	ISRd = Vc * 286.0 * der(G);
else
	ISRd = 0;
end if;

der(ISRs) = - alpha * (ISRs - Vc * 20.30 * (G - h));//A20

ISR = ISRs + ISRd + ISRb;//A19

der(CP1) = - (k01 + k21) * CP1 + k12 * CP2 + ISR / Vc;//A18
der(CP2) = -k12 * CP2 + k21 * CP1;

if (Gp > ke2) then//A17
	E = ke1 * (Gp - ke2);
else
	E = 0;

end if;



if(G >= Gb) then //A15
	risk = 0;
else
	if (Gth <= G and G <= Gb) then
		risk = 10* f(G,Gb,r1,r2)^2;
	else
		if (G <= Gth) then
			risk = 10*(f(Gth,Gb,r1,r2)^2);
			else
			risk = 0; 
		end if;
	end if;
end if;

der(X) = -p2U * X + p2U * (I - Ib);	//A14

Uid = (Vm0 + Vmx * X * (1 + r1 * risk))* Gt / (Km0 + Gt);//A13

Uii = Fcns;	//A12

der(I_i) = -ki * (I_i - I);    //A11
der(Xl) =  -ki* (Xl - I_i); //A10
EGP = kp1 - kp2 * Gp - kp3 * Xl - kp4 * Il; // A9


//A5 Quinta

HE = -aG * G + aOG;	//A4
m3 = HE * m1 / (1- HE);	//A3
der(Il) = - (m1 + m3) * Il + m2 * Ip + ISR / BW;//A2 
der(Ip) = - (m2 + m4 + m5) * Ip + m1 * Il + m6 * Iev;	//A2 
der(Iev) = - m6 * Iev + m5 * Ip; //A2 
I = (Ip+insulin_from_pump) / Vi;

der(Gp) = EGP + Rameal - Uii -E - k1 * Gp + k2 * Gt;   
der(Gt) = - Uid + k1 * Gp - k2 * Gt;  //A1 
G = Gp / Vg - insulin_from_pump;//A1 

end Patient;

function f

input Real G;
input Real Gb;
input Real r1;
input Real r2;
output Real y;

algorithm
  y:=(log(G)^r2) - (log(Gb)^r2); //A16
end f;