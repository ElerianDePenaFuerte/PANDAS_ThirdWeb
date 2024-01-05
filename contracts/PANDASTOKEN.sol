// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;
pragma abicoder v2;

import "./PantosBaseToken.sol";
import "@thirdweb/contracts/extension/ContractMetadata.sol";    // Example ThrirdWeb extension -> Metadata

/**
 * @title Pantos-compatible ThirdWeb Example Token 
 */
contract PANDASTOKEN is PantosBaseToken, ContractMetadata {

    address public deployer;


    /// @dev msg.sender receives all existing tokens.
    constructor(
        string memory NAME_,
        string memory SYMBOL_,
        uint8 DECIMALS_,     
        uint256 INITIALSUPPLY_
        )
        PantosBaseToken(NAME_, SYMBOL_, DECIMALS_)
        {
            deployer = msg.sender;
            ERC20._mint(msg.sender, INITIALSUPPLY_);
        }

    /// *******************************************************************************************************
    /// Pantos Functions
    /// *******************************************************************************************************

    /// @dev See {PantosBaseToken-_setPantosForwarder}.
    function setPantosForwarder(address pantosForwarder)
        external
        onlyOwner
    {
        _setPantosForwarder(pantosForwarder);
    }

    /// *******************************************************************************************************
    /// THIRDWEB Extensions
    /// *******************************************************************************************************

    function _canSetContractURI() internal view virtual override returns (bool){
        return msg.sender == deployer;
    }




}