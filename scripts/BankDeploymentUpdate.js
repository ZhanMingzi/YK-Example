const hre = require("hardhat");

async function main() {

const BankFactory = await hre.ethers.getContractFactory("Bank");
// 部署智能合约
const Bank = await BankFactory.deploy();
// 打印合约地址
console.log(`Contract deployed to: ${Bank.target}`);


}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });