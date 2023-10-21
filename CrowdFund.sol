// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FundingPlatform {
    struct Campaign {
        address creator;
        string cause;
        string futurePlans;
        uint256 startDate;
        uint256 endDate;
        uint256 goalAmount;
        uint256 totalFundsRaised;
        bool isOpen;
    }

    Campaign[] public campaigns;

    uint256 public campaignCount;

    constructor() {
        campaignCount = 0;
    }

    modifier onlyCampaignCreator(uint256 campaignId) {
        require(campaigns[campaignId].creator == msg.sender, "Only campaign creator can perform this action");
        _;
    }

    modifier campaignIsOpen(uint256 campaignId) {
        require(campaigns[campaignId].isOpen, "Campaign is closed");
        _;
    }

    function createCampaign(
        string memory cause,
        string memory futurePlans,
        uint256 startDate,
        uint256 endDate,
        uint256 goalAmount
    ) public {
        require(startDate < endDate, "End date must be after the start date");
        campaigns.push(Campaign({
            creator: msg.sender,
            cause: cause,
            futurePlans: futurePlans,
            startDate: startDate,
            endDate: endDate,
            goalAmount: goalAmount,
            totalFundsRaised: 0,
            isOpen: true
        }));
        campaignCount++;
    }

    function contributeFunds(uint256 campaignId, uint256 amt) public payable campaignIsOpen(campaignId) {
        require(amt > 0, "Funding amount must be greater than 0");
        require(campaigns[campaignId].creator != msg.sender, "Campaign creator cannot fund their own campaign");

        campaigns[campaignId].totalFundsRaised += amt;
        if(campaigns[campaignId].totalFundsRaised >= campaigns[campaignId].goalAmount){
            campaigns[campaignId].isOpen=false;
        }

    }

    function getAvailableCampaigns() public view returns (uint256[] memory) {
        uint256[] memory availableCampaigns = new uint256[](campaignCount);
        uint256 count = 0;

        for (uint256 i = 0; i < campaignCount; i++) {
            if (campaigns[i].isOpen) {
                availableCampaigns[count] = i;
                count++;
            }
        }

        // Dynamically resize the array to the actual number of available campaigns
        uint256[] memory result = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            result[i] = availableCampaigns[i];
        }

        return result;
    }

    function closeCampaign(uint256 campaignId) public onlyCampaignCreator(campaignId) campaignIsOpen(campaignId) {
        campaigns[campaignId].isOpen = false;
    }

    function withdrawFunds(uint256 campaignId) public onlyCampaignCreator(campaignId) {
        require(!campaigns[campaignId].isOpen, "Cannot withdraw funds until the campaign is closed");
        require(campaigns[campaignId].totalFundsRaised >= campaigns[campaignId].goalAmount, "Goal not reached");

        address payable creator = payable(msg.sender);
        uint256 amount = campaigns[campaignId].totalFundsRaised;
        campaigns[campaignId].totalFundsRaised = 0;
        creator.transfer(amount);
    }
}
