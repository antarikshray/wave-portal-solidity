// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    event NewWave(address indexed from, uint256 timestamp, string message);

    uint256 private seed;

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] wavers;

    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Hey I am a smarty contracty");

        seed = (block.timestamp + block.difficulty) % 100;
    }

    function unwave() public {
        for (uint i = 0; i < wavers.length; i++) {
            if (msg.sender == wavers[i].waver) {
                wavers[i].waver = wavers[wavers.length - 1].waver;
                wavers.pop();
                console.log("%s has unwaved!", msg.sender);
                return;
            }
        }
    }

    function wave(string memory _message) public {

        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        wavers.push(Wave(msg.sender, _message, block.timestamp));
        console.log("%s waved w/ message %s", msg.sender, _message);

        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);

        if (seed < 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;

            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return wavers;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", wavers.length);
        return wavers.length;
    }

    function waveStatus() public view returns (bool) {
        for (uint i = 0; i < wavers.length; i++) {
            if (msg.sender == wavers[i].waver) {
                console.log("Wave status is true");
                return true;
            }
        }
        console.log("Wave status is false");
        return false;
    }
}
