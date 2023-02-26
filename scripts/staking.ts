import { ethers, network } from "hardhat";
import { time } from "@nomicfoundation/hardhat-network-helpers";


async function main() {
    const [owner] = await ethers.getSigners();

    const ApeHolder1 = "0x4A385286592C97e457A6f54A3734557F4b095A28";
    const NonApeHolder = "0xDa9CE944a37d218c3302F6B82a094844C6ECEb17";
    // Deploy reward contract
    const Token = await ethers.getContractFactory("CSRtoken");
    const token = await Token.deploy("Caesar", "CSR");
    await token.deployed();
    console.log(`rewardToken contract deployed to ${token.address}`);


    ///deploy Staking contract
    const Staking = await ethers.getContractFactory("gatedStaking");
    const staking = await Staking.deploy();
    const stakingContract = await staking.deployed();
    console.log(`Staking contract deployed to ${staking.address}`);


    //Impersonating
    const helpers = require("@nomicfoundation/hardhat-network-helpers");
    await helpers.impersonateAccount(ApeHolder1);
    const impersonatedSigner = await ethers.getSigner(ApeHolder1);

    await helpers.impersonateAccount(NonApeHolder);
    const impersonatedSigner1 = await ethers.getSigner(NonApeHolder);


    const Usdt = await ethers.getContractAt("IUSDT", "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48");
    await helpers.setBalance(ApeHolder1, 10000000000000000000000000);

    const approveAmount = ethers.utils.parseEther("1000");
    const approve = Usdt.connect(impersonatedSigner).approve(staking.address, approveAmount);


    //const amount = ethers.utils.parseEther("0.5");
    const userBalanceB4 = await Usdt.balanceOf(impersonatedSigner.address);
    console.log(`BALANCE BEFORE STAKING ${userBalanceB4}`);
    // const allowance = await Usdt.allowance(impersonatedSigner.address, staking.address)
    // console.log(`Contract allowance is ${allowance}`);
    

    //staking BoredApe HOlder

    // stakes = ethers.utils.parseEther("0.01");
    const stake1 = await stakingContract.connect(impersonatedSigner).stake(20000000);
    console.log(`address one staked successfully`);
    const userBalanceAfter = await Usdt.balanceOf(impersonatedSigner.address);

    console.log(`BALANCE AFTER STAKING ${userBalanceAfter}`);



    /// Non BoredApe Holder

    // const stake2 = await stakingContract.connect(impersonatedSigner1).stake(20000000);
    // console.log(`address one staked successfully`);
    // const userBalanceAfter1 = await Usdt.balanceOf(impersonatedSigner1.address);

    // console.log(`BALANCE AFTER STAKING ${userBalanceAfter1}`);














































}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });