// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERCTokenVesting.sol";

contract BLEXToken is ERCTokenVesting {

    uint tokenLaunchTime;

    struct InstantBeneficiary {
        address beneficiary;
        uint256 amount;
    }

    uint seedSaleAmount = 50000000;
    uint publicSaleAmount = 20000000;
    uint privateSaleAmount = 110000000;
    uint ecosystemAmount = 500000000;
    uint liquidityAmount = 20000000;
    uint marketingAmount = 150000000;
    uint teamAmount = 100000000;
    uint advisorsAmount = 50000000;

    uint256 private vestingPeriod = 86400000;             // 1 day
    uint256 private monthPeriod = 2629800000;             // 30.4375 days

    uint256 private seedsaleVestingStart = tokenLaunchTime;
    uint256 private seedsaleVestingDuration = 12 * monthPeriod;
    uint256 private seedsaleVestingTGE = 5;

    uint256 private privateSaleVestingStart = tokenLaunchTime;
    uint256 private privateSaleVestingDuration = 6 * monthPeriod;
    uint256 private privateSaleTGE = 10;

    uint256 private publicSaleVestingStart = tokenLaunchTime;
    uint256 private publicSaleVestingDuration = 2 * monthPeriod;
    uint256 private publicSaleTGE = 20;

    uint256 private ecosystemVestingLockupPeriod = 1 * monthPeriod;
    uint256 private ecosystemVestingStart = tokenLaunchTime + ecosystemVestingLockupPeriod;
    uint256 private ecosystemVestingDuration = 40 * monthPeriod;

    uint256 private liquidityVestingStart = tokenLaunchTime;
    uint256 private liquidityVestingDuration = 0;

    uint256 private teamVestingLockupPeriod = 12 * monthPeriod;
    uint256 private teamVestingStart = tokenLaunchTime + teamVestingLockupPeriod;
    uint256 private teamVestingDuration = 20 * monthPeriod;

    uint256 private advisorsVestingLockupPeriod = 12 * monthPeriod;
    uint256 private advisorsVestingStart = tokenLaunchTime + advisorsVestingLockupPeriod;
    uint256 private advisorsVestingDuration = 20 * monthPeriod;

    uint256 private marketingVestingLockupPeriod = 1 * monthPeriod;
    uint256 private marketingVestingStart = tokenLaunchTime + marketingVestingLockupPeriod;
    uint256 private marketingVestingDuration = 20 * monthPeriod;

    address[] private seedsaleVestingAddresses;
    address[] private privateSaleVestingAddresses;
    address[] private publicSaleVestingAddresses;
    address[] private ecosystemVestingAddresses;
    address[] private liquidityVestingAddresses;
    address[] private teamVestingAddresses;
    address[] private advisorsVestingAddresses;
    address[] private marketingVestingAddresses;

    InstantBeneficiary public seedSaleBeneficiary;
    InstantBeneficiary public publicSaleBeneficiary;
    InstantBeneficiary public privateSaleBeneficiary;
    InstantBeneficiary public ecosystemBeneficiary;
    InstantBeneficiary public liquidityBeneficiary;
    InstantBeneficiary public teamBeneficiary;
    InstantBeneficiary public advisorsBeneficiary;
    InstantBeneficiary public marketingBeneficiary;

    constructor(address seedSaleAddress,
        address publicSaleAddress,
        address privateSaleAddress,
        address ecosystemAddress,
        address liquidityAddress,
        address teamAddress,
        address advisorsAddress,
        address marketingAddress) ERC20("BITLEVEX token", "BLEX") {
             _mint(address(this), 1000000000 ** decimals());
             tokenLaunchTime = block.timestamp;

             _transfer(address(this), seedSaleAddress, seedSaleAmount);
             _transfer(address(this), publicSaleAddress, publicSaleAmount);
             _transfer(address(this), privateSaleAddress, privateSaleAmount);
             _transfer(address(this), ecosystemAddress, ecosystemAmount);
             _transfer(address(this), liquidityAddress, liquidityAmount);
             _transfer(address(this), teamAddress, teamAmount);
             _transfer(address(this), advisorsAddress, advisorsAmount);
             _transfer(address(this), marketingAddress, marketingAmount);

             seedSaleBeneficiary = InstantBeneficiary(seedSaleAddress, seedSaleAmount);
             publicSaleBeneficiary = InstantBeneficiary(publicSaleAddress, publicSaleAmount);
             privateSaleBeneficiary = InstantBeneficiary(privateSaleAddress, privateSaleAmount);
             ecosystemBeneficiary = InstantBeneficiary(ecosystemAddress, ecosystemAmount);
             liquidityBeneficiary = InstantBeneficiary(liquidityAddress, liquidityAmount);
             teamBeneficiary = InstantBeneficiary(teamAddress, teamAmount);
             advisorsBeneficiary = InstantBeneficiary(advisorsAddress, advisorsAmount);
             marketingBeneficiary = InstantBeneficiary(marketingAddress, marketingAmount);
     }

    /**
    * @notice Adds beneficiary and amount for seed sale vesting
    *         One address can participate in one vesting
    *
    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
    * @param amount total amount of tokens to be released at the end of the vesting
    */
    function addSeedsaleVestingAddress(address beneficiary, uint256 amount) onlyOwner external {
        _createVestingSchedule(
            beneficiary,
            seedsaleVestingStart,
            seedsaleVestingDuration,
            vestingPeriod,
            amount,
            amount / 100 * seedsaleVestingTGE);
        seedsaleVestingAddresses.push(beneficiary);
    }

    /**
    * @notice Adds beneficiary and amount for private sale vesting
    *         One address can participate in one vesting
    *
    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
    * @param amount total amount of tokens to be released at the end of the vesting
    */
    function addPrivateSaleVestingAddress(address beneficiary, uint256 amount) onlyOwner external {
        _createVestingSchedule(
            beneficiary,
            privateSaleVestingStart,
            privateSaleVestingDuration,
            vestingPeriod,
            amount,
            amount / 100 * privateSaleTGE);
        privateSaleVestingAddresses.push(beneficiary);
    }

    /**
    * @notice Adds beneficiary and amount for public sale vesting
    *         One address can participate in one vesting
    *
    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
    * @param amount total amount of tokens to be released at the end of the vesting
    */
    function addPublicSaleVestingAddress(address beneficiary, uint256 amount) onlyOwner external {
        _createVestingSchedule(
            beneficiary,
            publicSaleVestingStart,
            publicSaleVestingDuration,
            vestingPeriod,
            amount,
            amount / 100 * publicSaleTGE);
        publicSaleVestingAddresses.push(beneficiary);
    }

    /**
    * @notice Adds beneficiary and amount for ecosustem vesting
    *         One address can participate in one vesting
    *
    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
    * @param amount total amount of tokens to be released at the end of the vesting
    */
    function addEcosystemVestingAddress(address beneficiary, uint256 amount) onlyOwner external {
        _createVestingSchedule(
            beneficiary,
            ecosystemVestingStart,
            ecosystemVestingDuration,
            vestingPeriod,
            amount,
            0);
        ecosystemVestingAddresses.push(beneficiary);
    }

    /**
    * @notice Adds beneficiary and amount for liquidity vesting
    *         One address can participate in one vesting
    *
    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
    * @param amount total amount of tokens to be released at the end of the vesting
    */
    function addLiquidityVestingAddress(address beneficiary, uint256 amount) onlyOwner external {
        _createVestingSchedule(
            beneficiary,
            liquidityVestingStart,
            liquidityVestingDuration,
            vestingPeriod,
            amount,
            amount);
        liquidityVestingAddresses.push(beneficiary);
    }

    /**
    * @notice Adds beneficiary and amount for team vesting
    *         One address can participate in one vesting
    *
    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
    * @param amount total amount of tokens to be released at the end of the vesting
    */
    function addTeamVestingAddress(address beneficiary, uint256 amount) onlyOwner external {
        _createVestingSchedule(
            beneficiary,
            teamVestingStart,
            teamVestingDuration,
            vestingPeriod,
            amount,
            0);
        teamVestingAddresses.push(beneficiary);
    }

    /**
    * @notice Adds beneficiary and amount for advisor vesting
    *         One address can participate in one vesting
    *
    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
    * @param amount total amount of tokens to be released at the end of the vesting
    */
    function addAdvisorVestingAddress(address beneficiary, uint256 amount) onlyOwner external {
        _createVestingSchedule(
            beneficiary,
            advisorsVestingStart,
            advisorsVestingDuration,
            vestingPeriod,
            amount,
            0);
        advisorsVestingAddresses.push(beneficiary);
    }

    /**
    * @notice Adds beneficiary and amount for marketing vesting
    *         One address can participate in one vesting
    *
    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
    * @param amount total amount of tokens to be released at the end of the vesting
    */
    function addMarketingVestingAddress(address beneficiary, uint256 amount) onlyOwner external {
        _createVestingSchedule(
            beneficiary,
            marketingVestingStart,
            marketingVestingDuration,
            vestingPeriod,
            amount,
            0);
        marketingVestingAddresses.push(beneficiary);
    }

    /**
    * @notice Returns the number of benefeciary for seed sale vesting
    * @return the number of benefeciary
    */
    function getSeedSaleVestingAddressCount() external view returns(uint256) {
        return seedsaleVestingAddresses.length;
    }

    /**
    * @notice Returns the number of benefeciary for private sale vesting
    * @return the number of benefeciary
    */
    function getPrivateSaleVestingAddressCount() external view returns(uint256) {
        return privateSaleVestingAddresses.length;
    }

    /**
    * @notice Returns the number of benefeciary for public sale vesting
    * @return the number of benefeciary
    */
    function getPublicSaleVestingAddressCount() external view returns(uint256) {
        return publicSaleVestingAddresses.length;
    }

    /**
    * @notice Returns the number of benefeciary for ecosystem vesting
    * @return the number of benefeciary
    */
    function getEcosystemVestingAddressCount() external view returns(uint256) {
        return ecosystemVestingAddresses.length;
    }

    /**
    * @notice Returns the number of benefeciary for liquidity vesting
    * @return the number of benefeciary
    */
    function getLiquidityAddressCount() external view returns(uint256) {
        return liquidityVestingAddresses.length;
    }

    /**
    * @notice Returns the number of benefeciary for team vesting
    * @return the number of benefeciary
    */
    function getTeamVestingAddressCount() external view returns(uint256) {
        return teamVestingAddresses.length;
    }

    /**
    * @notice Returns the number of benefeciary for advisor vesting
    * @return the number of benefeciary
    */
    function getAdvisorAddressCount() external view returns(uint256) {
        return advisorsVestingAddresses.length;
    }

    /**
    * @notice Returns the number of benefeciary for marketing vesting
    * @return the number of benefeciary
    */
    function getMarketingVestingAddressCount() external view returns(uint256) {
        return marketingVestingAddresses.length;
    }

    /**
    * @notice Returns the benefeciary by index for seed sale vesting
    * @param index beneficiary index for seed sale vesting
    * @return the address of benefeciary
    */
    function getSeedSaleVestingAddress(uint256 index) external view returns(address) {
        require(index < seedsaleVestingAddresses.length, "Invalid address index");
        return seedsaleVestingAddresses[index];
    }

    /**
    * @notice Returns the benefeciary by index for private sale vesting
    * @param index beneficiary index for private sale vesting
    * @return the address of benefeciary
    */
    function getPrivateSaleVestingAddress(uint256 index) external view returns(address) {
        require(index < privateSaleVestingAddresses.length, "Invalid address index");
        return privateSaleVestingAddresses[index];
    }

    /**
    * @notice Returns the benefeciary by index for public sale vesting
    * @param index beneficiary index for public sale vesting
    * @return the address of benefeciary
    */
    function getPublicSaleVestingAddress(uint256 index) external view returns(address) {
        require(index < publicSaleVestingAddresses.length, "Invalid address index");
        return publicSaleVestingAddresses[index];
    }

    /**
    * @notice Returns the benefeciary by index for ecosystem vesting
    * @param index beneficiary index for ecosystem vesting
    * @return the address of benefeciary
    */
    function getEcosystemVestingAddress(uint256 index) external view returns(address) {
        require(index < ecosystemVestingAddresses.length, "Invalid address index");
        return ecosystemVestingAddresses[index];
    }

    /**
    * @notice Returns the benefeciary by index for liquidity vesting
    * @param index beneficiary index for liquidity vesting
    * @return the address of benefeciary
    */
    function getLiquidityVestingAddress(uint256 index) external view returns(address) {
        require(index < liquidityVestingAddresses.length, "Invalid address index");
        return liquidityVestingAddresses[index];
    }

    /**
    * @notice Returns the benefeciary by index for team vesting
    * @param index beneficiary index for team vesting
    * @return the address of benefeciary
    */
    function getTeamVestingAddress(uint256 index) external view returns(address) {
        require(index < teamVestingAddresses.length, "Invalid address index");
        return teamVestingAddresses[index];
    }

    /**
    * @notice Returns the benefeciary by index for advisor vesting
    * @param index beneficiary index for advisor vesting
    * @return the address of benefeciary
    */
    function getAdvisorVestingAddress(uint256 index) external view returns(address) {
        require(index < advisorsVestingAddresses.length, "Invalid address index");
        return advisorsVestingAddresses[index];
    }

    /**
    * @notice Returns the benefeciary by index for marketing vesting
    * @param index beneficiary index for ecosystem vesting
    * @return the address of benefeciary
    */
    function getMarketingVestingAddress(uint256 index) external view returns(address) {
        require(index < marketingVestingAddresses.length, "Invalid address index");
        return marketingVestingAddresses[index];
    }

}
