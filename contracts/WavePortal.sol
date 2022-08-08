// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    address[] wavers;

    constructor() {
        console.log("Hey I am a smarty contracty");
    }

    function wave() public {
        for (uint i = 0; i < wavers.length; i++) {
            if (msg.sender == wavers[i]) {
                wavers[i] = wavers[wavers.length - 1];
                wavers.pop();
                console.log("%s has unwaved!", msg.sender);
                return;
            }
        }
        wavers.push(msg.sender);
        console.log("%s has waved!", msg.sender);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", wavers.length);
        return wavers.length;
    }
}
