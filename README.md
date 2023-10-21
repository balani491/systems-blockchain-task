# systems-blockchain-task(Rahul Balani-221DS009)
A smart contract for Decentralized Crowdfunding coded using Solidity
Here first i have created a struct called Campaign which is a data type i created and using that i created an array of Campaignd data type
Now i have two modifiers i.e onlyCampaignCreator and  campaignIsOpen which would help me to check conditions during a function call
The functions that i have made are 
1.createCampaign : which is used to create a campaign which takes the arguments such as cause ,goal,start and end date and goalAmount
2.contributeFunds: which is used to contribute funds to a certain campaignID and it uses the modifier to check whether the campaign creator  is not calling the function 
3.getAvailableCampaigns: this returns an array of available campaigns i.e the id
4.closeCampaign:which closes a campaign if a creator of that campaign wants to
5.withdrawFunds:which allows the creator to withdraw fund when goalamount is reached and campaign is closed.



https://sepolia.etherscan.io/tx/0x57c03e5bc743914c5b04ce40ee15621494732ebaa21ba5dbb78c0f817d2463c7(this is where i deployed my smart contract using sepolia testnet)
