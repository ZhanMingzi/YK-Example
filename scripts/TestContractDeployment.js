
async function main() {

  const TestContract_Factory = await ethers.getContractFactory("testContract");

  const TestContract = await TestContract_Factory.deploy();

  console.log("Bank deployed to:",TestContract.target);

}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
