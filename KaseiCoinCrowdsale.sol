pragma solidity ^0.5.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";


contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale { 
    
    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        uint rate,
        address payable wallet,
        KaseiCoin token,
        uint goal, // the croadsale goal
        uint open, // crowdsale opening time
        uint close // crowdsale close time
    ) public 
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(open, close)
        RefundableCrowdsale(goal)
             {
        // constructor can stay empty
    }
}

contract KaseiCoinCrowdsaleDeployer {
    // variable to store addres of kaseiCoin address
    address public kasei_token_address;
    // variable to store address of crwodsale contract
    address public kasei_crowdsale_address;

    // Add the constructor.
    constructor(
       string memory name,
       string memory symbol,
       address payable wallet,
       uint goal
    ) public {
        // Create a new instance of the KaseiCoin contract. Assign it to our defined address variable for it.
        KaseiCoin token = new KaseiCoin(name, symbol, 0);
        kasei_token_address = address(token);

        // Create a new instance of the `KaseiCoinCrowdsale` contract. Assign it to the address variable we defined.
        KaseiCoinCrowdsale kasei_crowdsale = new KaseiCoinCrowdsale(1, wallet, token, goal, now, now + 24 weeks);
        kasei_crowdsale_address = address(kasei_crowdsale);
            
        // Set the `KaseiCoinCrowdsale` contract as a minter
        token.addMinter(kasei_crowdsale_address);
        token.renounceMinter();
    }
}      
