// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;

import "../Interfaces/IPriceFeed.sol";
import "../Dependencies/Ownable.sol";

/*
* PriceFeed placeholder for testnet and development. The price is simply set manually and saved in a state 
* variable. The contract does not connect to a live Chainlink price feed. 
*/
contract PriceFeedTestnet is Ownable, IPriceFeed {
    address oracle;
    uint256 private _price = 200 * 1e18;

    modifier onlyOracleOrOwner() {
        require(msg.sender == oracle || msg.sender == owner(), "PriceFeedTestnet: Only oracle or owner can call this function");
        _;
    }

    // --- Functions ---

    // View price getter for simplicity in tests
    function getPrice() external view returns (uint256) {
        return _price;
    }

    function fetchPrice() external override returns (uint256) {
        // Fire an event just like the mainnet version would.
        // This lets the subgraph rely on events to get the latest price even when developing locally.
        emit LastGoodPriceUpdated(_price);
        return _price;
    }

    // Manual external price setter.
    function setPrice(uint256 price) external onlyOracleOrOwner returns (bool) {
        _price = price;
        return true;
    }

    function setOracle(address _oracle) external onlyOwner {
        oracle = _oracle;
    }
}
