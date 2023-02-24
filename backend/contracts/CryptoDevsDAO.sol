// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";

interface INFT_contract {
    function tokenOfOwnerByIndex(
        address owner,
        uint256 index
    ) external view returns (uint256 tokenId);

    function balanceOf(address owner) external view returns (uint256 balance);
}

interface IFakeNFTMarketplace {
    function getPrice() external view returns (uint256);

    function available(uint256 _tokenId) external view returns (bool);

    function purchase(uint256 _tokenId) external payable;
}

contract CryptoDevsDAO is Ownable {
    IFakeNFTMarketplace marketplace;
    INFT_contract nft_contract;

    struct Proposal {
        uint256 NFT_tokenId;
        uint256 yayVotes;
        uint256 nayVotes;
        uint256 deadline;
        bool executed;
        mapping(uint256 => bool) voters;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public numProposals;

    constructor(address _nft_contract, address _fakeMarketplace) {
        marketplace = IFakeNFTMarketplace(_fakeMarketplace);
        nft_contract = INFT_contract(_nft_contract);
    }

    modifier onlyNFTHolder() {
        require(nft_contract.balanceOf(msg.sender) > 0, "Not a DAO member");
        _;
    }

    // create proposal allow NFT holders to create a proposal

    function createProposal(
        uint256 _nftTokenId
    ) external onlyNFTHolder returns (uint256) {
        require(marketplace.available(_nftTokenId), "NFT not for sale");
        Proposal storage proposal = proposals[numProposals];
        proposal.NFT_tokenId = _nftTokenId;
        proposal.deadline = block.timestamp + 5 minutes;
        numProposals++;
        return numProposals - 1;
    }

    // modifier activeProposalOnly(uint256 proposalIndex) {
    //     // require(
    //     //     proposals[proposalIndex]
    //     // )
    // }

}
