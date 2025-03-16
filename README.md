# ☕ Coffee machine TLA+ specification 🚀

Welcome to the project! 🎉 The repository contains a formal specification of a coffee machine system modeled using TLA+ ☕️, 
a language for specifying and verifying complex systems.

---

## 📖 About the project

This project models a coffee machine that:
- accepts payments via cash 💵 or card 💳;
- dispenses espresso ☕ with or without milk 🥛;
- handles resource shortages (coffee beans 🌱, water 💧, milk 🥛) and power/internet dependencies 🔌🌐.

The specification is written in TLA+ and verified using the TLC model checker 🛠️.

## 🌟 Features

- **Payment flexibility**: supports cash (1, 2, 5, 10, 20, 50, 100 units) 💰 and card payments 💳.
- **Espresso options**: classic espresso (7g beans, 30ml water) 🌿💧 or with milk (20ml extra) 🥛.
- **Error handling**: transitions to an error state 🚨 if resources run low, with a refill action 🔄 to recover.
- **Configurable**: uses constants for initial resources, price, and max cash ⚙️.
- **Safety & liveness**: verified invariants 🛡️ and liveness properties ⏳ with TLC.

## 🛠️ Getting started

### Prerequisites
- Install the [TLA+ Toolbox](https://github.com/tlaplus/tlaplus) 🧰 to run and verify the specification.
- A love for coffee ☕ and formal methods ❤️.

### Files
- **`CoffeeMachine.tla`**: the TLA+ specification file 📜.
- **`CoffeeMachine.cfg`**: configuration file for TLC ⚙️.
- **`README.md`**: You are reading it 👀!

### How to run
1. Clone this repo: ```git clone https://github.com/your-username/coffee-machine-tla.git```.
2. Open `CoffeeMachine.tla` in the TLA+ Toolbox 🌐.
3. Load `CoffeeMachine.cfg` in TLC 🛠️.
4. Hit "Run" and watch 🎩✨!
5. Check the results - no deadlocks, all invariants hold ✅!

## 📋 Specification highlights

- **Constants**: `InitialCoffeeBeans`, `InitialWater`, `InitialMilk`, `EspressoPrice`, `MaxCash` ⚙️.
- **States**: `<waiting>`, `<selecting>`, `<dispensing_no_milk>`, `<dispensing_with_milk>`, `<error>` 🔄.
- **Actions**: from `ChooseCash` 💵 to `RefillResources` 🔧 - every step is modeled!
- **Invariants**: ensures resources and power/internet conditions are met 🛡️.
- **Liveness**: guarantees coffee is dispensed when conditions are right ⏳☕.

## 🎯 Goals

- Model a real-world coffee machine with TLA+ ☕🤖.
- Verify safety (no invalid states) 🔒 and liveness (coffee eventually brews) ⏰.
- Demonstrate TLA+’s power for system design 🚀.

## 🚀 Usage

- Tweak constants in `CoffeeMachine.cfg` to experiment with different setups ⚙️.
- Run TLC to verify the specification - no errors, just coffee ☕✅!
- Explore the state space and enjoy the formal brew 🌌!

## 🌈 Acknowledgments

- Leslie Lamport for TLA+ 🙌.
- Coffee lovers everywhere ☕❤️.
- You, for checking this out 😊👍!

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details 📄.   
Feel free to use, modify, and share this coffee-fueled TLA+ goodness ☕✨!
