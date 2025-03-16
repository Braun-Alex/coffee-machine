---- MODULE CoffeeMachine ----
EXTENDS Naturals

(***************************************************************************)
(* This is a TLA+ specification for a coffee machine that can dispense     *)
(* espresso with or without milk, accepting cash or card payments.         *)
(* Initial resource amounts (coffee beans, water, milk) and espresso price *)
(* are configurable via constants defined in the .cfg file.               *)
(***************************************************************************)

CONSTANTS InitialCoffeeBeans, InitialWater, InitialMilk, EspressoPrice, MaxCash

ASSUME /\ InitialCoffeeBeans \in Nat /\ InitialCoffeeBeans >= 7
       /\ InitialWater \in Nat /\ InitialWater >= 30
       /\ InitialMilk \in Nat /\ InitialMilk >= 20
       /\ EspressoPrice \in Nat /\ EspressoPrice >= 1
       /\ MaxCash \in Nat /\ MaxCash >= EspressoPrice

VARIABLES payment_method, cash, card_payment, coffee_beans, water, milk, power, internet, state, coffee, change

TypeInvariant == /\ payment_method \in {"none", "cash", "card"}
                 /\ cash \in 0..MaxCash
                 /\ card_payment \in {TRUE, FALSE}
                 /\ coffee_beans \in 0..InitialCoffeeBeans
                 /\ water \in 0..InitialWater
                 /\ milk \in 0..InitialMilk
                 /\ power \in {TRUE, FALSE}
                 /\ internet \in {TRUE, FALSE}
                 /\ state \in {"waiting", "selecting", "dispensing_no_milk", "dispensing_with_milk", "error"}
                 /\ coffee \in {TRUE, FALSE}
                 /\ change \in 0..MaxCash

Init == /\ payment_method = "none"
        /\ cash = 0
        /\ card_payment = FALSE
        /\ coffee_beans = InitialCoffeeBeans
        /\ water = InitialWater
        /\ milk = InitialMilk
        /\ power = TRUE
        /\ internet = TRUE
        /\ state = "waiting"
        /\ coffee = FALSE
        /\ change = 0

ChooseCash == /\ state = "waiting"
              /\ power = TRUE
              /\ payment_method' = "cash"
              /\ UNCHANGED <<cash, card_payment, coffee_beans, water, milk, power, internet, state, coffee, change>>

ChooseCard == /\ state = "waiting"
              /\ power = TRUE
              /\ internet = TRUE
              /\ payment_method' = "card"
              /\ UNCHANGED <<cash, card_payment, coffee_beans, water, milk, power, internet, state, coffee, change>>

InsertCash(c) == /\ payment_method = "cash"
                 /\ c \in {1, 2, 5, 10, 20, 50, 100}
                 /\ cash + c <= MaxCash
                 /\ state \in {"waiting", "selecting"}
                 /\ cash' = cash + c
                 /\ state' = "selecting"
                 /\ UNCHANGED <<payment_method, card_payment, coffee_beans, water, milk, power, internet, coffee, change>>

PayWithCard == /\ payment_method = "card"
               /\ internet = TRUE
               /\ state = "waiting"
               /\ card_payment' = TRUE
               /\ state' = "selecting"
               /\ UNCHANGED <<payment_method, cash, coffee_beans, water, milk, power, internet, coffee, change>>

SelectEspressoNoMilk == /\ state = "selecting"
                        /\ coffee_beans >= 7
                        /\ water >= 30
                        /\ ((payment_method = "cash" /\ cash >= EspressoPrice) \/ (payment_method = "card" /\ card_payment = TRUE))
                        /\ state' = "dispensing_no_milk"
                        /\ UNCHANGED <<payment_method, cash, card_payment, coffee_beans, water, milk, power, internet, coffee, change>>

SelectEspressoWithMilk == /\ state = "selecting"
                          /\ coffee_beans >= 7
                          /\ water >= 30
                          /\ milk >= 20
                          /\ ((payment_method = "cash" /\ cash >= EspressoPrice) \/ (payment_method = "card" /\ card_payment = TRUE))
                          /\ state' = "dispensing_with_milk"
                          /\ UNCHANGED <<payment_method, cash, card_payment, coffee_beans, water, milk, power, internet, coffee, change>>

DispenseEspressoNoMilk == /\ state = "dispensing_no_milk"
                          /\ coffee' = TRUE
                          /\ coffee_beans' = coffee_beans - 7
                          /\ water' = water - 30
                          /\ change' = IF payment_method = "cash" /\ cash > EspressoPrice THEN cash - EspressoPrice ELSE 0
                          /\ cash' = 0
                          /\ card_payment' = FALSE
                          /\ state' = "waiting"
                          /\ UNCHANGED <<payment_method, milk, power, internet>>

DispenseEspressoWithMilk == /\ state = "dispensing_with_milk"
                            /\ coffee' = TRUE
                            /\ coffee_beans' = coffee_beans - 7
                            /\ water' = water - 30
                            /\ milk' = milk - 20
                            /\ change' = IF payment_method = "cash" /\ cash > EspressoPrice THEN cash - EspressoPrice ELSE 0
                            /\ cash' = 0
                            /\ card_payment' = FALSE
                            /\ state' = "waiting"
                            /\ UNCHANGED <<payment_method, power, internet>>

ErrorState == /\ state = "selecting"
              /\ ~(coffee_beans >= 7 /\ water >= 30)
              /\ state' = "error"
              /\ UNCHANGED <<payment_method, cash, card_payment, coffee_beans, water, milk, power, internet, coffee, change>>

CancelCash == /\ state = "selecting"
              /\ payment_method = "cash"
              /\ cash < EspressoPrice
              /\ change' = cash
              /\ cash' = 0
              /\ payment_method' = "none"
              /\ state' = "waiting"
              /\ UNCHANGED <<card_payment, coffee_beans, water, milk, power, internet, coffee>>

RefillResources == /\ state = "error"
                   /\ coffee_beans' = InitialCoffeeBeans
                   /\ water' = InitialWater
                   /\ milk' = InitialMilk
                   /\ state' = "selecting"
                   /\ UNCHANGED <<payment_method, cash, card_payment, power, internet, coffee, change>>

Next == \/ ChooseCash
        \/ ChooseCard
        \/ (\E c \in {1, 2, 5, 10, 20, 50, 100}: InsertCash(c))
        \/ PayWithCard
        \/ SelectEspressoNoMilk
        \/ SelectEspressoWithMilk
        \/ DispenseEspressoNoMilk
        \/ DispenseEspressoWithMilk
        \/ ErrorState
        \/ CancelCash
        \/ RefillResources

Spec == Init /\ [][Next]_<<payment_method, cash, card_payment, coffee_beans, water, milk, power, internet, state, coffee, change>> /\
        WF_<<payment_method, cash, card_payment, coffee_beans, water, milk, power, internet, state, coffee, change>>(SelectEspressoNoMilk) /\
        WF_<<payment_method, cash, card_payment, coffee_beans, water, milk, power, internet, state, coffee, change>>(SelectEspressoWithMilk) /\
        WF_<<payment_method, cash, card_payment, coffee_beans, water, milk, power, internet, state, coffee, change>>(DispenseEspressoNoMilk) /\
        WF_<<payment_method, cash, card_payment, coffee_beans, water, milk, power, internet, state, coffee, change>>(DispenseEspressoWithMilk)

Inv1 == (state = "dispensing_no_milk") => (coffee_beans >= 7 /\ water >= 30 /\
        ((payment_method = "cash" /\ cash >= EspressoPrice) \/ (payment_method = "card" /\ card_payment = TRUE)))

Inv2 == (state = "dispensing_with_milk") => (coffee_beans >= 7 /\ water >= 30 /\ milk >= 20 /\
        ((payment_method = "cash" /\ cash >= EspressoPrice) \/ (payment_method = "card" /\ card_payment = TRUE)))

Inv3 == (payment_method = "card" /\ card_payment = TRUE) => (internet = TRUE)

Inv4 == (state # "error") => (power = TRUE)

EventuallyDispensesNoMilk == (coffee_beans >= 7 /\ water >= 30 /\
                              ((payment_method = "cash" /\ cash >= EspressoPrice) \/ (payment_method = "card" /\ card_payment = TRUE))) ~> (coffee = TRUE)

EventuallyDispensesWithMilk == (coffee_beans >= 7 /\ water >= 30 /\ milk >= 20 /\
                                ((payment_method = "cash" /\ cash >= EspressoPrice) \/ (payment_method = "card" /\ card_payment = TRUE))) ~> (coffee = TRUE)

THEOREM Spec => /\ TypeInvariant
                /\ Inv1 /\ Inv2 /\ Inv3 /\ Inv4
                /\ EventuallyDispensesNoMilk
                /\ EventuallyDispensesWithMilk

====