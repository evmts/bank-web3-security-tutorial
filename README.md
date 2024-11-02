# Web3 Security Tutorial | Bank Challenge

This web3 security tutorial contains both foundry tests written in Solidity and Tevm tests written in TypeScript

## Summary

This repository is a simple tutorial in Web3 Security (EVM), the idea of this tutorial is to understand some common bugs in Web3 and concepts you should understand.

This repo is like CTF challenges, but it differs in the structure. Our tutorial is like a game, or to be more accurately, a story, a Story of a group of developers trying to make a Decentralized Bank and launch it on Mainnet. The challenges are in sequence. You should pass the First Challenge to go to the second, and the second to go to the third, etc.

## Installation
To install the Repo, you must have `Foundry` framework installed on your PC. If you don't have one, you can install it from [here](https://getfoundry.sh/)

If you already have Foundry installed, it is better to update `Foundry` version to be compatible with that version. You can update it using the following command

```powershell
foundryup
```

Once you updated or installed `Foundry` successfully, you can start setting up our Tutorial.

1. Clone the GitHub repository into your PC, and open the Repo folder on your Code Editor
```powershell
git clone https://github.com/Al-Qa-qa/bank-web3-security-tutorial.git
```

2. Install Dependencies
```powershell
forge install
```

3. Run Tests to check everything is OK (All tests should pass)
```powershell
forge test
```

## Tutorial Explanation

Our tutorial contains 5 challenges you will find all of them in `/challenges` folder.

We have 5 challenges:
- BankV1
- BankV2
- BankV3
- BankV4
- BankV5

They are sequence challenges you need to understand the first one to come to the second, and the second to come to the third etc...

For the solutions to the challenges, you will find them in `/solutions` folder. And for the simulation of the attack, you can go to `/test` folder that contains written POCs for the attack that can occur for all challenges.

|Challenge Name|Challenge Writeup|Solution|
|----------------|:--------|:-------|
|BankV1|[/challenges/BankV1.md](/challenges/BankV1.md)|[/solutions/BankV1.md](/solutions/BankV1.md)|
|BankV2|[/challenges/BankV2.md](/challenges/BankV2.md)|[/solutions/BankV2.md](/solutions/BankV2.md)|
|BankV3|[/challenges/BankV3.md](/challenges/BankV3.md)|[/solutions/BankV3.md](/solutions/BankV3.md)|
|BankV4|[/challenges/BankV4.md](/challenges/BankV4.md)|[/solutions/BankV4.md](/solutions/BankV4.md)|
|BankV5|[/challenges/BankV5.md](/challenges/BankV5.md)|[/solutions/BankV5.md](/solutions/BankV5.md)|

Happy Hacking!



