// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/tokens/ERC721/ERC721.sol";
import "@openzeppelin/contracts/tokens/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @dev Requirements
 * [x] Random
 * [x] Delayed Reveal
 * [x] Batch Airdrops
 * [ ] Royalty
 */

contract ApexDrop is ERC721, ERC721Enumerable, Ownable, ReentrancyGuard {

    // ========== VARIABLES ==========

	uint256 _tokenId;
    string storage _apexBaseURI = "* INSERT APEX BASEURI *";

    // ========== EVENTS ==========

    // event Minted(); // emit details regarding individual drops/mints
    // event Dropped(); // emit details regarding the batch

	constructor() ERC721('Apex Watch Club', 'AWC') Ownable(address(msg.sender)) {}

    // ========== WRITE ==========

	function mint(address to) internal onlyOwner {
		_tokenId++;
		_safeMint(to, _tokenId)
	}


	function drop(address[] recipients) public onlyOwner {
		uint256 count = recipients.length;
		for (uint256 i = 0; i < count; i++) {
			mint(recipients[i]);
		}
	}

    /**
     * @dev Mainly used for delayed reveal
     */
    function setBaseURI(string memory newBaseUri) public onlyOwner {
        _apexBaseURI = newBaseUri;
    }

    // ========== READ ==========

    function _baseURI() internal view override returns (string memory) {
        return _apexBaseURI;
    }
}
