block MealGenerator

OutputReal delta;

parameter Real Meal_length = 60;  // lenght of meal (minutes)
parameter Real Meal_period = 480;  // periodic meals: every 8 hours.
Real random;
Boolean meal_on, meal_off;

protected discrete Integer state1024[Modelica.Math.Random.Generators.Xorshift1024star.nState];

initial equation
meal_on = false;
meal_off = false;

state1024 = Modelica.Math.Random.Generators.Xorshift1024star.initialState(614657, 30020);
random = 0;


algorithm


when sample(0, Meal_period/2) then
meal_on := not(pre(meal_on));
end when;

when sample(Meal_length, Meal_period/2) then
meal_off := not(pre(meal_off));
end when;

when edge(meal_on) then
//delta = 20;
(random,state1024) := Modelica.Math.Random.Generators.Xorshift1024star.random(pre(state1024));
delta := random * 20 + 10;
elsewhen edge(meal_off) then
delta := 0;
end when;




end MealGenerator;