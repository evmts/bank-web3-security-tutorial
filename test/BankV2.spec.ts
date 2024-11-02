import { BankV2 } from '../src/BankV2.s.sol'
import { AttackerContract } from './BankV2.AttackerContract.s.sol'
import { createMemoryClient, parseEther } from 'tevm'
import { createAddress } from 'tevm/address'
import { beforeEach, test, expect, describe } from 'vitest'

let client = createMemoryClient()
let bank = BankV2.withAddress(createAddress(0).toString())

const mohamed = createAddress(420420)
const ahmed = createAddress(6969)
const asmaa = createAddress(1111)
const attacker = createAddress(1234567890)

beforeEach(async () => {
  client = createMemoryClient()

  const { createdAddress } = await client.tevmDeploy(BankV2.deploy())
  bank = BankV2.withAddress(createdAddress!)
  await client.tevmMine()

  for (const user of [mohamed, ahmed, asmaa]) {
    await client.tevmSetAccount({
      address: user.toString(),
      balance: parseEther('2')
    })

    await client.tevmContract({
      ...bank.write.depositEther(),
      value: parseEther('1'),
      from: user.toString(),
      createTransaction: true,
    })
    await client.tevmMine()
  }
})

describe('BankV2', () => {
  test('Attacker drains bank', async () => {
    await client.tevmSetAccount({
      address: attacker.toString(),
      balance: parseEther('1')
    })

    const { createdAddress: attackerContractAddress } = await client.tevmDeploy({
      ...AttackerContract.deploy(bank.address),
      from: attacker.toString(),
    })
    await client.tevmMine()
    const attackerContract = AttackerContract.withAddress(attackerContractAddress!)

    const initialAttackerBalance = await client.getBalance({ address: attackerContractAddress! })
    const initialBankBalance = await client.getBalance({ address: bank.address })
    
    expect(initialAttackerBalance).toBe(0n)
    expect(initialBankBalance).toBe(parseEther('3'))

    await client.tevmSetAccount({
      address: attacker.toString(),
      balance: parseEther('2')
    })

    await client.tevmContract({
      ...attackerContract.write.deposit(),
      value: parseEther('1'),
      from: attacker.toString(),
      createTransaction: true,
    })
    await client.tevmMine()

    await client.tevmContract({
      ...attackerContract.write.withdraw(),
      from: attacker.toString(),
      createTransaction: true,
    })
    await client.tevmMine()

    const finalAttackerBalance = await client.getBalance({ address: attackerContractAddress! })
    const finalBankBalance = await client.getBalance({ address: bank.address })

    expect(finalAttackerBalance).toBe(parseEther('4'))
    expect(finalBankBalance).toBe(0n)
  })
})