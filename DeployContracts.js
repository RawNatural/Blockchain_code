//Don't copy this file. It was only used for testing other contracts, which are not included in this git repository.

//The useful part to take from this, is how to deploy contracts while testing with hardhat etc.

const { expect } = require('chai');
const { ethers } = require('hardhat');

const tokens = (n) => {
  return ethers.utils.parseUnits(n.toString(), 'ether')
}

describe('Deployment', () => {

  beforeEach(async () => {
    // Setup accounts
    accounts = await ethers.getSigners()
    deployer = accounts[0]

    // Load contracts
    const DeployableSmartContract = await ethers.getContractFactory('DeployableSmartContract');
    //const FlashLoanSimpleReceiverBase = await ethers.getContractFactory('AaveFlashLoanReceiver');
    const FlashLoanReceiver = await ethers.getContractFactory('FlashLoanReceiver');



    //Deploy DeployableSmartContract THIS WORKS DONT CHANGE
    deployedSmartContract = await DeployableSmartContract.deploy();

    //Deploy FlashLoanReceiver
    flashLoanReceiver = await FlashLoanReceiver.deploy('0x794a61358D6845594F94dc1DB02A252b5b4814aD');


  }) // end beforeEach

  //it deployed DeployableSmartContract 
  it('deployed DeployableSmartContract', async () => {
    expect(await deployedSmartContract.deployed)
  })



  it('deployed FlashLoanReceiver', async () => {
    expect(await flashLoanReceiver.deployed);
  })



})

describe('Executing Flash Loan', () => {
  it('Executes Flash Loan', async () => {
    let flashAddress = await flashLoanReceiver.getFlashLoanAddress()
    //console.log(flashAddress)
    //expect(await flashLoanReceiver.printAddress().to.equal('0x794a61358D6845594F94dc1DB02A252b5b4814aD'))
    console.log(deployer.address)
    let owner = await flashLoanReceiver.getOwner()
    console.log(owner)
  })
})

describe('Borrowing funds', () => {

    it('borrows funds from the pool', async () => {
      let amount = tokens(100)
      let transaction = await flashLoanReceiver.connect(deployer).executeFlashLoan(amount)
      let result = await transaction.wait()

      await expect(transaction).to.emit(flashLoanReceiver, 'LoanReceived')
        .withArgs(token.address, amount)
    })


  })
